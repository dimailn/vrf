export default {
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