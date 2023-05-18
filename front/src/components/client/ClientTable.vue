<template>
    <v-container>
        <v-container>
            <h1 style="text-align: center">Таблица</h1>
            <v-row justify="end" class="pa-ma-5">
                <v-btn variant="tonal" class="ma-2" color="teal" @click="openModal(null)"> add </v-btn>
            </v-row>
        </v-container>
        <v-table class="table">
            <thead class="bg-amber-lighten-3">
                <tr>
                    <th class="text-left">id</th>
                    <th class="text-left">Имя</th>
                    <th class="text-left">Фамилия</th>
                    <th class="text-left">Отечество</th>
                    <th class="text-left">Паспорт</th>
                    <th class="text-left">Пол</th>
                    <th class="text-left">Айди комнаты</th>
                    <th class="text-left">Заезд</th>
                    <th class="text-left">Отъезд</th>
                    <th width="10%"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="client in clients || []" :key="client?.id" class="pa-5">
                    <td>{{ client.client_id }}</td>
                    <td>{{ client.client_name }}</td>
                    <td>{{ client.family_name }}</td>
                    <td>{{ client.surname }}</td>
                    <td>{{ client.passport }}</td>
                    <td>{{ client.gender }}</td>
                    <td>{{ client.app_id }}</td>
                    <td>{{ client.date_in }}</td>
                    <td>{{ client.date_out }}</td>
                    <td class="text-right">
                        <v-btn @click="openModal(client)">Изменить</v-btn>
                        <v-btn @click="deleteItem(client.client_id)" variant="tonal" class="ms-5" color="error"> delete </v-btn>
                        <v-btn variant="tonal" class="ms-5" color="primary"> Чек </v-btn>
                    </td>
                </tr>
            </tbody>
        </v-table>
    </v-container>
    <div>
        <client-modal v-if="modalOpen" ref="clientModal" :selectedItem="selectedItem" :length="length" @show-error-modal="showErrorModal"
            @close-modal="closeModal"></client-modal>
        <error-modal v-if="showError" :errMes="errMes" @close-error-modal="closeErrorModal"></error-modal>
    </div>
</template>

<script>
import ClientModal from '@/components/client/ClientModal.vue';
import ErrorModal from '@/components/ErrModal.vue';
import { httpMixin, path } from '@/logic/http';
import { nextTick } from 'vue'


export default {
    name: "ClientTable",
    mixins: [httpMixin],
    components: { ClientModal, ErrorModal },
    data() {
        return {
            val: {
                client_id: 1,
                client_name: 'test',
                family_name: 'test',
                surname: 'test',
                passport: '1111 123456',
                gender: 'male',
                app_id: 1,
                date_in: '19.11.2022',
                date_out: '20.12.2022',
            },
            modalOpen: false,
            showError: false,
            errMes: "",
            selectedItem: null,
            clients: [],
            length: null,
        };
    },
    mounted() {
        this.getItemsFromBackend();
    },
    methods: {
        async getItemsFromBackend() {
            this.clients.push(this.val);
            await this.httpGet(path.client).then(
                (clients) => {
                    console.log(this.val)
                    this.clients = Array.isArray(clients)? clients : [this.val];
                }
            ).catch(error => {
                const err =  error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });

        },
        async deleteItem(id) {
            await this.httpDelete(path.client,id).then(
                () => {
                    return this.getItemsFromBackend();
                }
            ).catch(error => {
                const err =  error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });
        },
        openModal(item) {
            if (this.modalOpen) {
                return
            }
            this.modalOpen = true;
            console.log(item)
            if (item) {
                this.length = null;
                this.selectedItem = item;
            } else {
                this.length = this.clients.length+1;
                this.selectedItem = null;
            }
            nextTick(() => {
                this.$refs.clientModal.dialog = true;
            })
        },
        showErrorModal(err) {
            this.errMes = err;
            this.showError = true;
        },
        closeModal() {
            this.$refs.clientModal.dialog = false;
            this.modalOpen = false;
            this.getItemsFromBackend();
        },
        closeErrorModal() {
            this.showError = false;
        }
    }
};
</script>
  
<style scoped>
.table {
    border: solid 2px #ffe082;
}
</style>
  