import './setup'

import {
  mount
} from '@vue/test-utils'

sharedExamplesFor "successful rendering", ->
  test "contains radio options", ->
    expect($wrapper.text()).toContain('Admin')
    expect($wrapper.text()).toContain('Manager')

    expect($wrapper.find('input[value=admin]').element).not.toBeChecked()
    expect($wrapper.find('input[value=manager]').element).not.toBeChecked()


sharedExamplesFor "successful selection", ->
  describe 'clicked radio', ->
    beforeEach ->
      $wrapper.find('input[value=admin]').setChecked(true)

    test 'changes value', ->
      expect($wrapper.vm.resource.typeId).toBe 'admin'

sharedExamplesFor "successful showing changes", ->
  describe "change value in resource", ->
    beforeEach ->
      await $wrapper.vm.$nextTick()

      $resource.typeId = 'admin'

    test 'radio should be checked', ->
      expect($wrapper.find('input[value=admin]').element).toBeChecked()


describe 'radio-group', ->
  def('resource', -> typeId: null)

  describe 'markup mode', ->
    def(
      'wrapper'
      -> mount(
        template: '''
          <rf-form :resource="resource">
            <rf-radio-group name="typeId">
              <rf-radio value="admin" label="Admin" class="admin-radio" />
              <rf-radio value="manager" label="Manager" />
            </rf-radio-group>
          </rf-form>
        '''

        data: ->
          resource: $resource
      )
    )

    itBehavesLike "successful rendering"
    itBehavesLike "successful selection"
    itBehavesLike "successful showing changes"


  describe 'options mode', ->
    def(
      'wrapper'
      -> mount(
        template: '''
          <rf-form :resource="resource">
            <rf-radio-group name="typeId" :options="options" />
          </rf-form>
        '''

        data: ->
          resource: $resource
          options: [
            {
              id: 'admin'
              title: 'Admin'
            }
            {
              id: 'manager'
              title: 'Manager'
            }
          ]
      )
    )

    itBehavesLike "successful rendering"
    itBehavesLike "successful selection"
    itBehavesLike "successful showing changes"

    describe 'with initialized value', ->
      def('resource', -> typeId: 'admin')

      test 'radio should be checked', ->
        expect($wrapper.find('input[value=admin]').element).toBeChecked()










