import Base from '@/components/descriptors/base';

export default {
  name: 'rf-resource',
  extends: Base,
  render(h) {
    const props = {
      $resource: this.$resource,
      $sources: this.$sources,
      $errors: this.$errors,
      $rootResource: this.$rootResource,
      $disabled: this.$formDisabled,
      $actionResults: this.$actionResults,
      $actionPendings: this.$actionPendings,
      // deprecated section
      resource: this.$resource,
      resources: this.$sources,
      rootResource: this.$rootResource,
      rootResources: this.$rootResources,
      disabled: this.$formDisabled,
      tScope: this.tScope,
      t: this.t,
      errors: this.$errors,
      actionResults: this.$actionResults
    }
    const render = this.$scopedSlots?.default
    const nodes = render && render(props)

    if(!nodes) {
      return
    }

    if(nodes.length > 1) {
      return h('div', null, nodes)
    }

    return nodes[0]
  }
}
