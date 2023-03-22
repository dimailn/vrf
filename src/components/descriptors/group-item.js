import BaseInput from '@/components/descriptors/base-input';

export default {
  name: 'rf-group-item',
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
        return true
      }

      return this.$originalDisabled;
    },
    $fieldName: function() {
      if (!this.$insideGroup) {
        return this.name
      }
      return 'groupValue'
    },
    $valuePropSpecified() {
      if(this.$insideGroup) {
        return false
      }

      return this.value !== undefined
    },
    $insideGroup(){
      return this.$resource && this.$resource.__vrfGroup__
    },
    $inverted() {
      if (this.$insideGroup) {
        return this.$resource.inverted || this.inverted
      }

      return this.inverted
    },
    $bitwise() {
      if (this.$insideGroup) {
        return this.$resource.bitwise
      }

      return false
    },
    $multiple() {
      if (this.$insideGroup) {
        return this.$resource.multiple
      }

      return false
    },
    $label() {
      return this.label || this.t(this.$inverted ? `${this.name}__inverted` : this.name);
    },
    $value: {
      get() {
        if(this.$bitwise) {
          return this.getBitwise()
        }

        if (this.$multiple) {
          return this.getMultiple()
        } else {
          return this.getBoolean()
        }
      },
      set(value) {
        if (this.$multiple) {
          if (this.$bitwise) {
            this.setBitwiseMultiple(value)
          } else {
            this.setMultiple(value)
          }
        } else {
          if(this.$bitwise){
            this.setBitwiseSingle(value)
          } else {
            this.setBoolean(value)
          }
        }
      }
    },
    $power() {
      const power = this.value || this.power

      if (typeof power === 'number') {
        return power
      }
      if (typeof power === 'string') {
        const value = parseInt(power)

        if(isNaN(value)){
          console.error(`[vrf] The value ${power} isn't correct power for bitwise group`)
        }

        return value
      }
    },
    $itemValue() {
      if (this.$bitwise) {
        return this.$power
      }

      if(this.value !== undefined) {
        return this.value
      }

      return this.name
    }
  },
  methods: {
    getBoolean() {
      if(this.$insideGroup) {
        if(this.$inverted) {
          return this.$originalValue !== this.$itemValue
        } else {
          return this.$originalValue === this.$itemValue
        }
      }

      if (this.$inverted) {
        return !this.$originalValue;
      }
      return this.$originalValue;
    },
    setBoolean(value) {
      if(this.$inverted) {
        value = !value
      }

      if(this.$insideGroup) {
        this.$originalValue = value ? this.$itemValue : null

        return
      }

      return this.$originalValue = value
    },
    getBitwise() {
      if (typeof this.$originalValue !== 'number') {
        throw "[vrf] You can use power property for checkbox only for bitwise group"
      }
      const value = this.$originalValue & 2 ** this.$power
      if (this.$inverted) {
        return !value
      }
      return !!value
    },
    getMultiple() {
      if(!(this.$originalValue instanceof Array)) {
        console.error(
          `[vrf] Multiple group should use an array as value, but ${typeof this.$originalValue} found for "${this.$resource.groupName}"`
        )
        return false
      }

      const hasItem = this.$originalValue.some(originalValueItem => originalValueItem === this.$itemValue)

      return this.$inverted ? !hasItem : hasItem
    },
    setBitwiseSingle(value) {
      if (this.$inverted) {
        value = !value;
      }
      this.$originalValue = value ? 2 ** this.$power : 0
    },
    setBitwiseMultiple(value) {
      if (this.$inverted) {
        value = !value;
      }
      this.$originalValue = value ? this.$originalValue | 2 ** this.$power : this.$originalValue & ~(2 ** this.$power);
    },
    setMultiple(value) {
      if(this.$inverted) {
        value = !value
      }

      if(value) {
        const containsValue = this.$originalValue.find(originalValueItem => originalValueItem === this.$itemValue)

        if(containsValue) {
          return
        }

        this.$originalValue = this.$originalValue.concat([this.$itemValue])
      } else {
        this.$originalValue = this.$originalValue.filter(originalValueItem => originalValueItem !== this.$itemValue)
      }

    },
    toggle() {
      this.$value = !this.$value
    }
  }
}
