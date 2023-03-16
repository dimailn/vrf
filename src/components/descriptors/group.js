import Select from '@/components/descriptors/select';

export default {
  name: 'rf-group',
  extends: Select,
  data: function() {
    return {
      wrapper: {
        groupValue: null
      }
    };
  },
  created: function() {
    if (this.$originalValue == null) {
      return;
    }
    return this.wrapper.groupValue = this.$originalValue;
  },
  watch: {
    'wrapper.groupValue': function(value) {
      return this.$originalValue = value;
    },
    '$originalValue': function(value) {
      if (this.wrapper.groupValue === value) {
        return;
      }

      this.setValueOnGroup(value)
    }
  },
  methods: {
    setValueOnGroup(value) {
      this.wrapper.groupValue = value
    }
  }
}
