import BaseInput from '@/components/descriptors/base-input'

export default {
  extends: BaseInput
  props: {
    options:
      type: [Array, String]
      required: true
    multiple:
      type: Boolean
      default: false
    clearable:
      type: Boolean
      default: false
    idKey:
      type: String
      default: 'id'
    titleKey:
      type: String
      default: 'title'
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
        @$sources[@options] ||
        @$resource?[@options] instanceof Array && @$resource?[@options] ||
        @VueResourceForm.sources?[@options]
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