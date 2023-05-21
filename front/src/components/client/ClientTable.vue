<template>
    <v-container>
        <v-container>
            <h1 style="text-align: center">Клиенты</h1>
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
                    <th class="text-left">Номер</th>
                    <th class="text-left">Заезд</th>
                    <th class="text-left">Отъезд</th>
                    <th width="10%"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="client in clients || []" :key="client?.client_id" class="pa-5">
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
                        <v-btn @click="chekFunc(client.client_id)" variant="tonal" class="ms-5" color="primary"> Чек </v-btn>
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
import jsPDF from 'jspdf';

export default {
    name: "ClientTable",
    mixins: [httpMixin],
    components: { ClientModal, ErrorModal },
    data() {
        return {
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
        async chekFunc(id) {
            await this.httpGetWithPar(path.client,{},id).then(
                (client) => {
                    console.log(client);
                    if (client) {
                        let x = 0;
                        let y = 20;

                        const canvas = document.createElement('canvas');
                        canvas.width = 400;
                        canvas.height = 800;
                        const ctx = canvas.getContext('2d');

                        ctx.font = 'bold 16px Arial';
                        ctx.fillText("Итоговый чек", x, y);
                        y = y + 20;

                        ctx.font = 'bold 12px Arial';

                        ctx.fillText(`Клиент: ${client.name},`, x, y);
                        y = y + 15;
                        
                        ctx.fillText(`Проживал в номере: ${client.rooms}, количество комнат: ${client.rooms}`, x, y);
                        y = y + 15;

                        ctx.fillText(`Стоимость номера:  ${client.app_price},`, x, y);
                        y = y + 15;

                        ctx.fillText(`Количество прожитых дней: ${client.cl_count_days};`, x, y);
                        y = y + 15;

                        if (client.services) {
                            ctx.fillText(`Пользовался следующими услугами:`, x, y);
                            y = y + 15;
                            console.log(client.services)
                            client.services = client.services.split(',').map(str=>{
                                str = str.split(' ');
                                let newStr = 'услуга: ';
                                while (str.length > 2) {
                                    newStr+=str.shift() + ' ';
                                }
                                newStr+=`, длительность: ${str.shift()}`;
                                newStr+=`, стоимость: ${str.shift()};`;
                                return newStr;
                            })
                            for (let str of client.services) {
                                ctx.fillText(`${str}`, x, y);
                                y = y + 15;
                            }

                            ctx.fillText(`Итоговая стоимость услуг:  ${client.service_total},`, x, y);
                            y = y + 15;
                        } else {
                            ctx.fillText(`Не пользовался услугами,`, x, y);
                            y = y + 15;
                        }

                        if (client.discount) {
                            ctx.fillText(`Скидка постоянному клиенту:  ${+client.discount * 100}%,`, x, y);
                            y = y + 15;
                            ctx.fillText(`Итого:  ${((+client.app_price*+client.cl_count_days) + +client.service_total)* (1 - +client.discount)}`, x, y);
                        } else {
                            ctx.fillText(`Итого:  ${(+client.app_price*+client.cl_count_days) + Number(client.service_total)}`, x, y);
                        }
                        const doc = new jsPDF();
                        const dataURL = canvas.toDataURL('image/png');
                        doc.addImage(dataURL, "PNG", 15, 40, 150, 440);
                        doc.save('data.pdf');
                    }
                }
            ).catch(error => {
                const err =  error?.response?.status + error?.response?.data.message;
                this.errMes = err;
                this.showError = true;
            });
        },
        async getItemsFromBackend() {
            await this.httpGet(path.client).then(
                (clients) => {
                    this.clients = Array.isArray(clients)? clients : [];
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
  