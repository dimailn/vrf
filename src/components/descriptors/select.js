import BaseInput from '@/components/descriptors/base-input';

export default {
  name: 'rf-select',
  extends: BaseInput,
  props: {
    options: {
      type: [Array, String],
      required: true
    },
    multiple: {
      type: Boolean,
      default: false
    },
    clearable: {
      type: Boolean,
      default: false
    },
    idKey: {
      type: String,
      default: 'id'
    },
    titleKey: {
      type: String,
      default: 'title'
    }
  },
  created() {
    if (this.sourceMustBeRequired) {
      return this.$requireSource(this.options);
    }
  },
  watch: {
    options() {
      if (this.sourceMustBeRequired) {
        return this.$requireSource(this.options);
      }
    }
  },
  computed: {
    $disabled() {
      if (this.$readonly) {
        return true;
      }
      return this.$originalDisabled;
    },
    $_options() {
      if (typeof this.options === 'string') {
        const options = this.$sources[this.options] ||
          this.$resource && this.$resource[this.options] instanceof Array && this.$resource[this.options] ||
          this.VueResourceForm.sources && this.VueResourceForm.sources[this.options]

        if(!options){
          console.error(`[vrf] Can't resolve options "${this.options} for ${this.$form.name || 'Anonymous form'} -> ${this.name}".`)

          return []
        }

        return options

      } else {
        return this.options;
      }
    },
    _listeners() {
      return {
        change: this.onChange
      };
    },
    listeners() {
      return {
        input: this.onChange
      };
    },
    sourceMustBeRequired() {
      return typeof this.options === 'string' && !(this.VueResourceForm.sources || {})[this.options]
    }
  }
};
