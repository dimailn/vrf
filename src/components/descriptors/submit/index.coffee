import Resource from '../../../mixins/resource'
import FieldMixin from '../../../mixins/field'
import Base from '../base'

export default {
  extends: Base
  mixins: [Resource, FieldMixin]
}
