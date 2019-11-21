import Base from '../base'
import moment from 'moment'
import baseProps from '../../prop_types/base'

export default {
  extends: Base
  props: baseProps

  computed:
    date: ->
      @value?.format('YYYY-MM-DDTHH:mm')

  methods:
    onInput: (e) ->
      @value = moment(e.target.value)
}