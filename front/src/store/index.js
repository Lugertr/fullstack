import { createStore } from 'vuex'
import axios from 'axios'

export default createStore({
  state: {
    token: null,
    admin: false,
  },
  mutations: {
    setToken(state, token) {
      state.token = token
    },
    setAdmin(state, val) {
      state.admin = val;
    }
  },
  actions: {
    async authenticate({commit}, {username, password}) {

        const response = await axios.post('http://localhost:8000/auth/sign-in', {username, password})
        console.log(response.data);
        const token = response.data.token;
        console.log(token);
        if (username == 'admin') {
          commit('setAdmin', true)
        } else {
          commit('setAdmin', false)
        }
        localStorage.setItem('token', token)
        commit('setToken', token)
    },
    clearToken({commit}) {
      localStorage.setItem('token', null)
      commit('setToken', null)
    }
  },
  getters: {
    token: state => state.token,
  },
})