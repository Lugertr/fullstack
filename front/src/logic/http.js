import axios from 'axios';
import { mapGetters } from 'vuex'

export const path = {
    signUp: "/sign-up",
    signIn: "/sign-in",
    client: "/clients/",
    app: "/app",
    appType: "/appType",
    appService: "/appService",
    appServiceType: "/appServiceType",
}

export const httpMixin = {
  data() {
    return {
      apiUrl: '/api', 
      headers: { 
      }
    }
  },
  computed: {
    ...mapGetters(['token', 'token'])
  },
  methods: {
    async httpGet(url, config = {}) {
        const token = this.token; 
        return axios.get(`${this.apiUrl}${url}`, {
          ...config,
          headers: {
            ...this.headers,
            'Authorization': `Bearer ${token}` 
          }
        }).then((responce)=>{
          console.log(responce);
          return responce.data.data
        })
        .catch(error=>{
          console.error(error);
          throw new Error;
        });
    },

    async httpPost(url, data = {}, config = {}) {
        const token = this.token; 
        console.log(data);
        return axios.post(`${this.apiUrl}${url}`,data, {
          ...config,
          headers: {
            ...this.headers,
            'Authorization': `Bearer ${token}` 
          }
        }).then((responce)=>responce.data)
        .catch(error=>{
          console.error(error);
          throw new Error(error);
        });
    },

    async httpPut(url,id, data = {}, config = {}) {
      const token = this.token; 
      console.log(id);
      return axios.put(`${this.apiUrl}${url}/${id}`,data, {
        ...config,
        params: { id: id },
        headers: {
          ...this.headers,
          'Authorization': `Bearer ${token}` 
        }
      }).then((responce)=>responce.data)
      .catch(error=>{
        console.error(error);
        throw new Error;
      });
  },
  
  async httpDelete(url,id, config = {}) {
    const token = this.token; 
    return axios.delete(`${this.apiUrl}${url}/${id}`, {
      ...config,
      params: { id: id },
      headers: {
        ...this.headers,
        'Authorization': `Bearer ${token}` 
      }
    }).then((responce)=>responce.data)
    .catch(error=>{
      console.error(error);
      throw new Error;
    });
  }
  }
}