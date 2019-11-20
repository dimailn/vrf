import Vue from 'vue'
import App from './App'
import vrf from '../src/index'
# import vrf from '../dist/static/lib'

Vue.config.productionTip = false
Vue.use(vrf)

new Vue(
  el: '#app',
  render: (h) -> h(App)
)
