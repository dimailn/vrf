import BaseInput from '@/components/descriptors/base-input'
import pick from '@/utils/pick'
import debounce from 'lodash.debounce'

export default {
  extends: BaseInput
  props: {
    type: String
    entity: String
    limit: [Number, String]
    disabled: [Boolean, String]
    text: String
    autofocus: Boolean
    active:
      type: Boolean
      default: true
    stateless: Boolean
    rfParams: Object
  }

  data: ->
    query: ''
    loading: false
    items: []
    menu: false

  watch:
    $value: ->
      @providerInstance.onValueChanged()

  mounted: ->
    @providerInstance.mounted()

  methods:
    reset: ->
      @query = ''
      @$value = null

    onSelect: (item) ->
      @providerInstance.onSelect(item)
      @$emit 'select', item

    onInput: (val) ->
      @$emit 'update:text', val
      @load()
      @providerInstance.onInput()
      @$emit 'input', val

    focus: ->
      @$refs.autocomplete.focus()

    onClick: ->
      @providerInstance.onInputClick()
      @$emit 'click'

    onClear: ->
      @$emit 'clear'

    load: debounce(
      -> @instantLoad() if @query? && @query.length > 0
      400
    )

  asyncMethods:
    instantLoad: ->
      throw "[vrf] Entity for autocomplete #{@name} must be defined" unless @entity

      if @active
        @loading = true
        @providerInstance.load(pick(@, ['query', 'limit', 'entity'])).then((@items) =>
          @loading = false
          @menu = @items.length > 0
        )


  computed:
    providerInstance: ->
      vue = Object.getPrototypeOf(@$root).constructor

      provider = vue::VueResourceForm.autocompletes[@type]

      throw "[vrf] Autocomplete provider for #{@type} not found" unless provider

      new provider(@entity, @$resource, @)

    itemsComponent: ->
      @providerInstance.getItemsComponent()

}
