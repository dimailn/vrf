export default {
  methods: {
    t: function(property, modelName = this.$translationName, options = {}) {
      const translate = this.$root.$.appContext.config.globalProperties.VueResourceForm.translate

      if (!translate) {
        return property
      }

      const propertyName = options.isAction ? `$${property}` : property

      const translationFromModelScope = translate.call(this, propertyName, modelName)

      if (translationFromModelScope === null) {
        const translationFromVrfScope = translate.call(this, propertyName, null)

        if (translationFromVrfScope !== null) {
          return translationFromVrfScope
        }

        return property
      }

      return translationFromModelScope
    }
  }
};
