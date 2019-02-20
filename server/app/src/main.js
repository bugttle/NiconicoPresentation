import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

// Fortawesome
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
library.add(fas)
Vue.component('font-awesome-icon', FontAwesomeIcon)

// Components
import App from './App.vue'
import User from './components/User.vue'
import Admin from './components/Admin.vue'

Vue.config.productionTip = true

const router = new VueRouter({
    mode: 'history',
    base: '/',
    routes: [
        {path: '/', component: User},
        {path: '/admin', component: Admin}
    ]
})

new Vue({
    router,
    render: h => h(App),
}).$mount('#app')
