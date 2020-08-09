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
    $value:
      get: ->
        return !@$originalValue if @inverted
        @$originalValue
      set: (value) ->
        @$originalValue =
          if @inverted
            !value
          else
            value
}
