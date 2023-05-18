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
                    <v-text-field v-model="form.service_type_name" label="Название" :rules="rules" dense outlined
                        hide-details="auto" class="input-area input pa10"></v-text-field>
                    <v-text-field type="number" v-model="form.price" label="Цена" :rules="rules" dense outlined
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
            form: {
                service_type_name: '',
                price: null,
            },
            rules: [
                value => !!value || 'Required.',
            ],
        }
    },
    created() {
        if (this.selectedItem) {
            this.isNew = false;
            const selectedItem = {...this.selectedItem};
            this.form.service_type_id = selectedItem?.service_type_id;
            this.form.service_type_name = selectedItem?.service_type_name || '';
            this.form.price = selectedItem?.price || '';
        } else {
            this.form.service_type_id = this.length || 1;
        }
    },
    methods: {
        async save() {
            try {
                console.log(this.form)
                const body = { ...this.form, price: +this.form.price}
                if (!this.isNew) {
                    const id = body.service_type_id;
                    delete body["service_type_id"];
                    await this.httpPut(path.appServiceType,id, body).then(() => this.$emit('close-modal'))
                } else  {
                    await this.httpPost(path.appServiceType, body).then(() => this.$emit('close-modal'))
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