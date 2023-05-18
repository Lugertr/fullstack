<template>
    <v-container>
        <v-container>
            <h1 style="text-align: center">Аппартаменты</h1>
            <v-row justify="end" class="pa-ma-5">
                <v-btn variant="tonal" class="ma-2" color="teal" @click="openModal(null)"> add </v-btn>
            </v-row>
        </v-container>
        <v-table class="table">
            <thead class="bg-amber-lighten-3">
                <tr>
                    <th class="text-left">id</th>
                    <th class="text-left">Количество комнат</th>
                    <th class="text-left">Тип аппартаментов</th>
                    <th class="text-left">Статус</th>
                    <th class="text-left">Цена</th>
                    <th width="10%"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="app in apps || []" :key="app?.app_id" class="pa-5">
                    <td>{{ app.app_id }}</td>
                    <td>{{ app.rooms }}</td>
                    <td>{{ showType(app.app_type_id) }}</td>
                    <td>{{ app.app_status ? 'занят': 'свободен' }}</td>
                    <td>{{ app.app_price }}</td>
                    <td class="text-right">
                        <v-btn @click="openModal(app)">Изменить</v-btn>
                        <v-btn @click="deleteItem(app.app_id)" variant="tonal" class="ms-5" color="error"> delete </v-btn>
                    </td>
                </tr>
            </tbody>
        </v-table>
    </v-container>
    <div>
        <AppModal v-if="modalOpen" ref="clientModal" :selectedItem="selectedItem" :length="length" @show-error-modal="showErrorModal"
            @close-modal="closeModal"></AppModal>
        <error-modal v-if="showError" :errMes="errMes" @close-error-modal="closeErrorModal"></error-modal>
    </div>
</template>

<script>
import AppModal from '@/components/app/AppModal.vue';
import ErrorModal from '@/components/ErrModal.vue';
import { httpMixin, path } from '@/logic/http';
import { nextTick } from 'vue'
import { toRaw } from 'vue'

export default {
    name: "AppTable",
    mixins: [httpMixin],
    components: { AppModal, ErrorModal },
    data() {
        return {
            modalOpen: false,
            showError: false,
            errMes: "",
            selectedItem: null,
            appTypes: [],
            apps: [],
            length: null,
        };
    },
    async created() {
        await this.getAppTypes();
    },
    mounted() {
        this.getItemsFromBackend();
    },
    methods: {
        showType(id) {
            const appTypesArr = toRaw(this.appTypes);
            return appTypesArr.find(el=>el.app_type_id == id)?.app_type_name || 'Не известно';
        },
        async getAppTypes() {
            await this.httpGet(path.appType).then(
                (appTypes) => {
                    this.appTypes = Array.isArray(appTypes) ? appTypes : [];
                }
            ).catch(error => {
                const err = error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });
        },
        async getItemsFromBackend() {
            await this.httpGet(path.app).then(
                (apps) => {
                    this.apps = Array.isArray(apps)? apps : [];
                }
            ).catch(error => {
                const err =  error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });

        },
        async deleteItem(id) {
            await this.httpDelete(path.app,id).then(
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
            if (item) {
                this.length = null;
                this.selectedItem = item;
            } else {
                this.length = this.apps?.length+1 || 1;
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
  