<template>
  <v-container class="d-flex justify-center align-center h-100">
    <v-card :width="'500px'">
      <v-card-title class="headline">Регистрация</v-card-title>
      <v-card-text>
        <v-form v-on:submit.prevent="submitForm">
          <v-text-field v-model="name" :rules="[v => !!v || 'Name is required']" label="Имя" required></v-text-field>
          <v-text-field v-model="username" :rules="[v => !!v || 'Username is required']" label="Username"
            required></v-text-field>
          <v-text-field v-model="password" :rules="[v => !!v || 'Password is required']" label="Password" type="password"
            required></v-text-field>
          <v-btn type="submit" color="primary">Registration</v-btn>
          <router-link to="/login">
            <span class="purple pa-md-4">Уже есть аккант?</span>
          </router-link>
        </v-form>
      </v-card-text>
    </v-card>
  </v-container>
  <error-modal v-if="showError" :errMes="errMes" @close-error-modal="closeErrorModal"></error-modal>
</template>

<script>
import { mapActions } from 'vuex'
import ErrorModal from '@/components/ErrModal.vue';
import axios from 'axios'
import { httpMixin } from '@/logic/http';

export default {
  components: { ErrorModal },
  mixins: [httpMixin],
  data() {
    return {
      name: '',
      username: '',
      password: '',
      showError: false,
      errMes: null,
    }
  },
  methods: {
    ...mapActions(['authenticate']),
    async submitForm() {
      await axios.post('http://localhost:8000/auth/sign-up', { name: this.name, username: this.username, password: this.password }, this.headers)
        .then(() => {
          return this.$router.push('/login')
        })
        .catch((error) => {
          const err =  error?.response?.status + error?.response?.data.message;
          console.log(err)
          this.errMes = err;
          this.showError = true;
        });

    },
    closeErrorModal() {
      this.showError = false;
    }
  },
}
</script>
