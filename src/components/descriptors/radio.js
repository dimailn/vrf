import BaseInput from '@/components/descriptors/base-input';

export default {
  name: 'rf-radio-group',
  vrfParent: 'Base',
  extends: BaseInput,
  computed: {
    $fieldName: function() {
      return 'radioGroupValue';
    },
    $valuePropSpecified() {
      return false
    },
    $id() {
      return `rf-radio-${Math.floor(Math.random() * 100000000)}`
    }
  }
}
