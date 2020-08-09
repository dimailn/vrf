import Base from '@/components/descriptors/base'
import baseProps from '@/components/prop_types/base'

export default {
  extends: Base
  props: baseProps

  computed:
    date: ->
      @VueResourceForm.dateInterceptor.out(@$value)

  methods:
    onInput: (e) ->
      @$value = @VueResourceForm.dateInterceptor.in(e.target.value)
}