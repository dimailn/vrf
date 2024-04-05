import dateInterceptor from './utils/date-interceptor'

import descriptors from './components/descriptors'

import merge from 'lodash.merge'

import pluralize from 'pluralize'
import {decamelize} from 'humps'

const collectComponentProps = (component) => {
  let props = {}

  if(component.props) {
    props = {
      ...component.props
    }
  }

  let parent = component
  while(parent = parent.extends) {
    props = {
      ...props,
      ...parent.props
    }
  }

  return props
}

export default function(components) {
  return {
    install: function(Vue, options = {}) {
      var base, component, name;

      Vue.config.globalProperties.VueResourceForm || (Vue.config.globalProperties.VueResourceForm = {})
      Vue.config.globalProperties.VueResourceForm.templates ||= {}

      if (process.env.NODE_ENV === 'development') {
        console.log(`[vrf] v.${__VERSION__}`);
      }
      
      const defaultProps = options.defaultProps || {}

      if(defaultProps === null || typeof defaultProps !== 'object') {
        console.error('[vrf] The defaultProps property should be an object')
      }

      const installedComponents = {}
      if (options?.adapters && options.adapters instanceof Array) {
        options.adapters.forEach(function(adapter) {
          var component, descriptor, name, results;
          if (typeof adapter.install === "function") {
            adapter.install(Vue);
          }

          if(adapter.templates) {
            Vue.config.globalProperties.VueResourceForm.templates = merge(
              Vue.config.globalProperties.VueResourceForm.templates,
              adapter.templates
            )
          }

          results = [];
          for (name in adapter.components) {
            component = adapter.components[name];

            if(!component.extends) {
              if (!component.vrfParent) {
                console.warn(`[vrf] Component ${name} from ${adapter.name} has not vrfParent and will not initialized`);
                continue;
              }
              descriptor = descriptors[component.vrfParent];
              if (!descriptor) {
                console.warn(`[vrf] Vrf parent ${component.vrfParent} is not found for component ${name} from ${adapter.name}`);
                continue;
              }
              component.extends = descriptor;
            }

            component.computed || (component.computed = {});

            (function(name, previousComponent){
              const vrfCoreParent = components[name]
              component.computed.$vrfCoreParent = function() {
                return vrfCoreParent
              };

              component.computed.$vrfParent = function(){
                return previousComponent || vrfCoreParent
              }
            })(name, installedComponents[name])

            installedComponents[name] = component
          }
          return results;
        });
      }

      for (name in components) {
        if (!installedComponents[name]) {
          installedComponents[name] = components[name]
        }
      }

      Object.keys(defaultProps).forEach((name) => {
        const component = installedComponents[name]
        if(!component) {
          console.warn(`[vrf] Component with name ${name} is not registered, but defaultProps passed`)
          return
        }
        const componentDefaultProps = defaultProps[name]
        if (componentDefaultProps) {
          component.props ||= {}
          component.defaultAttrs ||= {}
          const componentCollectedProps = collectComponentProps(component)
          const componentProps = component.props

          Object.entries(componentDefaultProps).forEach(([propName, propValue]) => {
            const propDefinition = componentCollectedProps[propName]
            if(propDefinition){
              if(typeof propDefinition === 'function') {
                componentProps[propName] = {
                  type: componentCollectedProps[propName]
                }
              } else {
                componentProps[propName] = {...componentCollectedProps[propName]}
              }
              componentProps[propName].default = propValue
            } else {
              component.defaultAttrs[propName] = propValue
            }
          })
        }
      })

      Object.keys(installedComponents).forEach(name => Vue.component(name, installedComponents[name]))


      Vue.component(name, component)
      Vue.config.globalProperties.VueResourceForm.dateInterceptor = dateInterceptor

      Vue.config.globalProperties.VueResourceForm.idFromRoute = (form) => {
        const matches = location.pathname.match(RegExp((decamelize(pluralize(form.name.split("::")[0]))) + "\\/(\\d+)|(new)"))

        if(!matches) {
          return
        }

        const id = parseInt(matches[1])

        if (isNaN(id)) {
          return null
        }

        return id
      }

      Vue.config.globalProperties.VueResourceForm.translate = function (modelProperty, modelName) {
        if (!this.$t || !this.$te) {
          return null
        }

        const scope = modelName === null ? 'defaults' : `models.${modelName}`

        const path = `vrf.${scope}.${modelProperty}`

        if (!this.$te(path)) {
          return null
        }

        return this.$t(path)
      }

      if (options == null) {
        return;
      }

      ['translate', 'effects', 'store', 'autocompletes', 'sources', 'dateInterceptor', 'transforms', 'locale', 'loader', 'idFromRoute'].forEach((optionName) => {
        if (options[optionName]) {
          Vue.config.globalProperties.VueResourceForm[optionName] = options[optionName]
        }
      })


    }
  }
}
