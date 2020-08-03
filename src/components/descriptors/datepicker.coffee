import Base from './base'
import baseProps from '../prop_types/base'

export default {
  extends: Base
  props: baseProps

  computed:
    date: ->
      @VueResourceForm.dateInterceptor.out(@value)

  methods:
    onInput: (e) ->
      @value = @VueResourceForm.dateInterceptor.in(e.target.value)
}