import Resource from '@/mixins/resource';

import get from 'lodash.get'
import set from '@/utils/set'

import evalBoolProp from '@/utils/eval-bool-prop';

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

        if (this.vuex) {
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
      return evalBoolProp(this.disabled, this);
    },
    $disabled: function() {
      return this.$originalDisabled;
    },
    $originalReadonly: function() {
      if (this.readonly == null) {
        return this.$formReadonly;
      }
      return evalBoolProp(this.readonly, this);
    },
    $readonly: function() {
      return this.$originalReadonly;
    },
    humanName: function() {
      if (this.noLabel) {
        return '';
      } else {
        return this.label || this.t(this.name);
      }
    },
    $firstError: function() {
      return this.$errors[this.name] && this.$errors[this.name][0];
    }
  }
};
