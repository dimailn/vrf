import BaseInput from '@/components/descriptors/base-input';

export default {
  name: 'rf-datepicker',
  extends: BaseInput,
  computed: {
    date() {
      return this.VueResourceForm.dateInterceptor.out(this.$value);
    }
  },
  methods: {
    onInput(e) {
      this.$value = this.VueResourceForm.dateInterceptor.in(e.target.value)
    }
  }
}
