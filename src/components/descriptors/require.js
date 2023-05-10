import Resource from '@/mixins/resource';

export default {
  name: 'rf-require',
  mixins: [
    Resource
  ],
  props: {
    name: {
      type: String,
      required: true
    }
  },
  created() {
    this.$requireSource(this.name);
  },
  watch: {
    name() {
      this.$requireSource(this.name);
    }
  },
  render() {
    return null
  }
}
