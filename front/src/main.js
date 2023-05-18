import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import vuetify from "./plugins/vuetify";
import vuex from './store/index.js'
import { loadFonts } from "./plugins/webfontloader";

loadFonts();

createApp(App).use(vuetify).use(router).use(vuex).mount("#app");
