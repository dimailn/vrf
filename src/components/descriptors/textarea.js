import BaseInput from '@/components/descriptors/base-input';

export default {
  name: 'rf-textarea',
  extends: BaseInput,
  props: {
    rows: Number,
    noResize: Boolean
  }
};
