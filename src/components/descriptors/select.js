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
  mounted: function() {
    if (this.sourceMustBeRequired) {
      return this.$requireSource(this.options);
    }
  },
  watch: {
    options: function() {
      if (this.sourceMustBeRequired) {
        return this.$requireSource(this.options);
      }
    }
  },
  computed: {
    $disabled: function() {
      if (this.$readonly) {
        return true;
      }
      return this.$originalDisabled;
    },
    $_options: function() {
      var ref, ref1, ref2;
      if (typeof this.options === 'string') {
        return this.$sources[this.options] || ((ref = this.$resource) != null ? ref[this.options] : void 0) instanceof Array && ((ref1 = this.$resource) != null ? ref1[this.options] : void 0) || ((ref2 = this.VueResourceForm.sources) != null ? ref2[this.options] : void 0);
      } else {
        return this.options;
      }
    },
    _listeners: function() {
      return {
        change: this.onChange
      };
    },
    listeners: function() {
      return {
        input: this.onChange
      };
    },
    sourceMustBeRequired: function() {
      var ref;
      return typeof this.options === 'string' && !((ref = this.VueResourceForm.sources) != null ? ref[this.options] : void 0);
    }
  },
  methods: {
    onChange: function() {
      return this.$emit('input', this.$value);
    }
  }
};
