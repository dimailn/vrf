import Base from './base';

const validateProps = function(){
  if(!this.name && this.value === undefined){
    console.warn("[vrf] Name or value must be specified for vrf input")
  }
}

export default {
  extends: Base,
  props: {
    name: {
      type: String
    },
    value: {
      type: undefined,
      default: undefined
    },
    disabled: {
      type: [Boolean, String],
      default: void 0
    },
    readonly: {
      type: [Boolean, String],
      default: void 0
    },
    placeholder: {
      type: String
    },
    tabindex: {
      type: String
    },
    noLabel: Boolean,
    label: String,
    required: Boolean
  },
  updated: validateProps,
  created() {
    validateProps.call(this)

    this.$scope && this.name && this.$scope.emit('initialized', this.name)
  },
};
