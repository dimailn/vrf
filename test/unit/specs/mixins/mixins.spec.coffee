import '../components/setup'

import {
  mount
} from '@vue/test-utils'

import Resource from '../../../../src/mixins/resource'
import Templates from '../../../../src/mixins/templates'
import Translate from '../../../../src/mixins/translate'

describe 'Resource mixin', ->
  def('warn', -> jest.spyOn(console, 'warn').mockImplementation(->))

  def('component', ->
    {
      name: 'test-resource'
      mixins: [Resource]
      template: '<div></div>'
    }
  )

  def('wrapper', ->
    mount(
      {
        template: '''
          <rf-form :resource="resource">
            <test-resource ref="child" />
          </rf-form>
        '''
        components: { 'test-resource': $component }
        data: -> resource: { title: 'text' }
      }
    )
  )

  def('child', -> $wrapper.findComponent({ name: 'test-resource' }).vm)

  beforeEach -> $warn

  it 'exposes $-prefixed fields from context', ->
    expect($child.$resource).toEqual { title: 'text' }

  it 'warns when deprecated vuex field is used', ->
    $child.vuex
    expect($warn).toHaveBeenCalledWith(expect.stringContaining('vuex'))

  it 'warns when deprecated fetching field is used', ->
    $child.fetching
    expect($warn).toHaveBeenCalledWith(expect.stringContaining('fetching'))

  it 'warns when deprecated resource field is used', ->
    result = $child.resource
    expect($warn).toHaveBeenCalledWith(expect.stringContaining('resource'))
    expect(result).toEqual { title: 'text' }

  it 'warns when deprecated formDisabled field is used', ->
    $child.formDisabled
    expect($warn).toHaveBeenCalledWith(expect.stringContaining('formDisabled'))

  it 'warns when deprecated rootResource field is used', ->
    $child.rootResource
    expect($warn).toHaveBeenCalledWith(expect.stringContaining('rootResource'))

  it 'warns when deprecated resources field is used and returns $sources', ->
    result = $child.resources
    expect($warn).toHaveBeenCalledWith(expect.stringContaining('resources'))
    expect(result).toBe $child.$sources


describe 'Templates mixin', ->
  def('error', -> jest.spyOn(console, 'error').mockImplementation(->))

  beforeEach -> $error

  describe 'without a name', ->
    def('component', ->
      {
        mixins: [Templates]
        template: '<div></div>'
      }
    )

    def('wrapper', ->
      mount(
        {
          template: '<no-name ref="child" />'
          components: { 'no-name': $component }
        }
      )
    )

    def('child', -> $wrapper.vm.$refs.child)

    it 'logs error when component has no name', ->
      expect(-> $child.$templates).toThrow()
      expect($error).toHaveBeenCalledWith(expect.stringContaining("doesn't have a name"))

  describe 'with a name', ->
    def('component', ->
      {
        name: 'rf-thing'
        mixins: [Templates]
        template: '<div></div>'
      }
    )

    def('wrapper', ->
      mount(
        {
          template: '<rf-thing ref="child" />'
          components: { 'rf-thing': $component }
        }
      )
    )

    def('child', -> $wrapper.findComponent({ name: 'rf-thing' }).vm)

    it 'returns empty object when no template defined', ->
      expect($child.$templates).toEqual {}


describe 'Translate mixin', ->
  def('translationName', -> null)

  def('component', ->
    {
      name: 'test-translate'
      mixins: [Translate]
      template: '<div></div>'
      computed:
        $translationName: -> $translationName
    }
  )

  def('wrapper', ->
    mount(
      {
        template: '<test-translate ref="child" />'
        components: { 'test-translate': $component }
      }
    )
  )

  def('child', -> $wrapper.findComponent({ name: 'test-translate' }).vm)

  def('globals', -> $wrapper.vm.$root.$.appContext.config.globalProperties)

  describe 'when translate is not defined', ->
    beforeEach ->
      $globals.VueResourceForm.translate = null

    it 'returns the property as is', ->
      expect($child.t('title')).toBe 'title'

  describe 'when translation exists in vrf scope only', ->
    def('translationName', -> 'Todo')

    beforeEach ->
      $globals.VueResourceForm.translate = (property, modelName) ->
        return null if modelName != null
        "translated-#{property}"

    it 'returns the translation from vrf scope', ->
      expect($child.t('title')).toBe 'translated-title'

  describe 'when no translation found in any scope', ->
    beforeEach ->
      $globals.VueResourceForm.translate = -> null

    it 'returns the property', ->
      expect($child.t('title')).toBe 'title'

  describe 'when translation exists in model scope', ->
    beforeEach ->
      $globals.VueResourceForm.translate = (property, modelName) ->
        "model-#{property}"

    it 'returns the model scope translation', ->
      expect($child.t('title')).toBe 'model-title'
