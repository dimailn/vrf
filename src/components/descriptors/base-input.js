import Base from './base';

export default {
  extends: Base,
  props: {
    name: {
      type: String,
      required: true
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
  }
};
