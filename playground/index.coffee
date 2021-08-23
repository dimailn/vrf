import Vue from 'vue'
import App from './App'
import vrf from '../src/index'
import sources from './sources'


Vue.config.productionTip = false
translate = (propertyName) -> propertyName
Vue.use(vrf, {sources, translate})

new Vue(
  el: '#app',
  render: (h) -> h(App)
)
