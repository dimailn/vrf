import Resource from '@/mixins/resource';

import get from 'lodash.get'
import set from 'lodash.set'

import evalBoolProp from '@/utils/eval-bool-prop';

import Translate from '@/mixins/translate';

export default {
  mixins: [Resource, Translate],
  methods: {
    onInput: function(e) {
      return this.$emit('input', e);
    },
    onBlur: function(e) {
      return this.$emit('blur', e);
    },
    onChange: function(e) {
      return this.$emit('change', e);
    }
  },
  computed: {
    $fieldName: function() {
      return this.name;
    },
    $originalValue: {
      get: function() {
        return get(this.$resource, this.$fieldName);
      },
      set: function(value) {
        var store;
        if (this.vuex) {
          store = this.VueResourceForm.store;
          if (!store) {
            return console.warn("Store for VueResourceForm is not defined");
          }
          return store.commit('vue-resource-form:update', {
            resourceName: this.$rfName,
            name: this.$fieldName,
            value
          });
        } else {
          return set(this.$resource, this.$fieldName, value, this.$set);
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
    value: {
      get: function() {
        console.warn('[vrf] Value computed prop is deprecated, use $value instead');
        return this.$value;
      },
      set: function(value) {
        console.warn('[vrf] Value computed prop is deprecated, use $value instead');
        return this.$value = value;
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
