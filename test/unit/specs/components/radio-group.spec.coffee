import './setup'

import {
  mount
} from '@vue/test-utils'

sharedExamplesFor "successful rendering", ->
  it "contains radio options", ->
    expect($wrapper.text()).toContain('Admin')
    expect($wrapper.text()).toContain('Manager')

sharedExamplesFor "successful selection", ->
  describe 'clicked radio', ->
    beforeEach ->
      $wrapper.find('input[value=admin]').setChecked(true)

    it 'changes value', ->
      expect($wrapper.vm.resource.typeId).toBe 'admin'


describe 'radio-group', ->
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
          resource:
            typeId: null
      )
    )

    itBehavesLike "successful rendering"
    itBehavesLike "successful selection"


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
          resource:
            typeId: null
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







