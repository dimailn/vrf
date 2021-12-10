import Vue from 'vue'
import App from './App'
import Vrf from '../src'
import sources from './sources'

Vue.config.productionTip = false
const translate = (propertyName) => propertyName
Vue.use(Vrf, {sources, translate})

new Vue({
  el: '#app',
  render: (h) => h(App)
})
