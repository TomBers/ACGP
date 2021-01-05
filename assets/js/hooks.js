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
        this.el.addEventListener("newSnapshot", e => {
            this.pushEvent("updateCells", e.detail.cells)
        })
    }
}

Hooks.Cells = {
    updated() {
        const cells = this.el.getAttribute('data-cells')
        window.updateBoard(JSON.parse(cells))
    }
}

export default Hooks