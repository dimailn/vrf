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
    collection: function() {
      var baseCollection;
      baseCollection = this.nestedResource.filter(function(r) {
        return !r._destroy;
      });
      if (this.filter) {
        baseCollection = baseCollection.filter(this.filter);
      }
      return baseCollection;
    },
    wrappedCollection: function() {
      return this.collection.map(function(item, index) {
        return {index, item};
      });
    },
    nestedResource: function() {
      return this.$resource && this.$resource[this.name];
    },
    parentPath: function() {
      this.vueResourceFormPathService.add(this.vueResourceFormPath, this.name);
      if (!this.vueResourceFormPath) {
        return [this.name];
      }
      return this.vueResourceFormPath.concat([this.name]);
    },
    pathService: function() {
      return this.vueResourceFormPathService;
    },
    errorsForNestedResource: function() {
      var prefix;
      prefix = this.name;
      return Object.keys(this.$errors).filter(function(path) {
        return path.substr(0, prefix.length) === prefix;
      }).reduce((ownErrors, path) => {
        ownErrors[path.slice(prefix.length + 1)] = this.$errors[path];
        return ownErrors;
      }, {});
    },
    $schema: function() {
      return this.schema || this.defaultSchema;
    },
    defaultSchema: function() {
      return [
        () => {
          return this.wrappedCollection;
        }
      ];
    }
  },
  methods: {
    reloadResource: function(modifier) {
      return this.$form.reloadResource(modifier);
    },
    reloadSources: function() {
      return this.$form.reloadSources();
    },
    reloadRootResource: function(modifier) {
      return this.$form.reloadRootResource(modifier);
    },
    requireSource(name){
      return this.$form.requireSource(name)
    },
    clearErrors: function () {
      return this.$form.clearErrors();
    },
    errorsFor: function(index) {
      if (!this.$errors) {
        return;
      }
      const prefix = this.name + `[${index}]`;
      const errors = Object.keys(this.$errors).filter(function(path) {
        return path.substr(0, prefix.length) === prefix;
      }).reduce((ownErrors, path) => {
        ownErrors[path.slice(prefix.length + 1)] = this.$errors[path];
        return ownErrors;
      }, {});

      Object.keys(this.$errors).forEach((path) => {
        const commonPrefix = `${this.name}.`

        if(path.includes(commonPrefix)){
          errors[path.replace(commonPrefix, "")] = this.$errors[path]
        }
      })

      return errors;
    },
    pathFor: function(index) {
      return this.parentPath.concat([index]);
    }
  }
};
