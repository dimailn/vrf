import BaseInput from '@/components/descriptors/base-input';

export default {
  name: 'rf-checkbox',
  extends: BaseInput,
  props: {
    /**
      *  Inverts value
      */
    inverted: {
      type: Boolean,
      default: false
    },
    label: String,
    indeterminate: Boolean,
    noLabel: Boolean,
    /**
      * Set the power of bitmask, when checkbox is used inside of rf-bitwise
    */
    power: [Number, String]
  },
  computed: {
    $disabled: function() {
      if (this.$readonly) {
        return true;
      }
      return this.$originalDisabled;
    },
    $fieldName: function() {
      if (this.$power == null) {
        return this.name;
      }
      return 'bitwiseValue';
    },
    humanName: function() {
      return this.label || this.t(this.inverted ? `${this.name}__inverted` : this.name);
    },
    $value: {
      get: function() {
        if (this.$power != null) {
          return this.getBitwise();
        } else {
          return this.getBoolean();
        }
      },
      set: function(value) {
        if (this.$power != null) {
          return this.setBitwise(value);
        } else {
          return this.setBoolean(value);
        }
      }
    },
    $power: function() {
      if (typeof this.power === 'number') {
        return this.power;
      }
      if (typeof this.power === 'string') {
        return parseInt(this.power);
      }
    }
  },
  methods: {
    getBoolean: function() {
      if (this.inverted) {
        return !this.$originalValue;
      }
      return this.$originalValue;
    },
    setBoolean: function(value) {
      return this.$originalValue = this.inverted ? !value : value;
    },
    getBitwise: function() {
      var value;
      if (typeof this.$originalValue !== 'number') {
        throw "[vrf] You can use power property for checkbox only for bitwise group";
      }
      value = this.$originalValue & 2 ** this.$power;
      if (this.inverted) {
        return !value;
      }
      return value;
    },
    setBitwise: function(value) {
      if (this.inverted) {
        value = !value;
      }
      return this.$originalValue = value ? this.$originalValue | 2 ** this.$power : this.$originalValue & ~(2 ** this.$power);
    }
  }
};
