import Base from '@/components/descriptors/base';

export default {
  name: 'rf-resource',
  extends: Base,
  render() {
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
      disabled: this.$formDisabled,
      t: this.t,
      errors: this.$errors,
      actionResults: this.$actionResults
    }
    return this.$slots.default && this.$slots.default(props)
  }
}
