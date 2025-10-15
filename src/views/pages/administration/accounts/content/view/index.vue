<template>

    <h1 class="page-title mb-0">View User Account</h1>
    <router-link :to="'/management/account'">Go back to page</router-link>

    <form @submit.prevent="submit()" class="mt-4">

        <div class="card card-body shadow-sm border-0 rounded-0 col-6 mx-auto">

            <div class="row">

                <div class="col-md-4">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">* ID Number:</label>
                        <input
                            type="text"
                            class="form-control form-control-sm rounded-0"
                            placeholder="ex. 123456789"
                            v-model="form.id_number"
                            disabled>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">* Full Name:</label>
                        <input
                            type="text"
                            class="form-control form-control-sm rounded-0"
                            placeholder="ex. Juan Dela Cruz"
                            v-model="form.full_name"
                            disabled>
                    </div>
                </div>

            </div>

            <div class="row">

                <div class="col-md-7">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">* Department / Office Name:</label>
                        <select
                            class="form-control form-control-sm roundeo-0"
                            v-model="form.office_name"
                            disabled>
                            <option
                                value=""
                                disabled
                                selected>-- Select Department --
                            </option>
                            <option
                                :value="department.office_name"
                                v-for="(department, index) in departments"
                                :key="index">{{ department.office_name }}</option>
                        </select>
                    </div>
                </div>

                <div class="col-md-5">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">* Postion:</label>
                        <input
                            type="text"
                            class="form-control form-control-sm rounded-0"
                            placeholder="ex. HR Manager"
                            v-model="form.position"
                            disabled>
                    </div>
                </div>

            </div>

            <div class="form-group mb-3">
                <label for="" class="form-label">* Office Address:</label>
                <select
                    class="form-control form-control-sm roundeo-0"
                    v-model="form.office_address"
                    disabled>
                    <option
                        value=""
                        disabled
                        selected>-- Select Department --
                    </option>
                    <option 
                        :value="department.office_address"
                        v-for="(department, index) in departments"
                        :key="index">{{ department.office_address }}</option>
                </select>
            </div>

            <div class="form-group mb-3">
                <label for="" class="form-label">* Your Address:</label>
                <input
                    type="text"
                    class="form-control form-control-sm rounded-0"
                    placeholder="ex. #123 Apartment Stree"
                    v-model="form.address"
                    disabled>
            </div>

            <div class="row">

                <div class="col-md-7">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">* Email:</label>
                        <input
                            type="text"
                            class="form-control form-control-sm rounded-0"
                            placeholder="ex. example123@gmail.com"
                            v-model="form.email"
                            disabled>
                    </div>
                </div>

                <div class="col-md-5">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">* Mobile Number:</label>
                        <input
                            type="text"
                            class="form-control form-control-sm rounded-0"
                            placeholder="ex. +123456789"
                            v-model="form.mobile_number"
                            disabled>
                    </div>
                </div>

            </div>

        </div>

    </form>

</template>

<script>
import apiClient from '@/services/index';

export default
{
    name: "View User Account",

    data()
    {
        return{
            form:
            {
                id_number: "",
                full_name: "",
                office_name: "",
                position: "",
                office_address: "",
                address: "",
                email: "",
                mobile_number: "",
                username: "",
                password: "",
                role: "",

            },
            departments: []
        }
    },

    mounted()
    {
        this.fetchAccountData();
        this.fetchDepartmentData()
    },

    methods:
    {
        async fetchAccountData()
        {
            try
            {
                const response = await apiClient.get(`/account/${this.$route.params.id}`);
                this.form = response.data;
                console.log("Fetch account:", response.data);
            }
            catch(error)
            {
                console.error("Error occured:", error);
            }
        },

        async fetchDepartmentData()
        {
            try
            {
                const response = await apiClient.get(`/department`)
                this.departments = response.data;
                console.log("Fetched department:", response.data);
            }
            catch(error)
            {
                console.error(error);
            }
        }
    }
}
</script>

<style scoped>
.page-title {
    color: #007bff;
}
.button-color {
    background-color: #007bff;
    color: #ffffff;
}
.button-color:hover {
    background-color: #3798ff;
    color: #ffffff;
}
.text-title {
    color: #007bff;
}
</style>