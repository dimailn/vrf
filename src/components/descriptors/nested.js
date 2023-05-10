import Resource from '@/mixins/resource';

import base from '@/components/descriptors/base';
import pluralize from 'pluralize'

import capitalizeFirst from '@/utils/capitalize-first'

export default {
  name: 'rf-nested',
  extends: base,
  inject: ['vueResourceFormPath', 'vueResourceFormPathService'],
  mixins: [Resource],
  props: {
    name: {
      type: String,
      required: true
    },
    translationName: String,
    index: Number,
    filter: Function,
    schema: Array,
    wrapper: {
      type: String,
      default: 'div'
    }
  },
  computed: {
    $translationName(){
      if(this.translationName){
        return this.translationName
      }

      return capitalizeFirst(pluralize.singular(this.name))
    },
    isCollection: function() {
      return this.nestedResource instanceof Array;
    },
    wrappedCollection() {
      return this.nestedResource.map((item, index) => ({index, item}))
    },
    wrappedCollectionFiltered() {
      let wrappedCollectionFiltered =
        this.wrappedCollection
          .filter((wrappedResource) => !wrappedResource.item._destroy)

      if(this.filter) {
        wrappedCollectionFiltered = wrappedCollectionFiltered.filter(({item}) => this.filter(item))
      }

      return wrappedCollectionFiltered
    },
    nestedResource() {
      return this.$resource && this.$resource[this.name];
    },
    parentPath() {
      this.vueResourceFormPathService.add(this.vueResourceFormPath, this.name);
      if (!this.vueResourceFormPath) {
        return [this.name];
      }
      return this.vueResourceFormPath.concat([this.name]);
    },
    pathService() {
      return this.vueResourceFormPathService;
    },
    errorsForNestedResource() {
      const prefix = this.name

      return Object.keys(this.$errors)
        .filter((path) => path.substr(0, prefix.length) === prefix)
        .reduce((ownErrors, path) => {
          ownErrors[path.slice(prefix.length + 1)] = this.$errors[path]
          return ownErrors
        }, {})
    },
    $schema() {
      return this.schema || this.defaultSchema;
    },
    defaultSchema() {
      return [
        (resources) => {
          return resources
        }
      ];
    }
  },
  methods: {
    reloadResource(modifier) {
      return this.$form.reloadResource(modifier);
    },
    reloadSources() {
      return this.$form.reloadSources();
    },
    reloadRootResource(modifier) {
      return this.$form.reloadRootResource(modifier);
    },
    requireSource(name){
      return this.$form.requireSource(name)
    },
    clearErrors() {
      return this.$form.clearErrors();
    },
    errorsFor(index) {
      if (!this.$errors) {
        return
      }

      const prefix = this.name + `[${index}]`

      const errors = Object.keys(this.$errors)
        .filter((path) => path.substr(0, prefix.length) === prefix)
        .reduce((ownErrors, path) => {
          ownErrors[path.slice(prefix.length + 1)] = this.$errors[path]
          return ownErrors
        }, {})

      Object.keys(this.$errors).forEach((path) => {
        const commonPrefix = `${this.name}.`

        if(path.includes(commonPrefix)){
          errors[path.replace(commonPrefix, "")] = this.$errors[path]
        }
      })

      return errors;
    },
    pathFor(index) {
      return this.parentPath.concat([index]);
    }
  }
};
