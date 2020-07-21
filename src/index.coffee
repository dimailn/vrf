import RfCheckbox from './components/templates/checkbox'
import RfInput from './components/templates/input'
import RfTextarea from './components/templates/textarea'
import RfSelect from './components/templates/select'
import RfDatepicker from './components/templates/datepicker'
import RfResource from './components/templates/resource'
import RfForm from './components/templates/form'
import RfSubmit from './components/templates/submit'
import RfNested from './components/templates/nested'
import RfPartial from './components/templates/partial'
import RfSpan from './components/templates/span'

import descriptors from './components/descriptors'
import fieldsDescriptors from './fields/descriptors'

import mutations from './vuex/mutations'

import AutocompleteProvider from './abstract/autocomplete-provider'
import Resource from './mixins/resource'

import installer from './installer'

components = {
  RfCheckbox
  RfSwitch: RfCheckbox
  RfInput
  RfTextarea
  RfSelect
  RfDatepicker
  RfResource
  RfForm
  RfSubmit
  RfNested
  RfPartial
  RfSpan
}

export default installer(components)

export {
  RfCheckbox
  RfInput
  RfTextarea
  RfSelect
  RfDatepicker
  RfResource
  RfForm
  RfSubmit
  RfNested
  RfPartial
  RfSpan

  descriptors
  fieldsDescriptors
  mutations

  AutocompleteProvider
  Resource
  installer
}


