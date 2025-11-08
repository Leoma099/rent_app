import { createApp } from 'vue'

import App from './App.vue'

import Toast, { POSITION } from 'vue-toastification'
import 'vue-toastification/dist/index.css'
// import VueGoogleMaps from '@fawmi/vue-google-maps';
import { router } from "./router";
// import store from "./stores";

import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';

import 'boxicons/css/boxicons.min.css';

import '../src/assets/css/layout.css';

import axios from "axios";

const app = createApp(App)
    .use(router)
    .use(Toast, {
        position: POSITION.BOTTOM_RIGHT,
        timeout: 3000,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
      })
    // .use(VueGoogleMaps, {
    //     load: {
    //         key: 'AIzaSyCn9IGzgS41HOIRhMz_-RXlodu0mqsTgyU',
    //     }
    // })

app.mount('#app');


const authToken = localStorage.getItem("authToken");
if (authToken) {
    axios.defaults.headers.common["Authorization"] = `Bearer ${authToken}`;
}
