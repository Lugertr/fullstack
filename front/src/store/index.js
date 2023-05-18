import { createStore } from 'vuex'
import axios from 'axios'

export default createStore({
  state: {
    token: null,
  },
  mutations: {
    setToken(state, token) {
      state.token = token
    },
  },
  actions: {
    async authenticate({commit}, {username, password}) {

        const response = await axios.post('http://localhost:8000/auth/sign-in', {username, password})
        const token = response.data.token

        localStorage.setItem('token', token)
        commit('setToken', token)
    },
  },
  getters: {
    token: state => state.token,
  },
})