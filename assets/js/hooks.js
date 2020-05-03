let Hooks = {}
Hooks.PhoneNumber = {
  mounted() {
    this.el.addEventListener("input", e => {
        console.log('Hook called')
        this.pushEvent("drawit", this.el.value)
//        let match = this.el.value.replace(/\D/g, "").match(/^(\d{3})(\d{3})(\d{4})$/)

    })
  }
}

Hooks.GetSVG = {
    mounted() {
        this.el.addEventListener("mouseup", e => {
            console.log('Mouse up')
            if(window.userSVG) {
                this.pushEvent("drawit", window.userSVG)
            }

        })
    }
}

export default Hooks