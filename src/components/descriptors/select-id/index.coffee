import Base from '../base'

import props from '../../prop_types/select-id'

export default {
  extends: Base
  props,

  computed:
    $_options: ->
      if typeof @options is 'string'
        @resources[@options]
      else
        @options

    _listeners: ->
      change: @onChange

    listeners: ->
      input: @onChange

  methods:
    onChange: ->
      @$emit 'input', @value
}