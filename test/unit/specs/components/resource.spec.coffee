import './setup'

import {
  shallowMount
  mount
} from '@vue/test-utils'

import capitalize from '../../../../src/utils/capitalize'

describe 'resource', ->
  it 'simple input', ->
    wrapper =  mount(
      template: '''
        <rf-form :resource="resource">
          <rf-resource v-slot="props">
            <div class="test">
              {{props.resource.title}}
            </div>
          </rf-resource>
        </rf-form>
      '''
      data: ->
        resource:
          title: 'text'
    )

    div = wrapper.find('.test')

    expect(div.text()).toBe 'text'