import './setup'

import {
  mount
} from '@vue/test-utils'

import { config } from '@vue/test-utils'

describe 'submit', ->
  def('disabled', -> false)
  def('readonly', -> false)
  def('wrapper', ->
    mount(
      template: '''
        <rf-form :resource="resource" :readonly="readonly">
          <rf-submit class="submit" :disabled="disabled" />
        </rf-form>
      '''
      data: ->
        resource: { title: '' }
        disabled: $disabled
        readonly: $readonly
    )
  )

  it 'renders a button by default', ->
    button = $wrapper.find('.submit')

    expect(button.exists()).toBe true
    expect(button.element.tagName).toBe 'BUTTON'

  it 'submits the form on click', ->
    form = $wrapper.findComponent({ name: 'rf-form' })

    await $wrapper.find('.submit').trigger('click')
    await $wrapper.vm.$nextTick()

    expect(form.emitted().submit).toBeTruthy()

  describe 'with default label', ->
    it 'uses submit translation key', ->
      submit = $wrapper.findComponent({ name: 'rf-submit' })

      # No translate function configured -> falls back to the key itself
      expect(submit.vm.$label).toBe 'submit'
      expect($wrapper.find('.submit').text()).toBe 'submit'

  describe 'with custom slot content', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-submit class="submit">Save it</rf-submit>
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
      )
    )

    it 'renders the slot instead of label', ->
      expect($wrapper.find('.submit').text()).toBe 'Save it'

  describe 'when disabled', ->
    def('disabled', -> true)

    it 'does not render the button', ->
      submit = $wrapper.findComponent({ name: 'rf-submit' })

      expect(submit.vm.$disabled).toBe true
      expect($wrapper.find('.submit').exists()).toBe false

  describe 'when submit is readonly', ->
    def('wrapper', ->
      mount(
        template: '''
          <rf-form :resource="resource">
            <rf-submit class="submit" readonly />
          </rf-form>
        '''
        data: ->
          resource: { title: '' }
      )
    )

    it 'is disabled via the readonly branch', ->
      submit = $wrapper.findComponent({ name: 'rf-submit' })

      expect(submit.vm.$readonly).toBe true
      expect(submit.vm.$disabled).toBe true
      expect($wrapper.find('.submit').exists()).toBe false

  describe 'with translate function', ->
    def('translate', -> jest.fn (property, modelName) -> "T:#{property}")

    beforeEach ->
      config.global.config ||= {}
      config.global.config.globalProperties ||= {}
      config.global.config.globalProperties.VueResourceForm ||= {}

      submit = $wrapper.findComponent({ name: 'rf-submit' })
      submit.vm.$root.$.appContext.config.globalProperties.VueResourceForm.translate = $translate

    afterEach ->
      config.global.config.globalProperties.VueResourceForm.translate = null

    it 'builds the label through the action-scoped translate path', ->
      submit = $wrapper.findComponent({ name: 'rf-submit' })

      # $label calls t('submit', ..., { isAction: true }); the isAction flag
      # prefixes the property with "$" before it reaches translate.
      label = submit.vm.t('submit', submit.vm.$translationName, { isAction: true })

      expect(label).toBe 'T:$submit'
      expect($translate).toHaveBeenCalledWith('$submit', undefined)
