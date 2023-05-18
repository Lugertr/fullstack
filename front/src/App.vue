<template>
  <v-app>
    <v-main>
      <v-navigation-drawer expand-on-hover rail color="amber-lighten-3" v-if="isAuth">
        <v-list>
          <v-list-item v-on:click="leave">
            <template v-slot:prepend>
              <v-avatar>
                <v-icon icon="mdi-backspace-outline"></v-icon>
              </v-avatar>
            </template>
            <v-list-item-title></v-list-item-title>
            <v-list-item-subtitle>ВЫЙТИ</v-list-item-subtitle>
          </v-list-item>
        </v-list>

        <v-divider color="primary"></v-divider>

        <v-list density="compact" nav>
          <v-list-item v-for="(item, index) in items" :key="index" :prepend-icon="item.icon" :title="item.title" :to="item.url"></v-list-item>
          <v-list-item v-if="state" :key="32523523" prepend-icon="mdi-account-circle" title="Пользователи" to="/register"></v-list-item>
        </v-list>
      </v-navigation-drawer>
      <router-view />
    </v-main>
  </v-app>
</template>

<script>
import store from "./store/index.js";
import { mapActions } from 'vuex'

export default {
  name: "App",

  data: () => ({
    isAuth: !!store.state.token,
    drawer: true,
    state: store.state.admin,
    items: [
      { title: 'Клиенты', icon: 'mdi-account-group-outline', url: '/clients' },
      { title: 'Аппартаменты', icon: 'mdi-bed', url: '/apps' },
      { title: 'Типы аппартаментов', icon: 'mdi-file-question', url: '/app-types' },
      { title: 'Услуги', icon: 'mdi-room-service', url: '/services' },
      { title: 'Типы услуг', icon: 'mdi-playlist-check', url: '/service-types' },
    ],
    rail: true,
  }),
  methods: {
    ...mapActions(['clearToken']),
    leave() {
      this.clearToken();
      this.$router.push('/login');
    },
  },
  watch: {
    $route(to) {
      this.isAuth = !(to.path == '/login');
      this.state = store.state.admin;
    },
  }
};
</script>
