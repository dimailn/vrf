import Vue from 'vue'
import App from './App'
import vrf from '../src/index'

Vue.config.productionTip = false
Vue.use(vrf)

new Vue(
  el: '#app',
  components: { App },
  template: '<App/>'
)
