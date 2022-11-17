import Select from '@/components/descriptors/select';

export default {
  name: 'rf-radio-group',
  vrfParent: 'Base',
  extends: Select,
  props: {
    options: [String, Array],
    required: false
  },
  data: function() {
    return {
      wrapper: {
        radioGroupValue: null
      }
    };
  },
  created: function() {
    if (this.$originalValue == null) {
      return;
    }
    return this.wrapper.radioGroupValue = this.$originalValue;
  },
  watch: {
    'wrapper.radioGroupValue': function(value) {
      return this.$originalValue = value;
    },
    '$originalValue': function(value) {
      if (this.wrapper.radioGroupValue === value) {
        return;
      }
      return this.wrapper.radioGroupValue = value
    }
  }
};
