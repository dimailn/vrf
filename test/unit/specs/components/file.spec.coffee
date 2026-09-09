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
    input = $wrapper.findComponent({ name: 'rf-file' })

    input.vm.onChange(event)


  test 'puts file in the resource', ->
    expect($wrapper.vm.resource.file).toBeDefined()

  test 'file is not reactive in the resource', ->
    expect($wrapper.vm.resource.file.__ob__).not.toBeDefined()

describe 'file multiple', ->
  def(
    'wrapper'
    -> mount(
      template: '''
        <rf-form :resource="resource">
          <rf-file name="files" multiple />
        </rf-form>
      '''

      data: ->
        resource:
          files: null
    )
  )

  def('files', ->
    [
      { name: 'a.png', size: 1, type: 'image/png' }
      { name: 'b.png', size: 2, type: 'image/png' }
    ]
  )

  beforeEach ->
    event = { target: { files: $files } }
    input = $wrapper.findComponent({ name: 'rf-file' })
    input.vm.onChange(event)

  test 'renders input with multiple attribute', ->
    expect($wrapper.find('input').attributes('multiple')).toBeDefined()

  test 'puts all files in the resource', ->
    expect($wrapper.vm.resource.files.length).toBe 2

  test 'emits change event', ->
    input = $wrapper.findComponent({ name: 'rf-file' })
    expect(input.emitted('change')).toBeTruthy()