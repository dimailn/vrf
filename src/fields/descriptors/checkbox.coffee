# import FieldMixin from '../../mixins/field'
import checkbox from '../../components/descriptors/checkbox'

export default {
  extends: checkbox
  # mixins: [FieldMixin]

  computed:
    humanName: ->
      @label || @t(if @inverted then "#{@name}__inverted" else @name)
}
