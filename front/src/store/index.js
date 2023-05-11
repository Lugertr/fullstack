import { createStore } from 'vuex'
import axios from 'axios'

export default createStore({
  state: {
    token: localStorage.getItem('token') || null,
  },
  mutations: {
    setToken(state, token) {
      state.token = token
    },
  },
  actions: {
    async authenticate({commit}, {username, password}) {
      try {
        const response = await axios.post('http://localhost:8080/api/auth', {username, password})
        const token = response.data.token

        localStorage.setItem('token', token)
        commit('setToken', token)
      } catch (error) {
        console.error(error)
      }
    },
  },
  getters: {
    isAuthenticated: state => !!state.token,
  },
})