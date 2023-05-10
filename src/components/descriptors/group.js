import Select from '@/components/descriptors/select';
import bitwise from './bitwise';

export default {
  name: 'rf-group',
  extends: Select,
  props: {
    options: {
      type: [String, Array],
      required: false
    },
    bitwise: Boolean,
    multiple: Boolean,
    inverted: Boolean,
    itemComponent: {
      type: [String, Object],
      default: 'rf-radio'
    }
  },
  data() {
    return {
      wrapper: {
        groupValue: null,
        bitwise: false,
        multiple: false,
        inverted: false,
        groupName: '',
        __vrfGroup__: true
      }
    };
  },
  created() {
    this.wrapper.bitwise = this.bitwise
    this.wrapper.multiple = this.multiple
    this.wrapper.inverted = this.inverted

    this.wrapper.groupName = this.name

    if (this.$originalValue == null) {
      return
    }
    this.wrapper.groupValue = this.$originalValue
  },
  watch: {
    bitwise(value) {
      this.wrapper.bitwise = value
    },
    multiple(value) {
      this.wrapper.multiple = value
    },
    inverted(value) {
      this.wrapper.inverted = value
    },
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
      this.wrapper.groupValue = this.$bitwise ? parseInt(value) || 0 : value
    }
  }
}
