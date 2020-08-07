import { shallowMount } from '@vue/test-utils'
import RfForm from '../../../src/components/templates/form.vue'
import Vrf from '../../../src'

getMountedComponent = (Component, propsData) ->
  return shallowMount(Component, {
    propsData
  })


describe 'form', ->
  it 'test', ->
    wrapper = getMountedComponent(RfForm, name: 'Todo')

    console.log wrapper.vm.name
