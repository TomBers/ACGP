export async function connect(devices, localVideo, remoteStream,  channel) {
  const mediaConstraints = {
      audio: true,
      video: true,
    };
    const localStream = await devices.getUserMedia(mediaConstraints);
    setVideoStream(localVideo, localStream);
    return createPeerConnection(localStream, remoteStream, channel);
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


  function createPeerConnection(stream, remoteStream, channel) {
    let pc = new RTCPeerConnection({
      iceServers: [
        // Information about ICE servers - Use your own!
        {
          urls: 'stun:stun.stunprotocol.org',
        },
      ],
    });
    pc.ontrack = (event) => handleOnTrack(event, remoteStream);
    pc.onicecandidate = (event) => handleIceCandidate(event, channel);
    stream.getTracks().forEach(track => pc.addTrack(track));
    return pc;
  }

  function handleOnTrack(event, remoteStream) {
    console.log(event);
    remoteStream.addTrack(event.track);
  }

  function handleIceCandidate(event, channel) {
    if (!!event.candidate) {
      pushPeerMessage('ice-candidate', event.candidate, channel);
    }
  }

export function disconnect(localVideo, remoteVideo, peerConnection, channel) {
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
  channel.push('peer-message', {
    body: JSON.stringify({
      type,
      content,
    }),
  });
}
