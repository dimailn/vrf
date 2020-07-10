import Base from '../base'
import baseProps from '../../prop_types/base'

export default {
  extends: Base
  props: {
    ...baseProps
    transform: [String, Function]
  }
  watch:
    value: (value, prev) ->
      @applyTransform(value, prev) if value != prev[0..-2]

  methods:
    applyTransform: (value, prev) ->
      transform =
        if typeof @transform is 'string'
          @VueResourceForm.transforms[@transform]
        else
          @transform

      if transform?
        @$nextTick => @value = transform(value, prev)

}
