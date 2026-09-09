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
      default: {}
    }
  },
  computed: {
    ...Object.fromEntries(
      FIELDS_FROM_CONTEXT.map(propertyName => [
        `$${propertyName}`,
        function() {
          return this.vrf[propertyName]
        }
      ])
    ),
    ...Object.fromEntries(
      [
        'vuex',
        'fetching',
        'resource',
        'formDisabled',
        'rootResource'
      ].map(propertyName => [
        propertyName,
        function() {
          console.warn(`[vrf] Field ${propertyName} in Resource mixin deprecated, use $${propertyName} instead.`);

          return this.vrf[propertyName]
        }
      ])
    ),
    resources: function() {
      console.warn('[vrf] Field resources in Resource mixin deprecated, use $sources instead.');
      return this.$sources;
    }
  }
}
