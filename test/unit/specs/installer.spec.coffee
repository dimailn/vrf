import Vrf, {RfInput} from '../../../src'
import Vue from 'vue'
import capitalize from '../../../src/utils/capitalize'




describe 'installer', ->
  componentSpy = jest.spyOn(Vue, 'component')
  describe 'with adapter', ->
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
    subject -> Vue.use(Vrf, adapters: [$adapter])

    it 'installs', ->
      $subject
      expect(componentSpy).toHaveBeenCalledWith('RfInput', $RfInput)
      expect($RfInput.computed.$vrfParent()).toBe RfInput
      expect($RfInput.extends.name).toBe 'rf-input'