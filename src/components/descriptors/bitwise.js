import Group from '@/components/descriptors/group'

export default {
  name: 'rf-bitwise',
  extends: Group,
  props: {
    options: [Array, String],
    inverted: Boolean,
    bitwise: {
      type: Boolean,
      default: true
    },
    multiple: {
      type: Boolean,
      default: true
    }
  }
}

