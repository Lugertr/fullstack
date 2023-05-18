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
                    <v-text-field v-model="form.client_name" label="Client Name" :rules="rules" dense outlined
                        hide-details="auto" class="input-area input pa10"></v-text-field>
                    <v-text-field v-model="form.family_name" label="Family Name" :rules="rules" dense outlined
                        hide-details="auto" class="input-area input pa10"></v-text-field>
                    <v-text-field v-model="form.surname" label="Surname" :rules="rules" dense outlined hide-details="auto"
                        class="input-area input pa10"></v-text-field>
                    <v-text-field v-model="form.passport" label="Passport" :rules="rules" dense outlined hide-details="auto"
                        class="input-area input pa10"></v-text-field>
                    <v-select v-model="form.gender" :items="genderOptions" label="Gender"
                        class="input-area input pa10"></v-select>
                        <v-select class="input-area input pa10" :items="apps" :item-title="getAppsTitle" 
                        item-value="app_id" label="Аппартаменты" name="app_id" v-model="form.app_id" outlined></v-select>
                    <v-text-field type="date" v-model="form.date_in" label="Date In" :rules="rules" dense outlined
                        hide-details="auto" class="input-area input pa10"></v-text-field>
                    <v-text-field type="date" v-model="form.date_out" label="Date Out" :rules="rules" dense outlined
                        hide-details="auto" class="input-area input pa10"></v-text-field>
                </v-container>
                <v-card-actions class=" d-flex align-center justify-space-between  pa-md-4">
                    <v-btn :disabled="!isFree" color="primary" type="submit">Save</v-btn>
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
            isFree: true,
            apps: [],
            genderOptions: ['Male', 'Famale'],
            form: {
                client_name: '',
                family_name: '',
                surname: '',
                passport: '',
                gender: '',
                app_id: null,
                date_in: null,
                date_out: null,
            },
            rules: [
                value => !!value || 'Required.',
                value => (value && value.length >= 3) || 'Min 3 characters',
            ],
        }
    },
    async created() {
        await this.getApps();
        if (this.selectedItem) {
            this.isNew = false;
            const selectedItem = {...this.selectedItem};
            this.form.client_id = selectedItem?.client_id;
            this.form.client_name = selectedItem?.client_name || '';
            this.form.family_name = selectedItem?.family_name || '';
            this.form.surname = selectedItem?.surname || '';
            this.form.passport = selectedItem?.passport || '';
            this.form.gender = selectedItem?.gender || '';
            this.form.app_id = this.apps.find(el=>el.app_id == selectedItem?.app_id).app_id || null;
            this.form.date_in = selectedItem?.date_in || null;
            this.form.date_out = selectedItem?.date_out || null;
        } else {
            this.form.client_id = this.length;
        }
    },
    methods: {
        getAppsTitle(app) {
            if (typeof(app)==='number') {
                const gettedApp = this.apps.find(el=>el.app_id == app);
                return `количество комнат: ${gettedApp.rooms} цена: ${gettedApp.app_price} Р. ${gettedApp.app_status? 'Комната занята!!!':""}` 
            }
            return `количество комнат: ${app.rooms} цена: ${app.app_price} Р. ${app.app_status? 'Комната занята!!!':""}` 
        },
        async getApps() {
            await this.httpGet(path.app).then(
                (apps) => {
                    this.apps = Array.isArray(apps) ? apps : [];
                }
            ).catch(error => {
                const err = error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });
        },
        async save() {
            try {
                const body = { ...this.form}
                if (!this.isNew) {
                    const id = body.client_id;
                    delete body["client_id"];
                    await this.httpPut(path.client,id, body).then(() => this.$emit('close-modal'))
                } else  {
                    await this.httpPost(path.client, body).then(() => this.$emit('close-modal'))
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
    },
    watch: {
                form: {
                    handler(val){
                        const app = this.apps.find(el=>el.app_id == val.app_id);
                        if (app?.app_status) {
                            this.isFree = false;
                        } else {
                            this.isFree = true;
                        }
                },
                    deep: true
                }
            },
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