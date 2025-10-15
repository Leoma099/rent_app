import { createApp } from "vue";
import Vuex from "vuex";
import modules from "./modules";

createApp(Vuex);

export const store = new Vuex.Store({
    modules,
})