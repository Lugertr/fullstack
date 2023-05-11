<template>
  <v-container fluid>
    <v-card max-width="800" class="mx-auto">
      <v-card-title>
        Login
      </v-card-title>
      <v-card-text>
        <v-form @submit.prevent="login">
          <v-text-field label="Email" v-model="email"></v-text-field>
          <v-text-field label="Password" v-model="password" type="password"></v-text-field>
          <v-btn type="submit">Log In</v-btn>
        </v-form>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script>
export default {
  data () {
    return {
      username: '',
      password: ''
    }
  },
  methods: {
    async login () {
      // call Vuex login action to make API request
      await this.$store.dispatch('login', {
        email: this.email,
        password: this.password
      })

      // redirect to dashboard on success
      if (this.$store.state.token) {
        this.$router.push('/dashboard')
      }
    }
  }
}
</script>