import "../css/app.scss"

import "phoenix_html"

import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

import paper from "paper"

import Hooks from "./hooks.js"

import Abundance from "./abundance.js"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks });
liveSocket.connect()

let socket = new Socket("/socket", { params: { token: window.userToken } })

socket.connect()

// Attach functions to window
window.socket = socket

window.globals = {};

window.Abundance = Abundance;


document.addEventListener('DOMContentLoaded', () => {
    // Get all "navbar-burger" elements
    const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

    // Check if there are any navbar burgers
    if ($navbarBurgers.length > 0) {

        // Add a click event on each of them
        $navbarBurgers.forEach(el => {
            el.addEventListener('click', () => {

                // Get the target from the "data-target" attribute
                const target = el.dataset.target;
                const $target = document.getElementById(target);

                // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
                el.classList.toggle('is-active');
                $target.classList.toggle('is-active');

            });
        });
    }

});



