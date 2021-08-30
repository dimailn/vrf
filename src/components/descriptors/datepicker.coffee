import BaseInput from '@/components/descriptors/base-input'

export default {
  extends: BaseInput

  computed:
    date: ->
      @VueResourceForm.dateInterceptor.out(@$value)

  methods:
    onInput: (e) ->
      @$value = @VueResourceForm.dateInterceptor.in(e.target.value)
}