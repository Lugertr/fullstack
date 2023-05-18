<template>
  <v-container class="d-flex justify-center align-center h-100">
    <v-card :width="'500px'">
      <v-card-title class="headline">Login</v-card-title>
      <v-card-text>
        <v-form v-on:submit.prevent="submitForm">
          <v-text-field v-model="username" :rules="[v => !!v || 'Username is required']" label="Username"
            required></v-text-field>
          <v-text-field v-model="password" :rules="[v => !!v || 'Password is required']" label="Password" type="password"
            required></v-text-field>
          <v-btn type="submit" color="primary">Login</v-btn>
        </v-form>
      </v-card-text>
    </v-card>
  </v-container>
  <error-modal v-if="showError" :errMes="errMes" @close-error-modal="closeErrorModal"></error-modal>
</template>

<script>
import { mapActions } from 'vuex'
import ErrorModal from '@/components/ErrModal.vue';

export default {
  components: { ErrorModal },
  data() {
    return {
      username: '',
      password: '',
      showError: false,
      errMes: null,
    }
  },
  methods: {
    ...mapActions(['authenticate']),
    async submitForm() {
      this.authenticate({
        username: this.username,
        password: this.password,
      }).then(() => {
        this.$router.push('/')
      }).catch(error => {
        const err =  error?.response?.status + error?.response?.data.message;
        console.log(err)
        this.errMes = err;
        this.showError = true;
      })

    },
    closeErrorModal() {
      this.showError = false;
    }
  },
}
</script>
