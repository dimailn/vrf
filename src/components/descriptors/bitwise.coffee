import Select from '@/components/descriptors/select'
import baseProps from '@/components/prop_types/base'

export default {
  vrfParent: 'Base'
  extends: Select
  props: {
    ...baseProps
    options: [Array, String]
    inverted: Boolean
  }

  data: ->
    wrapper:
      bitwiseValue: 0

  created: ->
    return unless @$originalValue?

    @wrapper.bitwiseValue = @$originalValue

  watch:
    'wrapper.bitwiseValue': (value) ->
      @$originalValue = value

    '$originalValue': (value) ->
      return if @wrapper.bitwiseValue == value

      @wrapper.bitwiseValue = parseInt(value) || 0
}

