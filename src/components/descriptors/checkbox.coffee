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
    checkboxValue:
      get: ->
        return !@value if @inverted
        @value
      set: (value) ->
        @value =
          if @inverted
            !value
          else
            value
}
