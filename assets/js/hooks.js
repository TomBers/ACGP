let Hooks = {}
let callCount = 0;

Hooks.GetSVG = {
    mounted() {
        this.el.addEventListener("mouseup", e => {
//            if(window.userSVG && (++callCount % 20) == 0) {
                const img = 'data:image/svg+xml;base64,' + btoa(window.userSVG);
                this.pushEvent("drawit", img)
//            }

        })
    }
}

Hooks.SendCells = {
    mounted() {
        this.el.addEventListener("mouseup", e => {
            const snapshot = 'data:image/svg+xml;base64,' + btoa(window.cells);
            this.pushEvent("updateCells", snapshot)
        })
    }
}

export default Hooks