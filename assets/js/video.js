export async function connect(disconnectButton, callButton, devices, mediaConstraints, localVideo, channel) {
    disconnectButton.disabled = false;
    callButton.disabled = false;
    const localStream = await devices.getUserMedia(mediaConstraints);
    setVideoStream(localVideo, localStream);
    peerConnection = createPeerConnection(localStream, channel);
    return peerConnection
  }

export async function call(peerConnection, channel) {
    let offer = await peerConnection.createOffer();
    peerConnection.setLocalDescription(offer);
    pushPeerMessage('video-offer', offer, channel);
 }

export async function answerCall(offer, peerConnection, channel) {
     receiveRemote(offer, peerConnection);
     let answer = await peerConnection.createAnswer();
     peerConnection
     .setLocalDescription(answer)
     .then(() =>
     pushPeerMessage('video-answer', peerConnection.localDescription, channel)
   );
 }


  function createPeerConnection(stream, channel) {
    let pc = new RTCPeerConnection({
      iceServers: [
        // Information about ICE servers - Use your own!
        {
          urls: 'stun:stun.stunprotocol.org',
        },
      ],
    });
    pc.ontrack = handleOnTrack;
    pc.onicecandidate = (event) => handleIceCandidate(event, channel);
    stream.getTracks().forEach(track => pc.addTrack(track));
    return pc;
  }

  function handleOnTrack(event) {
    console.log(event);
    remoteStream.addTrack(event.track);
  }

  function handleIceCandidate(event, channel) {
    if (!!event.candidate) {
      pushPeerMessage('ice-candidate', event.candidate, channel);
    }
  }

export function disconnect(disconnectButton, callButton, localVideo, remoteVideo, peerConnection, channel) {
    disconnectButton.disabled = true;
    callButton.disabled = true;
    unsetVideoStream(localVideo);
    unsetVideoStream(remoteVideo);
    peerConnection.close();
    peerConnection = null;
    remoteStream = new MediaStream();
    setVideoStream(remoteVideo, remoteStream);
    pushPeerMessage('disconnect', {}, channel);
  }

export function receiveRemote(offer, peerConnection) {
    let remoteDescription = new RTCSessionDescription(offer);
    peerConnection.setRemoteDescription(remoteDescription);
  }

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

function pushPeerMessage(type, content, channel) {
    console.log('CHANNEL')
    console.log(channel)
  channel.push('peer-message', {
    body: JSON.stringify({
      type,
      content,
    }),
  });
}