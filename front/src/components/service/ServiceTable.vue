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
                    <th class="text-left">Клиент</th>
                    <th class="text-left">Услуга</th>
                    <th class="text-left">Количество дней</th>
                    <th width="10%"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="service in services || []" :key="service?.service_id" class="pa-5">
                    <td>{{ service.service_id }}</td>
                    <td>{{ showClientData(service.client_id) }}</td>
                    <td>{{ showType(service.service_type_id) }}</td>
                    <td>{{ service.days_count }}</td>
                    <td class="text-right">
                        <v-btn @click="openModal(service)">Изменить</v-btn>
                        <v-btn @click="deleteItem(service.service_id)" variant="tonal" class="ms-5" color="error"> delete </v-btn>
                    </td>
                </tr>
            </tbody>
        </v-table>
    </v-container>
    <div>
        <ServiceModal v-if="modalOpen" ref="serviceModal" :selectedItem="selectedItem" :length="length" @show-error-modal="showErrorModal"
            @close-modal="closeModal"></ServiceModal>
        <error-modal v-if="showError" :errMes="errMes" @close-error-modal="closeErrorModal"></error-modal>
    </div>
</template>

<script>
import ServiceModal from '@/components/service/ServiceModal.vue';
import ErrorModal from '@/components/ErrModal.vue';
import { httpMixin, path } from '@/logic/http';
import { nextTick } from 'vue'
import { toRaw } from 'vue'

export default {
    name: "serviceTable",
    mixins: [httpMixin],
    components: { ServiceModal, ErrorModal },
    data() {
        return {
            modalOpen: false,
            showError: false,
            errMes: "",
            selectedItem: null,
            clients: [],
            serviceTypes: [],
            services: [],
            length: null,
        };
    },
    async created() {
        await this.getServiceTypes();
        await this.getClients();
    },
    mounted() {
        this.getItemsFromBackend();
    },
    methods: {
        showClientData(id) {
            const clientHandler = toRaw(this.clients);
            const client = clientHandler.find(el=>el.client_id == id);
            console.log(clientHandler)
            if (!client) 
                return 'Неизвестный клиент'
            return `${client.client_name} ${client.family_name} Номер №${client.app_id}`
        },
        showType(id) {
            const serviceTypesArr = toRaw(this.serviceTypes);
            return serviceTypesArr.find(el=>el.service_type_id == id)?.service_type_name || 'Не известно';
        },
        async getClients() {
            await this.httpGet(path.client).then(
                (clients) => {
                    this.clients = Array.isArray(clients) ? clients : [];
                }
            ).catch(error => {
                const err = error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });
        },
        async getServiceTypes() {
            await this.httpGet(path.appServiceType).then(
                (serviceTypes) => {
                    this.serviceTypes = Array.isArray(serviceTypes) ? serviceTypes : [];
                }
            ).catch(error => {
                const err = error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });
        },
        async getItemsFromBackend() {
            await this.httpGet(path.appService).then(
                (services) => {
                    this.services = Array.isArray(services)? services : [];
                }
            ).catch(error => {
                const err =  error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });

        },
        async deleteItem(id) {
            await this.httpDelete(path.appService,id).then(
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
                this.length = this.services.length+1;
                this.selectedItem = null;
            }
            nextTick(() => {
                this.$refs.serviceModal.dialog = true;
            })
        },
        showErrorModal(err) {
            this.errMes = err;
            this.showError = true;
        },
        closeModal() {
            this.$refs.serviceModal.dialog = false;
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
  