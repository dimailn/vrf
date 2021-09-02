import Resource from '@/mixins/resource';

import set from '@/utils/set';

import get from '@/utils/get';

import evalBoolProp from '@/utils/eval-bool-prop';

import Translate from '@/mixins/translate';

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
