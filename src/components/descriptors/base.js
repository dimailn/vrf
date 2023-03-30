import Resource from '@/mixins/resource';

import get from 'lodash.get'
import set from '@/utils/set'

import Translate from '@/mixins/translate';

export default {
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
    $fieldName: function() {
      return this.name;
    },
    $valuePropSpecified() {
      return this.value !== undefined
    },
    $originalValue: {
      get: function() {
        if(this.$valuePropSpecified){
          return this.value
        }

        return get(this.$resource, this.$fieldName);
      },
      set: function(value) {
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
          const store = this.$store || this.VueResourceForm.store;
          if (!store) {
            return console.warn("Store for VueResourceForm is not defined");
          }
          return store.commit('vue-resource-form:update', {
            resourceName: this.$rfName,
            name: this.$fieldName,
            value
          });
        } else {
          set(this.$resource, this.$fieldName, value, this.$set);
        }
      }
    },
    $value: {
      get: function() {
        return this.$originalValue;
      },
      set: function(value) {
        return this.$originalValue = value;
      }
    },
    $originalDisabled: function() {
      if (this.disabled == null) {
        return this.$formDisabled;
      }
      return this.disabled
    },
    $disabled: function() {
      return this.$originalDisabled;
    },
    $originalReadonly: function() {
      if (this.readonly == null) {
        return this.$formReadonly;
      }
      return this.readonly
    },
    $readonly: function() {
      return this.$originalReadonly;
    },
    $label() {
      if (this.noLabel) {
        return ''
      } else {
        return this.label || this.t(this.name)
      }
    },
    $firstError: function() {
      const errorsForField = this.$errors[this.name]

      if (!errorsForField) {
        return
      }

      if (typeof errorsForField === 'string') {
        return errorsForField
      }

      return errorsForField[0]
    },
    humanName: function() {
      console.warn('[vrf] Computed property humanName is deprecated, use $label instead')

      return this.$label
    }
  }
};
