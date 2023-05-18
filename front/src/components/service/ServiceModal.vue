<template>
    <v-dialog v-model="dialog" width="500px" persistent>
        <v-card>
            <v-card-title>
                <h1 class="headlinefill-height fill-height d-flex align-center justify-center  pa-md-4">{{ isNew ?
                    'Create' : 'Change' }}
                </h1>
            </v-card-title>
            <form @submit.prevent="save">
                <v-container>
                    <v-select class="input-area input pa10" :items="clients" :item-title="showClientData"
                        item-value="client_id" label="Клиент" name="client_id" v-model="form.client_id" outlined></v-select>
                        <v-select class="input-area input pa10" :items="serviceTypes" item-title="service_type_name" 
                        item-value="service_type_id" label="Услуга" name="service_type_name" v-model="form.service_type_id" outlined></v-select>
                    <v-text-field type="number" v-model="form.days_count" label="Количество дней"  dense outlined
                        hide-details="auto" class="input-area input pa10"></v-text-field>
                </v-container>
                <v-card-actions class=" d-flex align-center justify-space-between  pa-md-4">
                    <v-btn color="primary" type="submit">Save</v-btn>
                    <v-btn color="error" @click="close">Close</v-btn>
                </v-card-actions>
            </form>
        </v-card>
    </v-dialog>
</template>
  
<script>
import { httpMixin, path } from '@/logic/http';

export default {
    mixins: [httpMixin],
    props: {
        selectedItem: {
            default: null
        },
        length: {
            default: null
        }
    },
    data() {
        return {
            isNew: true,
            dialog: false,
            clients: [],
            serviceTypes: [],
            form: {
                client_id: null,
                service_type_id: null,
                days_count: null,
            },
            rules: [
                value => !!value || 'Required.',
            ],
        }
    },
    async created() {
        await this.getServiceTypes();
        await this.getClients();
        if (this.selectedItem) {
            this.isNew = false;
            const selectedItem = {...this.selectedItem};
            this.form.service_id = selectedItem?.service_id;
            this.form.client_id = selectedItem?.client_id;
            this.form.service_type_id = selectedItem?.service_type_id;
            this.form.days_count = selectedItem?.days_count;
        } else {
            this.form.service_id = this.length;
        }
    },
    methods: {
        showClientData(client) {
            if (typeof(client)==='number') {
                const gettedClient = this.clients.find(el=>el.client_id == client);
                return `${gettedClient.client_name} ${gettedClient.family_name} номер №${gettedClient.app_id}` 
            }
            return `${client.client_name} ${client.family_name} номер №${client.app_id}`
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
        async save() {
            try {
                const body = { ...this.form, days_count: +this.form.days_count}
                if (!this.isNew) {
                    const id = body.service_id;
                    delete body["service_id"];
                    await this.httpPut(path.appService,id, body).then(() => this.$emit('close-modal'))
                } else  {
                    await this.httpPost(path.appService, body).then(() => this.$emit('close-modal'))
                }
            } catch (error) {
                this.$emit('show-error-modal',error);
            }
        },
        showErrorModal() {
            this.$emit('show-error-modal');
        },
        close() {
            this.$emit('close-modal');
        }
    }
};
</script>

<style scoped>
.input-area {
    display: flex;
    flex-direction: column;
}

.input {
    padding: 10px;
}
</style>