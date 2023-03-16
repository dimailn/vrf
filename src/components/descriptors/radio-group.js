import Group from '@/components/descriptors/group'

export default {
  name: 'rf-radio-group',
  extends: Group,
  props: {
    options: [String, Array],
    required: false
  }
}
