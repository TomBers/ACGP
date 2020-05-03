let Hooks = {}

Hooks.GetSVG = {
    mounted() {
        this.el.addEventListener("mouseup", e => {
            if(window.userSVG) {
                this.pushEvent("drawit", window.userSVG)
            }

        })
    }
}

export default Hooks