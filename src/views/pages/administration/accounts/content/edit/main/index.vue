<template>

    <div v-if="isLoading" class="loading-overlay">
        <div class="spinner"></div>
    </div>

    <form @submit.prevent="submit()" class="mt-4">

        <div class="card card-body shadow-sm border-0 rounded-0 col-6 mx-auto">

            <h3 class="mb-3 text-title">ACCOUNT DETAILS</h3>

            <div class="row">

                <div class="col-md-8">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">* Full Name:</label>
                        <input type="text" class="form-control rounded-0" placeholder="ex. Juan Dela Cruz" v-model="form.full_name" required>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">Status:</label>
                        <select class="form-select rounded-0" v-model="form.status" required>
                            <option value="" disabled selected>- select status -</option>
                            <option value="0">Inactive</option>
                            <option value="1">Active</option>
                        </select>
                    </div>
                </div>

            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">* E-mail:</label>
                        <input type="text" class="form-control rounded-0" placeholder="ex. juandelacruz@gmail.com" v-model="form.email" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group mb-3">
                        <label for="" class="form-label">Mobile Number:</label>
                        <input type="text" class="form-control rounded-0" placeholder="ex. 09xxxxxxxx" v-model="form.mobile_number" required>
                    </div>
                </div>
            </div>

            <div class="text-end">
                <router-link
                    :to="'/administration/accounts'"
                    class="btn rounded-0 btn-secondary me-3">
                    Cancel
                </router-link>
                <button
                    type="submit"
                    class="btn rounded-0 button-color">
                    <span v-if="!isLoading">Submit</span>
                    <span v-else>Submitting...</span>
                </button>
            </div>

        </div>

    </form>

</template>

<script>
import apiClient from '@/services';
import { useToast } from "vue-toastification";
export default
{
    name: "Edit User Account",

    data()
    {
        return{
            form:
            {
                full_name: "",
                email: "",
                mobile_number: "",
                address: "",
                username: "",
                password: "",
                role: "",
                status: "",
            },
            isLoading: false,
        };
    },

    created()
    {
        this.toast = useToast();
        this.loadAccount();
        this.loadUser();
    },

    methods:
    {
        async loadAccount()
        {
            try
            {
                const accountData = await apiClient.get(`/accounts/${this.$route.params.id}`);
                this.form = {
                    ...this.form,
                    ...accountData.data
                };
                console.log("Fetch account:", accountData.data);
            }
            catch(error)
            {
                console.error("Error occured:", error);
            }
        },

        async loadUser()
        {
            try
            {
                const userData = await apiClient.get(`/user/${this.$route.params.id}`);
                this.form = {
                    ...this.form,
                    ...userData.data
                };
                console.log("Fetch account:", userData.data);
            }
            catch(error)
            {
                console.error("Error occured:", error);
            }
        },

        async submit()
        {
            this.isLoading = true;
            
            try
            {
                const response = await apiClient.put(`/admin/account/${this.$route.params.id}`, this.form);
                console.log(response.data);
                this.$router.push('/administration/accounts');

                this.toast.success("Update successfully!");
            }
            catch (error)
            {
                this.isLoading = false;

                const status = error.response?.status;
                const message = error.response?.data?.error || "Update failed";

                if (status === 401)
                {
                    this.toast.error("Updated unsuccessfully.");
                }
                else if (status === 403)
                {
                    this.toast.error("Something wrong.");
                }
                else
                {
                    this.toast.error("Update unsuccessful! Please try again.");
                }

                console.error('Update failed:', message);
            }

            finally
            {
                this.isLoading = false;
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
/* Add styles for the loading spinner */
.loading-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 255, 255, 0.7);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.spinner {
    border: 4px solid #f3f3f3; /* Light grey */
    border-top: 4px solid #3498db; /* Blue */
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>