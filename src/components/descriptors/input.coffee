import Base from '@/components/descriptors/base'
import baseProps from '@/components/prop_types/base'

export default {
  extends: Base
  props: {
    ...baseProps
    transform: [String, Function]
  }
  watch:
    value: (value, prev) ->
      return unless value?

      @applyTransform(value, prev) if !prev? || value != prev[0..-2]

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
