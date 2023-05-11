<template>
  <v-app>
    <v-main>
      <v-navigation-drawer expand-on-hover rail color="amber-lighten-3" v-if="isAuth">
        <v-list>
          <v-list-item>
            <template v-slot:prepend>
              <v-avatar>
                <v-icon icon="mdi-account-circle"></v-icon>
              </v-avatar>
            </template>
            <v-list-item-title v-text="appName"></v-list-item-title>
            <v-list-item-subtitle>ADMIN MENU</v-list-item-subtitle>
          </v-list-item>
        </v-list>

        <v-divider color="primary"></v-divider>

        <v-list density="compact" nav>
          <v-list-item
            prepend-icon="mdi-folder"
            title="My Files"
            value="myfiles"
          ></v-list-item>
          <v-list-item
            prepend-icon="mdi-account-multiple"
            title="Shared with me"
            value="shared"
          ></v-list-item>
          <v-list-item
            prepend-icon="mdi-star"
            title="Starred"
            value="starred"
          ></v-list-item>
        </v-list>
      </v-navigation-drawer>
      <router-view />
    </v-main>
  </v-app>
</template>

<script>
import store from "./store/index.js";

export default {
  name: "App",

  data: () => ({
    isAuth: !!store.state.token,
    drawer: true,
    items: [
      { title: "Home", icon: "mdi-home-city" },
      { title: "My Account", icon: "mdi-account" },
      { title: "Users", icon: "mdi-account-group-outline" },
    ],
    rail: true,
  }),
  watch: {
  $route(to) {
    this.isAuth = !(to.path == '/login' || to.path == '/register')
  }
}
};
</script>
