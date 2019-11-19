import Base from '../base'
import moment from 'moment'

export default {
  extends: Base
  computed:
    date: ->
      @value?.format('YYYY-MM-DDTHH:mm')

  methods:
    onInput: (e) ->
      @value = moment(e.target.value)
}