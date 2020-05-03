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

export default Hooks