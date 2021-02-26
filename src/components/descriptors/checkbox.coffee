import Base from '@/components/descriptors/base'
import baseProps from '@/components/prop_types/base'
import props from '@/components/prop_types/checkbox'

export default {
  extends: Base

  props: {
    ...baseProps
    ...props
  }

  computed:
    $fieldName: ->
      return @name unless @$power?

      'bitwiseValue'

    humanName: ->
      @label || @t(if @inverted then "#{@name}__inverted" else @name)

    $value:
      get: ->
        if @$power?
          @getBitwise()
        else
          @getBoolean()

      set: (value) ->
        if @$power?
          @setBitwise(value)
        else
          @setBoolean(value)

    $power: ->
      return @power if typeof @power is 'number'

      return parseInt(@power) if typeof  @power is 'string'

  methods:
    getBoolean: ->
      return !@$originalValue if @inverted

      @$originalValue

    setBoolean: (value) ->
      @$originalValue =
        if @inverted
          !value
        else
          value

    getBitwise: ->
      throw "[vrf] You can use power property for checkbox only for bitwise group" unless typeof @$originalValue is 'number'

      value = @$originalValue & 2**@$power

      return !value if @inverted

      value

    setBitwise: (value) ->
      value = !value if @inverted

      @$originalValue =
        if value
          @$originalValue | 2**@$power
        else
          @$originalValue & ~(2**@$power)
}
