// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
import "phoenix_html"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect()


import channel from './socket';


function pushPeerMessage(type, content) {
  channel.push('peer-message', {
    body: JSON.stringify({
      type,
      content,
    }),
  });
}

const mediaConstraints = {
  audio: true,
  video: true,
};

const devices = navigator.mediaDevices;

const connectButton = document.getElementById('connect');
const callButton = document.getElementById('call');
const disconnectButton = document.getElementById('disconnect');

const remoteVideo = document.getElementById('remote-stream');
const localVideo = document.getElementById('local-stream');

let peerConnection;
let remoteStream = new MediaStream();

setVideoStream(remoteVideo, remoteStream);

disconnectButton.disabled = true;
callButton.disabled = true;
connectButton.onclick = connect;
callButton.onclick = call;
disconnectButton.onclick = disconnect;

async function connect() {
  connectButton.disabled = true;
  disconnectButton.disabled = false;
  callButton.disabled = false;
  const localStream = await devices.getUserMedia(mediaConstraints);
  setVideoStream(localVideo, localStream);
  peerConnection = createPeerConnection(localStream);
}

async function call() {
  let offer = await peerConnection.createOffer();
  peerConnection.setLocalDescription(offer);
  pushPeerMessage('video-offer', offer);
}

function createPeerConnection(stream) {
  let pc = new RTCPeerConnection({
    iceServers: [
      // Information about ICE servers - Use your own!
      {
        urls: 'stun:stun.stunprotocol.org',
      },
    ],
  });
  pc.ontrack = handleOnTrack;
  pc.onicecandidate = handleIceCandidate;
  stream.getTracks().forEach(track => pc.addTrack(track));
  return pc;
}

function handleOnTrack(event) {
  log(event);
  remoteStream.addTrack(event.track);
}

function handleIceCandidate(event) {
  if (!!event.candidate) {
    pushPeerMessage('ice-candidate', event.candidate);
  }
}

function disconnect() {
  connectButton.disabled = false;
  disconnectButton.disabled = true;
  callButton.disabled = true;
  unsetVideoStream(localVideo);
  unsetVideoStream(remoteVideo);
  peerConnection.close();
  peerConnection = null;
  remoteStream = new MediaStream();
  setVideoStream(remoteVideo, remoteStream);
  pushPeerMessage('disconnect', {});
}

function receiveRemote(offer) {
  let remoteDescription = new RTCSessionDescription(offer);
  peerConnection.setRemoteDescription(remoteDescription);
}

async function answerCall(offer) {
  receiveRemote(offer);
  let answer = await peerConnection.createAnswer();
  peerConnection
    .setLocalDescription(answer)
    .then(() =>
      pushPeerMessage('video-answer', peerConnection.localDescription)
    );
}

channel.on('peer-message', payload => {
  const message = JSON.parse(payload.body);
  switch (message.type) {
    case 'video-offer':
      log('offered: ', message.content);
      answerCall(message.content);
      break;
    case 'video-answer':
      log('answered: ', message.content);
      receiveRemote(message.content);
      break;
    case 'ice-candidate':
      log('candidate: ', message.content);
      let candidate = new RTCIceCandidate(message.content);
      peerConnection
        .addIceCandidate(candidate)
        .catch(reportError('adding and ice candidate'));
      break;
    case 'disconnect':
      disconnect();
      break;
    default:
      reportError('unhandled message type')(message.type);
  }
});

function setVideoStream(videoElement, stream) {
  videoElement.srcObject = stream;
}

function unsetVideoStream(videoElement) {
  if (videoElement.srcObject) {
    videoElement.srcObject.getTracks().forEach(track => track.stop());
  }
  videoElement.removeAttribute('src');
  videoElement.removeAttribute('srcObject');
}

const reportError = where => error => {
  console.error(where, error);
};

function log() {
  console.log(...arguments);
}
