let Hooks = {}
let callCount = 0;

Hooks.GetSVG = {
    mounted() {
        this.el.addEventListener("mousemove", e => {
            if(window.userSVG && (++callCount % 50) == 0) {
                const img = 'data:image/svg+xml;base64,' + btoa(window.userSVG);
                this.pushEvent("drawit", img)
            }

        })
    }
}

export default Hooks