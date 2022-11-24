import {createApp} from 'vue'
import App from './App'
import Vrf from '../src'
import sources from './sources'

// Vue.config.productionTip = false
const translate = (propertyName) => propertyName

createApp(App)
  .use(Vrf, {sources, translate})
  .mount("#app")
