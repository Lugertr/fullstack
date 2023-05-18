<template>
    <v-container>
        <v-container>
            <h1 style="text-align: center">Типы аппартаментов</h1>
            <v-row justify="end" class="pa-ma-5">
                <v-btn variant="tonal" class="ma-2" color="teal" @click="openModal(null)"> add </v-btn>
            </v-row>
        </v-container>
        <v-table class="table">
            <thead class="bg-amber-lighten-3">
                <tr>
                    <th class="text-left">id</th>
                    <th class="text-left">Название</th>
                    <th width="10%"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="app_type in app_types || []" :key="app_type?.app_types_id" class="pa-5">
                    <td>{{ app_type.app_type_id }}</td>
                    <td>{{ app_type.app_type_name }}</td>
                    <td class="text-right">
                        <v-btn @click="openModal(app_type)">Изменить</v-btn>
                        <v-btn @click="deleteItem(app_type.app_type_id)" variant="tonal" class="ms-5" color="error"> delete </v-btn>
                    </td>
                </tr>
            </tbody>
        </v-table>
    </v-container>
    <div>
        <AppTypeModal v-if="modalOpen" ref="app_typeModal" :selectedItem="selectedItem" :length="length" @show-error-modal="showErrorModal"
            @close-modal="closeModal"></AppTypeModal>
        <error-modal v-if="showError" :errMes="errMes" @close-error-modal="closeErrorModal"></error-modal>
    </div>
</template>

<script>
import AppTypeModal from '@/components/appType/AppTypeModal.vue';
import ErrorModal from '@/components/ErrModal.vue';
import { httpMixin, path } from '@/logic/http';
import { nextTick } from 'vue'


export default {
    name: "app_typeTable",
    mixins: [httpMixin],
    components: { AppTypeModal, ErrorModal },
    data() {
        return {
            modalOpen: false,
            showError: false,
            errMes: "",
            selectedItem: null,
            app_types: [],
            length: null,
        };
    },
    mounted() {
        this.getItemsFromBackend();
    },
    methods: {
        async getItemsFromBackend() {
            await this.httpGet(path.appType).then(
                (app_types) => {
                    this.app_types = Array.isArray(app_types)? app_types : [];
                }
            ).catch(error => {
                const err =  error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });

        },
        async deleteItem(id) {
            await this.httpDelete(path.appType,id).then(
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
                this.length = this.app_types.length+1;
                this.selectedItem = null;
            }
            nextTick(() => {
                this.$refs.app_typeModal.dialog = true;
            })
        },
        showErrorModal(err) {
            this.errMes = err;
            this.showError = true;
        },
        closeModal() {
            this.$refs.app_typeModal.dialog = false;
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
  