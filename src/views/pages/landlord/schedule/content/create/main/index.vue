<template>
    
    <form action="">

        <div>

            <div class="col-md-6 mx-auto">

                <div class="card card-body card-white shadow-sm rounded-0">

                    <div>
                        <label class="form-label">Select your property:</label>
                        <select
                            class="form-select rounded-0"
                            v-model="form.schedule_property">
                            <option value="" disabled selected>-- select property --</option>
                            <option
                                v-for="property in properties"
                                :key="property"
                                :value="property.title">
                                {{ property.title }}
                            </option>
                        </select>
                    </div>

                    <hr>

                    <div>

                        <!-- MODAL -->
                        <form @submit.prevent="submitSchedule()">
                            <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel">Set your date and time</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="date" v-model="scheduleForm.date">
                                        <input type="time" v-model="scheduleForm.time">
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                        <button type="submit" class="btn btn-primary" data-bs-dismiss="modal">Save changes</button>
                                    </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <!-- MODAL END -->

                        <div>
                            <button
                                type="button"
                                class="btn btn-primary"
                                data-bs-toggle="modal"
                                data-bs-target="#exampleModal">
                                Set date and time
                            </button>
                        </div>

                        <ul
                            v-for="(time, index) in times"
                            :key="index">
                            <li>{{ time.date }} {{ time.time }}</li>
                        </ul>

                    </div>

                </div>

                <div class="text-end mt-3">
                    <button
                        class="btn btn-primary">
                        Submit
                    </button>
                </div>

            </div>

        </div>

    </form>

</template>

<script>
import apiClient from "@/services";
export default
{
    data()
    {
        return{
            form:
            {
                schedule_property: "",
            },
            scheduleForm:
            {
                time: "",
                date: ""
            },
            properties: [],
            times: [],
        }
    },

    created()
    {
        this.onLoad();
        this.onLoadSchedule();
    },

    methods:
    {
        async onLoad() {
            const response = await apiClient.get(`/properties`);
            this.properties = response.data;
        },

        async onLoadSchedule() {
            const response = await apiClient.get(`/schedules`);
            this.times = response.data;
        },

        async submitSchedule() {
            const response = await apiClient.post(`/schedules`, this.scheduleForm);
            this.times.push(response.data);
        }
    }

}
</script>

<style scoped>
.button-color
{
    background-color: #007bff;
    color: #ffffff;
}
.button-color:hover
{
    background-color: #3798ff;
    color: #ffffff;
}
.text-title
{
    color: #007bff;
}
</style>