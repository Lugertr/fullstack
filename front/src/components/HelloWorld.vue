<template>
  <v-container>
    <v-container>
      <h1 style="text-align: center">Таблица</h1>
      <v-row justify="end" class="pa-ma-5">
        <v-btn variant="tonal" class="ma-2" color="teal"> add </v-btn>
      </v-row>
    </v-container>
    <v-table class="table">
      <thead class="bg-amber-lighten-3">
        <tr>
          <th class="text-left">Name</th>
          <th class="text-left">Calories</th>
          <th width="5%"></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in desserts" :key="item.name">
          <td>{{ item.name }}</td>
          <td>{{ item.calories }}</td>
          <td class="text-right">
            <v-btn variant="tonal" class="ms-5" color="error"> delete </v-btn>
          </td>
        </tr>
      </tbody>
    </v-table>
  </v-container>
</template>

<script>
export default {
  name: "HelloWorld",

  data() {
    return {
      desserts: [
        {
          name: "Frozen Yogurt",
          calories: 159,
        },
        {
          name: "Ice cream sandwich",
          calories: 237,
        },
        {
          name: "Eclair",
          calories: 262,
        },
        {
          name: "Cupcake",
          calories: 305,
        },
        {
          name: "Gingerbread",
          calories: 356,
        },
        {
          name: "Jelly bean",
          calories: 375,
        },
        {
          name: "Lollipop",
          calories: 392,
        },
        {
          name: "Honeycomb",
          calories: 408,
        },
        {
          name: "Donut",
          calories: 452,
        },
        {
          name: "KitKat",
          calories: 518,
        },
      ],
    };
  },
};
</script>

<style scoped>
.table {
  border: solid 2px #ffe082;
}
</style>
