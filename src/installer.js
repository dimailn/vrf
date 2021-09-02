import dateInterceptor from './utils/date-interceptor';

import descriptors from './components/descriptors';

import indexBy from './utils/index-by';

import {
  installer
} from 'vue-provide-observable';

export default function(components) {
  return {
    install: function(Vue, options) {
      var base, component, installedComponentNames, name;
      if (process.env.NODE_ENV === 'development') {
        console.log(`[vrf] v.${__VERSION__}`);
      }
      Vue.use(installer);
      installedComponentNames = [];
      if (((options != null ? options.adapters : void 0) != null) && options.adapters instanceof Array) {
        options.adapters.forEach(function(adapter) {
          var component, descriptor, name, ref, results;
          if (typeof adapter.install === "function") {
            adapter.install(Vue);
          }
          ref = adapter.components;
          results = [];
          for (name in ref) {
            component = ref[name];
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
            component.computed.$vrfParent = function() {
              return components[name];
            };
            Vue.component(name, component);
            results.push(installedComponentNames.push(name));
          }
          return results;
        });
      }
      installedComponentNames = indexBy(installedComponentNames);
      for (name in components) {
        component = components[name];
        if (installedComponentNames[name]) {
          continue;
        }
        Vue.component(name, component);
      }
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
