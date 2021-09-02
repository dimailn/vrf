import Select from '@/components/descriptors/select';

export default {
  name: 'rf-bitwise',
  vrfParent: 'Base',
  extends: Select,
  props: {
    options: [Array, String],
    inverted: Boolean
  },
  data: function() {
    return {
      wrapper: {
        bitwiseValue: 0
      }
    };
  },
  created: function() {
    if (this.$originalValue == null) {
      return;
    }
    return this.wrapper.bitwiseValue = this.$originalValue;
  },
  watch: {
    'wrapper.bitwiseValue': function(value) {
      return this.$originalValue = value;
    },
    '$originalValue': function(value) {
      if (this.wrapper.bitwiseValue === value) {
        return;
      }
      return this.wrapper.bitwiseValue = parseInt(value) || 0;
    }
  }
};
