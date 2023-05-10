import Base from '@/components/descriptors/base';

export default {
  name: 'rf-span',
  extends: Base,
  props: {
    name: {
      type: String,
      required: true
    }
  }
}
