import Base from '../base'

import props from '../../prop_types/select'
import baseProps from '../../prop_types/base'

export default {
  extends: Base
  props: {
    ...baseProps
    ...props
  }

  mounted: ->
    @requireSource(@options) if @isOptionsString

  watch:
    options: ->
      @requireSource(@options) if @isOptionsString

  computed:
    $_options: ->
      if @isOptionsString
        @resources[@options] || @VueResourceForm.sources?[@options]
      else
        @options

    _listeners: ->
      change: @onChange

    listeners: ->
      input: @onChange

    isOptionsString: ->
      typeof @options is 'string'

  methods:
    onChange: ->
      @$emit 'input', @value
}