import axios from 'axios';

export const path = {
    client: "/client",
    
}

export const httpMixin = {
  data() {
    return {
      apiUrl: 'http://localhost:8000', // адрес сервера
      headers: { // заголовки, которые нужны для запросов на вашем сервере
        'Content-Type': 'application/json'
      }
    }
  },

  methods: {
    async httpGet(url, config = {}) {
      try {
        const response = await axios.get(`${this.apiUrl}/${url}`, {
          ...config,
          headers: this.headers
        });
        return response.data;
      } catch (error) {
        console.error(error);
        throw error;
      }
    },

    async httpPut(url, data = {}, config = {}) {
      try {
        const response = await axios.put(`${this.apiUrl}/${url}`, data, {
          ...config,
          headers: this.headers
        });
        return response.data;
      } catch (error) {
        console.error(error);
        throw error;
      }
    },
  }
}