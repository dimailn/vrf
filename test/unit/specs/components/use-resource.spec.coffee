import './setup'

import {
  mount
} from '@vue/test-utils'

import { defineComponent } from 'vue'

import { useResource } from '../../../../src'

describe 'useResource', ->
  # A consumer component that pulls the form context via the composable and
  # surfaces a couple of fields into its template.
  def('consumer', ->
    defineComponent(
      name: 'resource-consumer'
      setup: -> useResource()
      template: '''
        <div>
          <span class="title">{{ resource && resource.title }}</span>
          <span class="rfname">{{ rfName }}</span>
        </div>
      '''
    )
  )

  describe 'inside a form', ->
    def('wrapper', ->
      mount(
        components: { ResourceConsumer: $consumer }
        template: '''
          <rf-form name="Todo" :resource="resource">
            <resource-consumer />
          </rf-form>
        '''
        data: ->
          resource: { title: 'Hello' }
      )
    )

    def('consumerVm', -> $wrapper.findComponent({ name: 'resource-consumer' }).vm)

    it 'exposes the reactive resource', ->
      expect($consumerVm.resource).toEqual { title: 'Hello' }
      expect($wrapper.find('.title').text()).toBe 'Hello'

    it 'reacts to resource changes', ->
      $wrapper.vm.resource.title = 'Changed'
      await $wrapper.vm.$nextTick()

      expect($consumerVm.resource.title).toBe 'Changed'
      expect($wrapper.find('.title').text()).toBe 'Changed'

    it 'exposes other context fields from the form', ->
      expect($consumerVm.rfName).toBe 'Todo'
      expect(typeof $consumerVm.submit).toBe 'function'
      expect($consumerVm.form).toBe $wrapper.findComponent({ name: 'rf-form' }).vm

  describe 'without a form', ->
    it 'resolves every field to undefined and does not throw', ->
      wrapper = mount($consumer)
      vm = wrapper.findComponent({ name: 'resource-consumer' }).vm

      expect(vm.resource).toBeUndefined()
      expect(vm.rfName).toBeUndefined()
      expect(wrapper.find('.title').text()).toBe ''
