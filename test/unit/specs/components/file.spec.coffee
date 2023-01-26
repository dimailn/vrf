import './setup'

import {
  mount
} from '@vue/test-utils'

describe 'file', ->
  def(
    'wrapper'
    -> mount(
      template: '''
        <rf-form :resource="resource">
          <rf-file name="file" />
        </rf-form>
      '''

      data: ->
        resource:
          file: null
    )
  )

  beforeEach ->
    event = {
      target: {
        files: [
          {
            name: 'image.png',
            size: 50000,
            type: 'image/png'
          }
        ]
      }
    }
    input = $wrapper.find('input[type="file"]')

    input.vm.onChange(event)


  test 'puts file in the resource', ->
    expect($wrapper.vm.resource.file).toBeDefined()

  test 'file is not reactive in the resource', ->
    expect($wrapper.vm.resource.file.__ob__).not.toBeDefined()