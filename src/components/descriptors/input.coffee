import BaseInput from '@/components/descriptors/base-input'

export default {
  vrfParent: 'Base'
  extends: BaseInput
  props: {
    password: Boolean
    transform: [String, Function]
  }

  watch:
    $value: (value, prev) ->
      return unless value?

      return unless @transform

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
