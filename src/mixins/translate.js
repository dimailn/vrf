export default {
  methods: {
    t: function(property, modelName = this.$translationName, options = {}) {
      const vue = Object.getPrototypeOf(this.$root).constructor
      const translate = vue.prototype.VueResourceForm.translate

      if (!translate) {
        return property
      }

      if (options.isAction) {
        property = `$${property}`
      }

      const translationFromModelScope = translate.call(this, property, modelName)

      if (translationFromModelScope === null) {
        const translationFromVrfScope = translate.call(this, property, '$vrf')

        if (translationFromVrfScope !== null) {
          return translationFromVrfScope
        }

        return property
      }

      return translationFromModelScope
    }
  }
};
