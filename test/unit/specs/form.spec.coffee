import {
  shallowMount
  mount
} from '@vue/test-utils'

import Vrf from '../../../src'
import {Resource, RfForm} from '../../../src'
import Vue from 'vue'
import capitalize from '../../../src/utils/capitalize'


# Vue.use(Vrf)

describe 'form', ->
  it "reload resource", ->
    firstResponse = {
      title: '1'
      subtasks: [
        {
          title: ''
          description: 'test'
        }
      ]
    }

    secondResponse = {
      title: ''
      subtasks: [
        {
          title: 'Changed'
          description: ''
        }
      ]
    }

    response = firstResponse

    middleware = class Middleware
      @accepts: -> true
      constructor: (@form, @name) ->
      load: ->
        Promise.resolve(response)
      loadSources: -> Promise.resolve()

    middlewares = [middleware]

    Vue.use(Vrf, {middlewares})


    ChildComponent = {
      template: '''
        <div>
          <rf-input name="title" class="subtask-title" />
        </div>
      '''
      mixins: [
        Resource
      ]

      methods:
        invalidate: ->
          @$form.reloadResource(['title'])

    }

    wrapper = mount(
      template: '''
        <rf-form name="Todo" :resource.sync="resource" class="root-form" auto>
          <rf-input name="title" />
          <rf-nested name="subtasks">
            <template slot-scope="props">
              <child-component class="child-component" />
            </template>
          </rf-nested>
        </rf-form>
      '''
      components: {
        ChildComponent
      }
      data: ->
        resource: null
    )


    rootForm = wrapper.find('.root-form')

    await rootForm.vm.$nextTick()
    await rootForm.vm.$nextTick()

    childInstance = wrapper.find('.child-component')

    response = secondResponse

    childInstance.vm.invalidate()

    await rootForm.vm.$nextTick()

    expect(wrapper.vm.resource).toEqual(
      title: '1'
      subtasks: [
        {
          title: 'Changed'
          description: 'test'
        }
      ]
    )






