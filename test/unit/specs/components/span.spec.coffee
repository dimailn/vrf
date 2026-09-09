import './setup'

import {
  mount
} from '@vue/test-utils'

import { config } from '@vue/test-utils'

describe 'span', ->
  def('resource', -> title: 'Hello world')
  def('wrapper', ->
    mount(
      template: $template
      data: ->
        resource: $resource
    )
  )
  def('template', ->
    '''
      <rf-form :resource="resource">
        <rf-span name="title" />
      </rf-form>
    '''
  )

  it 'renders the value from resource', ->
    span = $wrapper.findComponent({ name: 'rf-span' })

    expect(span.vm.$value).toBe 'Hello world'
    expect($wrapper.find('span').text()).toBe 'Hello world'

  describe 'when value changes in resource', ->
    beforeEach ->
      $wrapper.vm.resource.title = 'Updated'
      await $wrapper.vm.$nextTick()

    it 'reflects the new value', ->
      expect($wrapper.find('span').text()).toBe 'Updated'

  describe 'with translate function affecting $label', ->
    def('translate', -> jest.fn (property, modelName) -> "translated:#{property}")

    beforeEach ->
      config.global.config ||= {}
      config.global.config.globalProperties ||= {}
      config.global.config.globalProperties.VueResourceForm ||= {}

      span = $wrapper.findComponent({ name: 'rf-span' })
      span.vm.$root.$.appContext.config.globalProperties.VueResourceForm.translate = $translate

    afterEach ->
      config.global.config.globalProperties.VueResourceForm.translate = null

    it 'computes label through translate', ->
      span = $wrapper.findComponent({ name: 'rf-span' })

      expect(span.vm.$label).toBe 'translated:title'
      expect($translate).toHaveBeenCalledWith('title', undefined)
