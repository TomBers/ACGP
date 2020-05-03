import "../css/app.scss"

import "phoenix_html"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

import { connect, call, answerCall, receiveRemote, disconnect } from "./video.js"
import Hooks from "./hooks.js"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks});
liveSocket.connect()

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Attach functions to window
window.socket = socket
window.videoConnect = connect
window.videoCall = call
window.answerCall = answerCall
window.receiveRemote = receiveRemote
window.videoDisconnect = disconnect



