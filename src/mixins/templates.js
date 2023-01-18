export default {
  computed: {
    $templates() {
      const {name} = this.$options

      const vue = Object.getPrototypeOf(this.$root).constructor

      if (!name) {
        console.error("[vrf] Component doesn't have a name, can't find the templates")
      }

      return vue.prototype.VueResourceForm.templates[name.substr(3)] || {}
    }
  }
}