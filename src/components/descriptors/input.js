import BaseInput from '@/components/descriptors/base-input';

export default {
  name: 'rf-input',
  vrfParent: 'Base',
  extends: BaseInput,
  props: {
    /**
      *  Password mode
      */
    password: Boolean,
    /**
      *  Set transform that is applied after changing value. You may use it to implement masks.
      */
    transform: [String, Function],
    /**
     * HTML input type
     */
    type: String
  },
  watch: {
    $value(value, prev) {
      if (value == null) {
        return;
      }
      if (!this.transform) {
        return;
      }
      if ((prev == null) || value !== prev.slice(0, -1)) {
        return this.applyTransform(value, prev);
      }
    }
  },
  methods: {
    applyTransform(value, prev) {
      const transform = typeof this.transform === 'string' ? this.VueResourceForm.transforms[this.transform] : this.transform;
      if (transform != null) {
        return this.$nextTick(() => {
          return this.$value = transform(value, prev)
        });
      }
    }
  },
  computed: {
    $type(){
      if(this.password){
        return 'password'
      }

      return this.type  || 'text'
    }
  }
};
