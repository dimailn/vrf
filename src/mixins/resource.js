import evalBoolProp from '@/utils/eval-bool-prop';

export default {
  inject: {
    vrf: {
      default: {
        wrapper: {}
      }
    }
  },
  computed: {
    $resource: function() {
      return this.vrf.wrapper.resource;
    },
    $sources: function() {
      return this.$form.$sources
    },
    resource: function() {
      console.warn('[vrf] Field resource in Resource mixin deprecated, use $resource instead.');
      return this.$resource;
    },
    resources: function() {
      console.warn('[vrf] Field resources in Resource mixin deprecated, use $sources instead.');
      return this.$sources;
    },
    $formDisabled: function() {
      return evalBoolProp(this.vrf.wrapper.disabled, this);
    },
    formDisabled: function() {
      console.warn('[vrf] Field formDisabled in Resource mixin deprecated, use $formDisabled instead.');
      return this.$formDisabled;
    },
    $formReadonly: function() {
      return evalBoolProp(this.vrf.wrapper.readonly, this);
    },
    fetching: function() {
      return this.vrf.wrapper.fetching;
    },
    vuex: function() {
      return this.vrf.wrapper.vuex;
    },
    pathService: function() {
      return this.vrf.wrapper.pathService;
    },
    $rfName: function() {
      return this.vrf.wrapper.rfName;
    },
    $errors: function() {
      return this.vrf.wrapper.errors;
    },
    $submit: function() {
      return this.vrf.wrapper.submit;
    },
    $saving: function() {
      return this.vrf.wrapper.saving;
    },
    $form: function() {
      return this.vrf.wrapper.form;
    },
    rootResource: function() {
      console.warn('[vrf] Field rootResource in Resource mixin deprecated, use $rootResource instead.');
      return this.$rootResource;
    },
    $rootResource: function() {
      return this.vrf.wrapper.rootResource || this.$resource;
    },
    $actionResults: function() {
      return this.vrf.wrapper.actionResults;
    },
    $actionPendings: function() {
      return this.vrf.wrapper.actionPendings;
    },
    $lastSaveFailed: function() {
      return this.vrf.wrapper.lastSaveFailed;
    },
    $requireSource: function() {
      return this.vrf.wrapper.requireSource;
    },
    $translationName: function() {
      return this.vrf.wrapper.translationName;
    }
  }
};
