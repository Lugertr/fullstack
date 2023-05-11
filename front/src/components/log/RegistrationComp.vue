<template>
<v-container fluid>
    <v-card max-width="800" class="mx-auto">
      <v-card-title>
        Register
      </v-card-title>
      <v-card-text>
        <v-form @submit.prevent="register">
          <v-text-field label="Name" v-model="name"></v-text-field>
          <v-text-field label="Email" v-model="email"></v-text-field>
          <v-text-field label="Password" v-model="password" type="password"></v-text-field>
          <v-btn type="submit">Log Up</v-btn>
        </v-form>
      </v-card-text>
    </v-card>
  </v-container>
  </template>
  
  <script>
  export default {
    data () {
      return {
        name: '',
        email: '',
        password: ''
      }
    },
    methods: {
      async register () {
        await this.$store.dispatch('register', {
          name: this.name,
          email: this.email,
          password: this.password
        })
  
        if (this.$store.state.token) {
          this.$router.push('/dashboard')
        }
      }
    }
  }
  </script>