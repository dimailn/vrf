import Vrf, {RfInput} from '../../../src'
import Vue from 'vue'
import capitalize from '../../../src/utils/capitalize'
import { createLocalVue } from '@vue/test-utils'


describe 'installer', ->
  componentSpy = jest.spyOn(Vue, 'component')
  def('RfInput', ->
    {
      vrfParent: 'input'
      render: (h) ->
        h 'div'
    }
  )
  def('adapter', ->
    {
      name: 'vrf-test-adapter'
      components: {
        RfInput: $RfInput
      }
    }
  )
  describe 'with adapter', ->
    subject -> createLocalVue().use(Vrf, adapters: [$adapter])

    it 'installs', ->
      $subject
      expect(componentSpy).toHaveBeenCalledWith('RfInput', $RfInput)
      expect($RfInput.computed.$vrfParent()).toBe RfInput
      expect($RfInput.extends.name).toBe 'rf-input'

  describe 'with second adapter', ->
    def('RfInput2', ->
      {
        vrfParent: 'input'
        render: (h) ->
          h 'div'
      }
    )

    def('adapter2', ->
      {
        name: 'vrf-test-adapter2'
        components: {
          RfInput: $RfInput2
        }
      }
    )

    subject -> createLocalVue().use(Vrf, adapters: [$adapter, $adapter2])

    it 'can access vrfParent and vrfParentCore', ->
      $subject

      expect(componentSpy).toHaveBeenCalledWith('RfInput', $RfInput2)
      expect($RfInput2.computed.$vrfParent()).toBe $RfInput
      expect($RfInput2.computed.$vrfCoreParent()).toBe RfInput
      expect($RfInput2.extends.name).toBe 'rf-input'

  describe 'without adapter', ->
    subject -> createLocalVue().use(Vrf, adapters: [])

    it 'installs core components', ->
      $subject
      expect(componentSpy).toHaveBeenCalledWith('RfInput', RfInput)

  describe 'with adapter but without overriding', ->
    def('adapter', ->
      {
        name: 'vrf-test-adapter'
        components: {
          RfCustomInput: $RfInput
        }
      }
    )
    subject -> createLocalVue().use(Vrf, adapters: [$adapter])

    it 'installs core components', ->
      $subject
      expect(componentSpy).toHaveBeenCalledWith('RfInput', RfInput)