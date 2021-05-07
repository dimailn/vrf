import Base from '@/components/descriptors/base'

import props from '@/components/prop_types/select'
import baseProps from '@/components/prop_types/base'

export default {
  extends: Base
  props: {
    ...baseProps
    ...props
  }
  
  mounted: ->
    @$requireSource(@options) if @sourceMustBeRequired

  watch:
    options: ->
      @$requireSource(@options) if @sourceMustBeRequired

  computed:
    $disabled: ->
      return true if @$readonly

      @$originalDisabled

    $_options: ->
      if typeof @options is 'string'
        @$sources[@options] || @$resource?[@options] || @VueResourceForm.sources?[@options]
      else
        @options

    _listeners: ->
      change: @onChange

    listeners: ->
      input: @onChange
            
    sourceMustBeRequired: ->
      typeof @options is 'string' && !@VueResourceForm.sources?[@options]

  methods:
    onChange: ->
      @$emit 'input', @$value
}