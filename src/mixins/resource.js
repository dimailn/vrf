const FIELDS_FROM_CONTEXT = [
  'resource',
  'sources',
  'fetching',
  'vuex',
  'rfName',
  'errors',
  'submit',
  'saving',
  'form',
  'actionResults',
  'actionPendings',
  'lastSaveFailed',
  'requireSource',
  'translationName',
  'rootResource',
  'formDisabled',
  'formReadonly',
  'scope'
]

export default {
  inject: {
    vrf: {
      default: {
        wrapper: {}
      }
    }
  },
  computed: {
    ...Object.fromEntries(
      FIELDS_FROM_CONTEXT.map(propertyName => [
        `$${propertyName}`,
        function() {
          return this.vrf.wrapper[propertyName]
        }
      ])
    )
  }
}
