<template>
    <v-dialog v-model="dialog" width="400px" height="300px" persistent>
      <v-card class="fill-height d-flex align-center justify-center  pa-md-4">
        <v-card-title>
          <h1 class="headline">Error</h1>
        </v-card-title>
        <v-card-text>
          <h2 class="text-center">{{ errMes }}</h2>
        </v-card-text>
        <v-card-actions>
          <v-btn color="primary" @click="close">Close</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </template>
  
  <script>
  export default {
    props: {
        errMes: {
            default: ""
        }
    },
    data() {
      return {
        dialog: true
      };
    },
    methods: {
      close() {
        this.$emit('close-error-modal');
      }
    }
  };
  </script>
  