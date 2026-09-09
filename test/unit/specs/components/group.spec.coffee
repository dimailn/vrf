import './setup'

import {
  mount
} from '@vue/test-utils'

describe 'group', ->
  def('resource', -> typeId: null)
  def('options', -> [
    { id: 'admin', title: 'Admin' }
    { id: 'manager', title: 'Manager' }
  ])

  describe 'options mode', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-group name="typeId" :options="options" />
          </rf-form>
        '''
        data: ->
          resource: $resource
          options: $options
      )
    )

    it 'renders an item per option via the default item component', ->
      expect($wrapper.findAll('input[type=radio]').length).toBe 2
      expect($wrapper.text()).toContain('Admin')
      expect($wrapper.text()).toContain('Manager')

    it 'writes the selected value into the resource', ->
      $wrapper.find('input[value=admin]').setChecked(true)
      await $wrapper.vm.$nextTick()

      expect($wrapper.vm.resource.typeId).toBe 'admin'

    it 'reflects an external resource change back onto the items', ->
      $wrapper.vm.resource.typeId = 'manager'
      await $wrapper.vm.$nextTick()

      expect($wrapper.find('input[value=manager]').element).toBeChecked()

  describe 'with an initial value', ->
    def('resource', -> typeId: 'admin')
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-group name="typeId" :options="options" />
          </rf-form>
        '''
        data: ->
          resource: $resource
          options: $options
      )
    )

    it 'seeds the group value on creation', ->
      group = $wrapper.findComponent({ name: 'rf-group' })

      expect(group.vm.wrapper.groupValue).toBe 'admin'
      expect($wrapper.find('input[value=admin]').element).toBeChecked()

  describe 'markup (slot) mode', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-group name="typeId">
              <rf-radio value="admin" label="Admin" />
              <rf-radio value="manager" label="Manager" />
            </rf-group>
          </rf-form>
        '''
        data: ->
          resource: $resource
      )
    )

    it 'renders the slotted items', ->
      expect($wrapper.findAll('input[type=radio]').length).toBe 2

    it 'writes the selected value into the resource', ->
      $wrapper.find('input[value=admin]').setChecked(true)
      await $wrapper.vm.$nextTick()

      expect($wrapper.vm.resource.typeId).toBe 'admin'

  describe 'reactive bitwise/multiple/inverted props', ->
    # An item-less group keeps the focus on the prop watchers without dragging in
    # child radio/checkbox validation.
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-group
              name="typeId"
              :bitwise="bitwise"
              :multiple="multiple"
              :inverted="inverted"
            >
              <span />
            </rf-group>
          </rf-form>
        '''
        data: ->
          resource: $resource
          bitwise: false
          multiple: false
          inverted: false
      )
    )

    it 'propagates prop changes into the wrapper context', ->
      group = $wrapper.findComponent({ name: 'rf-group' })

      $wrapper.vm.bitwise = true
      $wrapper.vm.multiple = true
      $wrapper.vm.inverted = true
      await $wrapper.vm.$nextTick()

      expect(group.vm.wrapper.bitwise).toBe true
      expect(group.vm.wrapper.multiple).toBe true
      expect(group.vm.wrapper.inverted).toBe true
