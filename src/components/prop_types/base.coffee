export default {
  name:
    type: String
  disabled:
    type: [Boolean, String]
    default: undefined
  placeholder:
    type: String
  tabindex:
    type: String
  noLabel: Boolean
  label: String
  required: Boolean
  value:
    type: [
      Number
      String
      Boolean
      Object
      Symbol
    ]
    default: Symbol("NOT_DEFINED")
}
