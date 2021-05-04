export default {
  methods:
    t: (property, modelName = @$rfName) ->
      vue = Object.getPrototypeOf(@$root).constructor

      translate = vue::VueResourceForm.translate

      return property unless translate
      
      translate(property, modelName)
}