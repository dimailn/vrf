import Base from '../base'

import props from '../../prop_types/select'
import baseProps from '../../prop_types/base'

export default {
  extends: Base
  props: {
    ...baseProps
    ...props
  }

  computed:
    $_options: ->
      if typeof @options is 'string'
        @resources[@options] || @VueResourceForm.sources?[@options]
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