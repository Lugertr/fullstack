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
                    <v-text-field type="number" v-model="form.rooms" label="Количество комнат" :rules="rules" dense outlined
                        hide-details="auto" class="input-area input pa10"></v-text-field>
                    <v-select class="input-area input pa10" :items="appTypes" item-title="app_type_name"
                        item-value="app_type_id" label="Тип аппартаментов" name="app_type_name" v-model="form.app_type_id" outlined></v-select>
                    <v-text-field type="number" v-model="form.app_price" label="Цена за одну ночь" :rules="rules" dense
                        outlined hide-details="auto" class="input-area input pa10"></v-text-field>
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
            appTypes: [],
            form: {
                rooms: null,
                app_type_id: null,
                app_status: 0,
                app_price: '',
            },
            rules: [
                value => !!value || 'Required.',
            ],
        }
    },
    async created() {
        await this.getAppTypes();
        if (this.selectedItem) {
            this.isNew = false;
            const selectedItem = { ...this.selectedItem };
            this.form.app_id = selectedItem?.app_id
            this.form.rooms = selectedItem?.rooms || this.form.rooms;
            this.form.app_type_id = selectedItem?.app_type_id;
            this.form.app_status = selectedItem?.app_status || this.form.app_status;
            this.form.app_price = selectedItem?.app_price || this.form.app_price;
        } else {
            this.form.app_id = this.length;
        }
    },
    methods: {
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
        async save() {
            try {
                console.log(this.form)
                const body = { ...this.form, rooms: +this.form.rooms, app_price: +this.form.app_price}
                if (!this.isNew) {
                    const id = body.app_id;
                    delete body["app_id"];
                    await this.httpPut(path.app, id, body).then(() => this.$emit('close-modal'))
                } else {
                    await this.httpPost(path.app, body).then(() => this.$emit('close-modal'))
                }
            } catch (error) {
                this.$emit('show-error-modal', error);
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