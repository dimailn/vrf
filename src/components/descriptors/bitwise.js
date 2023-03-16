import Group from '@/components/descriptors/group'

export default {
  name: 'rf-bitwise',
  extends: Group,
  props: {
    options: [Array, String],
    inverted: Boolean
  },
  methods: {
    setValueOnGroup(value) {
      this.wrapper.groupValue = parseInt(value) || 0
    }
  }
}

