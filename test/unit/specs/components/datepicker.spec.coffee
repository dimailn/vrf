import {
  shallowMount
  mount
} from '@vue/test-utils'

import Vrf from '../../../../src'
import Vue from 'vue'

Vue.use(Vrf)

describe 'datepicker', ->
  def('data', ->
    resource:
      finishTill: new Date(2021, 0, 1)
  )
  def('template', ->
    '''
      <rf-form :resource="resource">
        <rf-datepicker name="finishTill" />
      </rf-form>
    '''
  )
  def('wrapper', ->
    mount(
      template: $template
      data: -> $data
    )
  )
  def('input', -> $wrapper.find('input'))


  it "shows date", ->
    expect($input.vm.$el.value).toBe "2021-01-01T00:00"

  it "setups date", ->
    $input.setValue("2021-01-02T00:00")

    expect($wrapper.vm.resource.finishTill).toEqual new Date(2021, 0, 2)