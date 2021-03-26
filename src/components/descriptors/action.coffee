import Resource from '@/mixins/resource'
import Translate from '@/mixins/translate'

export default {
  props: {
    name: String
    params: String # Query params
    data: String # Body params
  }
  mixins: [
    Resource
    Translate
  ]
  computed:
    humanName: ->
      @t("$actions.#{@name}")

  methods: {
    onClick: ->
      @$form.executeAction(@name, {params: @params, data: @data})
        .then((result) => console.log(result);@$emit('response', result))

  }
}
