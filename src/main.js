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

// ...
const resetTimer = () => {
    if (localStorage.getItem("access_token")) {
        localStorage.setItem("expiresAt", Date.now() + 30 * 60 * 1000); // 30 sec
    }
};

["click", "mousemove", "keydown", "scroll"].forEach(e =>
    window.addEventListener(e, resetTimer)
);


setInterval(() => {
    const expiresAt = localStorage.getItem("expiresAt");
    const token = localStorage.getItem("access_token");

    if (token && expiresAt && Date.now() > expiresAt) {
        // Show notification
        import('vue-toastification').then(module => {
            const toast = module.useToast();
            toast.error("Session expired due to inactivity. Please login again.");
        });

        // Clear session and redirect after short delay
        setTimeout(() => {
            localStorage.clear();
            window.location.href = "/signin";
        }, 1000); // 1 second delay to allow toast to appear
    }
}, 60000);


const expiresAt = localStorage.getItem("expiresAt");

if (expiresAt && Date.now() > expiresAt)
{
    localStorage.clear();
    window.location.href = "/signin";
}
// ...

const app = createApp(App)
    .use(router)
    .use(Toast, {
        position: POSITION.BOTTOM_RIGHT,
        timeout: 3000,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
      })

app.mount('#app');


const authToken = localStorage.getItem("access_token");

if (authToken)
{
    axios.defaults.headers.common["Authorization"] = `Bearer ${authToken}`;
}

