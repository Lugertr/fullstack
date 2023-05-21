<template>
    <v-container>
        <v-container>
            <h1 style="text-align: center">Таблица</h1>
            <v-row justify="end" class="pa-ma-5">
                <v-btn variant="tonal" class="ma-2" color="teal" @click="notPopularFunc()"> Информация </v-btn>
                <v-btn variant="tonal" class="ma-2" color="teal" @click="openModal(null)"> add </v-btn>
            </v-row>
        </v-container>
        <v-table class="table">
            <thead class="bg-amber-lighten-3">
                <tr>
                    <th class="text-left">id</th>
                    <th class="text-left">Название услуги</th>
                    <th class="text-left">Цена</th>
                    <th width="10%"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="service_type in service_types || []" :key="service_type?.service_type_id" class="pa-5">
                    <td>{{ service_type.service_type_id }}</td>
                    <td>{{ service_type.service_type_name }}</td>
                    <td>{{ service_type.price }}</td>
                    <td class="text-right">
                        <v-btn @click="openModal(service_type)">Изменить</v-btn>
                        <v-btn @click="deleteItem(service_type.service_type_id)" variant="tonal" class="ms-5" color="error">
                            delete </v-btn>
                    </td>
                </tr>
            </tbody>
        </v-table>
    </v-container>
    <div>
        <ServiceTypeModal v-if="modalOpen" ref="service_typeModal" :selectedItem="selectedItem" :length="length"
            @show-error-modal="showErrorModal" @close-modal="closeModal"></ServiceTypeModal>
        <error-modal v-if="showError" :errMes="errMes" @close-error-modal="closeErrorModal"></error-modal>
    </div>
    <div>
        <v-dialog v-model="showDopModal">
            <v-card>
                <v-card-title>Неиспользующиеся спросом сервисы</v-card-title>
                <v-card-text>
                    <v-list>
                        <v-list-item v-for="(item, index) in notPopServiceList" :key="index">
                            <v-list-item-title>{{ item }}</v-list-item-title>
                        </v-list-item>
                    </v-list>
                </v-card-text>
                <v-card-actions>
                    <v-btn color="primary" text @click="showDopModal = false">Close</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script>
import ServiceTypeModal from '@/components/serviceType/ServiceTypeModal.vue';
import ErrorModal from '@/components/ErrModal.vue';
import { httpMixin, path } from '@/logic/http';
import { nextTick } from 'vue'


export default {
    name: "service_typeTable",
    mixins: [httpMixin],
    components: { ServiceTypeModal, ErrorModal },
    data() {
        return {
            modalOpen: false,
            showError: false,
            errMes: "",
            selectedItem: null,
            service_types: [],
            length: null,
            showDopModal: false,
            notPopServiceList: [],
        };
    },
    mounted() {
        this.getItemsFromBackend();
    },
    methods: {
        async notPopularFunc() {
            await this.httpGetWithPar(path.appService).then(
                (services) => {
                    if (services && services?.length)
                    this.notPopServiceList = services.map(service=>service.service_type_name);
                    this.showDopModal = true;
                }
            ).catch(error => {
                const err = error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });
        },
        async getItemsFromBackend() {
            await this.httpGet(path.appServiceType).then(
                (service_types) => {
                    this.service_types = Array.isArray(service_types) ? service_types : [];
                }
            ).catch(error => {
                const err = error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });

        },
        async deleteItem(id) {
            await this.httpDelete(path.appServiceType, id).then(
                () => {
                    return this.getItemsFromBackend();
                }
            ).catch(error => {
                const err = error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });
        },
        openModal(item) {
            if (this.modalOpen) {
                return
            }
            this.modalOpen = true;
            if (item) {
                this.length = null;
                this.selectedItem = item;
            } else {
                this.length = this.service_types?.length + 1;
                this.selectedItem = null;
            }
            nextTick(() => {
                this.$refs.service_typeModal.dialog = true;
            })
        },
        showErrorModal(err) {
            this.errMes = err;
            this.showError = true;
        },
        closeModal() {
            this.$refs.service_typeModal.dialog = false;
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
  