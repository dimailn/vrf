export default {
  computed: {
    $templates() {
      const {name} = this.$options

      if (!name) {
        console.error("[vrf] Component doesn't have a name, can't find the templates")
      }

      return this.VueResourceForm.templates[name.substr(3)] || {}
    }
  }
}