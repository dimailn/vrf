import Vue from 'vue'
import App from './App'
import vrf from '../src/index'
import sources from './sources'
# import vrf from '../dist/static/lib'

Vue.config.productionTip = false
Vue.use(vrf, {sources})

new Vue(
  el: '#app',
  render: (h) -> h(App)
)
