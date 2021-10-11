import dateInterceptor from './utils/date-interceptor';

import descriptors from './components/descriptors';

import indexBy from './utils/index-by';

import {
  installer
} from 'vue-provide-observable';

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
      if (process.env.NODE_ENV === 'development') {
        console.log(`[vrf] v.${__VERSION__}`);
      }
      Vue.use(installer)

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
          results = [];
          for (name in adapter.components) {
            component = adapter.components[name];
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


      Vue.component(name, component);
      (base = Vue.prototype).VueResourceForm || (base.VueResourceForm = {});
      Vue.prototype.VueResourceForm.dateInterceptor = dateInterceptor;
      if (options == null) {
        return;
      }
      return ['translate', 'middlewares', 'store', 'autocompletes', 'partials', 'sources', 'dateInterceptor', 'transforms', 'locale'].forEach(function(optionName) {
        if (options[optionName] != null) {
          return Vue.prototype.VueResourceForm[optionName] = options[optionName];
        }
      });
    }
  };
};
