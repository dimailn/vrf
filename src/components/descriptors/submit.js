import Base from '@/components/descriptors/base';

export default {
  name: 'rf-submit',
  extends: Base,
  props: {
    disabled: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    $disabled() {
      if (this.$readonly) {
        return true;
      }
      return this.$originalDisabled;
    },
    $label() {
      return this.t('submit', this.$translationName, { isAction: true })
    }
  }
};
