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
    $disabled: function() {
      if (this.$readonly) {
        return true;
      }
      return this.$originalDisabled;
    },
    humanName: function() {
      return this.t('submit', '$vrf');
    }
  }
};
