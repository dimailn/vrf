import GroupItem from '@/components/descriptors/group-item'

export default {
  name: 'rf-radio',
  extends: GroupItem,
  computed: {
    $id() {
      return `rf-radio-${Math.floor(Math.random() * 100000000)}`
    }
  }
}
