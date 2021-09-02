import Base from '@/components/descriptors/base';

export default {
  name: 'rf-partial',
  extends: Base,
  props: {
    name: String,
    callback: Function
  },
  computed: {
    component: function() {
      var vue;
      vue = Object.getPrototypeOf(this.$root).constructor;
      return vue.prototype.VueResourceForm.partials[this.name];
    }
  }
};
