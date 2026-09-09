import './setup'

import {
  mount
} from '@vue/test-utils'

describe 'textarea', ->
  def('disabled', -> undefined)
  def('readonly', -> undefined)
  def('resource', -> description: 'Initial text')
  def('wrapper', ->
    mount(
      template: '''
        <rf-form :resource="resource">
          <rf-textarea name="description" :rows="rows" :disabled="disabled" :readonly="readonly" />
        </rf-form>
      '''
      data: ->
        resource: $resource
        rows: 5
        disabled: $disabled
        readonly: $readonly
    )
  )

  it 'renders a textarea with the current value', ->
    textarea = $wrapper.find('textarea')

    expect(textarea.exists()).toBe true
    expect(textarea.element.value).toBe 'Initial text'

  it 'updates resource on input', ->
    $wrapper.find('textarea').setValue('New text')

    expect($wrapper.vm.resource.description).toBe 'New text'

  it 'exposes value through $value', ->
    textarea = $wrapper.findComponent({ name: 'rf-textarea' })

    expect(textarea.vm.$value).toBe 'Initial text'

  it 'emits change event on change', ->
    textarea = $wrapper.findComponent({ name: 'rf-textarea' })
    handler = jest.fn()
    textarea.vm.$.vnode.props ||= {}

    textarea.vm.onChange('evt')

    expect(textarea.emitted().change).toBeTruthy()
    expect(textarea.emitted().change[0]).toEqual ['evt']

  it 'emits blur event on blur', ->
    textarea = $wrapper.findComponent({ name: 'rf-textarea' })

    textarea.vm.onBlur('blurEvt')

    expect(textarea.emitted().blur).toBeTruthy()
    expect(textarea.emitted().blur[0]).toEqual ['blurEvt']

  it 'triggers change through DOM event', ->
    textarea = $wrapper.findComponent({ name: 'rf-textarea' })

    $wrapper.find('textarea').trigger('change')

    expect(textarea.emitted().change).toBeTruthy()

  describe 'when disabled', ->
    def('disabled', -> true)

    it 'renders textarea as disabled', ->
      textarea = $wrapper.findComponent({ name: 'rf-textarea' })

      expect(textarea.vm.$disabled).toBe true
      expect($wrapper.find('textarea').attributes('disabled')).toBe ''

  describe 'when readonly', ->
    def('readonly', -> true)

    it 'renders textarea as readonly', ->
      textarea = $wrapper.findComponent({ name: 'rf-textarea' })

      expect(textarea.vm.$readonly).toBe true
      expect($wrapper.find('textarea').attributes('readonly')).toBe ''
