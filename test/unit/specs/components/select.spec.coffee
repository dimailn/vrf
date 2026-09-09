import './setup'

import {
  mount
} from '@vue/test-utils'

import { config } from '@vue/test-utils'

describe 'select', ->
  def('resource', -> roleId: null)
  def('options', ->
    [
      { id: 'admin', title: 'Admin' }
      { id: 'manager', title: 'Manager' }
    ]
  )

  describe 'with array options', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-select name="roleId" :options="options" />
          </rf-form>
        '''
        data: ->
          resource: $resource
          options: $options
      )
    )

    it 'renders an option per item', ->
      options = $wrapper.findAll('option')

      expect(options.length).toBe 2
      expect(options[0].text().trim()).toBe 'Admin'
      expect(options[1].text().trim()).toBe 'Manager'

    it 'exposes $_options', ->
      select = $wrapper.findComponent({ name: 'rf-select' })

      expect(select.vm.$_options).toEqual $options

    it 'updates the resource on selection', ->
      $wrapper.find('select').setValue('manager')

      expect($wrapper.vm.resource.roleId).toBe 'manager'

    it 'emits change through _listeners', ->
      select = $wrapper.findComponent({ name: 'rf-select' })

      $wrapper.find('select').trigger('change')

      expect(select.emitted().change).toBeTruthy()

  describe 'with custom id/title keys', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-select name="roleId" :options="options" id-key="value" title-key="name" />
          </rf-form>
        '''
        data: ->
          resource: $resource
          options: [
            { value: 'a', name: 'Alpha' }
            { value: 'b', name: 'Beta' }
          ]
      )
    )

    it 'reads options with custom keys', ->
      options = $wrapper.findAll('option')

      expect(options[0].text().trim()).toBe 'Alpha'
      expect(options[0].attributes('value')).toBe 'a'

  describe 'with string options resolved from global sources', ->
    beforeEach ->
      config.global.config ||= {}
      config.global.config.globalProperties ||= {}
      config.global.config.globalProperties.VueResourceForm ||= {}
      config.global.config.globalProperties.VueResourceForm.sources = { roles: $options }

    afterEach ->
      config.global.config.globalProperties.VueResourceForm.sources = null

    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-select name="roleId" options="roles" />
          </rf-form>
        '''
        data: ->
          resource:
            roleId: null
      )
    )

    it 'resolves options from the global sources', ->
      select = $wrapper.findComponent({ name: 'rf-select' })

      # sourceMustBeRequired is false because the source is present globally
      expect(select.vm.sourceMustBeRequired).toBe false
      expect(select.vm.$_options).toEqual $options
      expect($wrapper.findAll('option').length).toBe 2

  describe 'disabled state', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource" :readonly="readonly">
            <rf-select name="roleId" :options="options" :disabled="disabled" />
          </rf-form>
        '''
        data: ->
          resource: $resource
          options: $options
          disabled: $disabled
          readonly: $readonly
      )
    )
    def('disabled', -> undefined)
    def('readonly', -> undefined)

    describe 'when disabled prop set', ->
      def('disabled', -> true)

      it 'is disabled', ->
        select = $wrapper.findComponent({ name: 'rf-select' })

        expect(select.vm.$disabled).toBe true
        expect($wrapper.find('select').attributes('disabled')).toBe ''

    describe 'when readonly', ->
      def('readonly', -> true)

      it 'is disabled through readonly branch', ->
        select = $wrapper.findComponent({ name: 'rf-select' })

        expect(select.vm.$readonly).toBe true
        expect(select.vm.$disabled).toBe true
