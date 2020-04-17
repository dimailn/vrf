export default {
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