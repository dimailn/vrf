import Resource from '@/mixins/resource';

import get from 'lodash.get'
import set from '@/utils/set'

import Translate from '@/mixins/translate';

export default {
  props: {
    modelValue: [Number, String, Object],
    disabled: Boolean,
    readonly: Boolean
  },
  mixins: [Resource, Translate],
  methods: {
    onBlur: function(e) {
      return this.$emit('blur', e);
    },
    onChange: function(e) {
      return this.$emit('change', e);
    }
  },
  computed: {
    $attrsWithDefaults(){
      const defaultAttrs = this.$options.defaultAttrs || {}

      if(!Object.keys(defaultAttrs).length) {
        return this.$attrs
      }

      return {
        ...defaultAttrs,
        ...this.$attrs
      }
    },
    $fieldName() {
      return this.name
    },
    $valuePropSpecified() {
      return this.modelValue !== undefined
    },
    $originalValue: {
      get() {
        if(this.$valuePropSpecified){
          return this.modelValue
        }

        return get(this.$resource, this.$fieldName);
      },
      set(value) {   
        if(this.$valuePropSpecified){
          this.$emit('input', value)

          return
        }

        this.$scope.emit('changed', {
          name: this.name,
          oldValue: this.$value,
          newValue: value
        })


        if (this.$vuex) {
          const store = this.$store || this.config.globalProperties.VueResourceForm.store;
          if (!store) {
            return console.warn("Store for VueResourceForm is not defined");
          }
          return store.commit('vue-resource-form:update', {
            resourceName: this.$rfName,
            name: this.$fieldName,
            value
          });
        } else {
          set(this.$resource, this.$fieldName, value);
        }
      }
    },
    $value: {
      get() {
        return this.$originalValue;
      },
      set(value) {
        return this.$originalValue = value;
      }
    },
    $originalDisabled() {
      if (this.disabled == null) {
        return this.$formDisabled;
      }
      return this.disabled
    },
    $disabled() {
      return this.$originalDisabled;
    },
    $originalReadonly() {
      if (this.readonly == null) {
        return this.$formReadonly;
      }
      return this.readonly
    },
    $readonly() {
      return this.$originalReadonly;
    },
    $label() {
      if (this.noLabel) {
        return ''
      } else {
        return this.label || this.t(this.name)
      }
    },
    $firstError() {
      return this.$errors[this.name] && this.$errors[this.name][0];
    },
    humanName() {
      console.warn('[vrf] Computed property humanName is deprecated, use $label instead')

      return this.$label
    }
  }
}
