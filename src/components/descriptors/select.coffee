import Base from '@/components/descriptors/base'

import props from '@/components/prop_types/select'
import baseProps from '@/components/prop_types/base'

export default {
  extends: Base
  props: {
    ...baseProps
    ...props
  }

  computed:
    $disabled: ->
      return true if @$readonly

      @$originalDisabled

    $_options: ->
      if typeof @options is 'string'
        @$sources[@options] || @$resource[@options] || @VueResourceForm.sources?[@options]
      else
        @options

    _listeners: ->
      change: @onChange

    listeners: ->
      input: @onChange

  methods:
    onChange: ->
      @$emit 'input', @$value
}