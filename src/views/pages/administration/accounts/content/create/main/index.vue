<template>
    <form @submit.prevent="submit()" class="mt-4">
        <div class="card card-body shadow-sm border-0 rounded-0 col-6 mx-md-auto">
            <h4 class="mb-3">Fill out the field approximately.</h4>
            <h3 class="mb-3 text-title">ACCOUNT DETAILS</h3>

            <div class="row">
                <div class="col-md-8">
                    <div class="form-group mb-3">
                        <label class="form-label">* Full Name:</label>
                        <input
                            type="text"
                            class="form-control rounded-0"
                            placeholder="ex. Juan Dela Cruz"
                            v-model="form.full_name"
                            required
                        >
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="form-group mb-3">
                        <label class="form-label">Status:</label>
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
                        <label class="form-label">* E-mail:</label>
                        <input
                            type="email"
                            class="form-control rounded-0"
                            placeholder="ex. juandelacruz@gmail.com"
                            v-model="form.email"
                            required
                        >
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="form-group mb-3">
                        <label class="form-label">Mobile Number:</label>
                        <input
                            type="text"
                            class="form-control rounded-0"
                            placeholder="ex. 09xxxxxxxx"
                            v-model="form.mobile_number"
                            required
                        >
                    </div>
                </div>
            </div>

            <h3 class="mb-0 text-title">SYSTEM ACCOUNT</h3>

            <div class="row">
                <div class="col-md-4">
                    <div class="form-group mb-3">
                        <label class="form-label">Username:</label>
                        <input
                            type="text"
                            class="form-control rounded-0"
                            placeholder="ex. juandelacruz"
                            v-model="form.username"
                            @input="updatePassword"
                            required
                        >
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="form-group mb-3">
                        <label class="form-label">Default Password:</label>
                        <input
                            type="text"
                            class="form-control rounded-0"
                            v-model="form.password"
                            placeholder="ex. @juandelacruz"
                            disabled
                        >
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="form-group mb-3">
                        <label class="form-label">Role:</label>
                        <select class="form-select rounded-0" v-model="form.role" required>
                            <option value="0" disabled selected>- select role -</option>
                            <option value="1">Admin</option>
                            <option value="2">Landlord</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="text-end">
                <router-link
                    :to="'/administration/accounts'"
                    class="btn rounded-0 btn-secondary me-3"
                >
                    Cancel
                </router-link>

                <button
                    type="submit"
                    class="btn rounded-0 button-color"
                    :disabled="isLoading"
                >
                    <span v-if="!isLoading">Submit</span>
                    <span v-else>Submitting...</span>
                </button>
            </div>
        </div>
    </form>
</template>

<script>
import apiClient from "@/services/index";
import { useToast } from "vue-toastification";

export default
{
    data()
    {
        return {
            form:
            {
                full_name: "",
                email: "",
                mobile_number: "",
                address: "",
                username: "",
                password: "",
                role: "2",
                status: "0"
            },
            isLoading: false,
            toast: null
        };
    },

    created()
    {
        this.toast = useToast();
    },

    computed:
    {
        defaultPassword()
        {
            return this.form.username ? `@${this.form.username}` : "";
        }
    },

    methods:
    {
        updatePassword()
        {
            this.form.password = this.defaultPassword;
        },

        async submit()
        {
            this.isLoading = true;

            try
            {
                const response = await apiClient.post("/accounts", this.form);
                console.log(response.data);

                this.toast.success("Account created successfully!");

                setTimeout(() =>
                {
                    this.$router.push("/administration/accounts");
                }, 1000);
            }
            catch (error)
            {
                const status = error.response?.status;
                const message = error.response?.data?.error || "Create failed";

                if (status === 401)
                {
                    this.toast.error("Unauthorized: Please check your credentials.");
                }
                else if (status === 403)
                {
                    this.toast.error("Access denied. You do not have permission.");
                }
                else
                {
                    this.toast.error("Failed to create account. Please try again.");
                }

                console.error("Create failed:", message);
            }
            finally
            {
                this.isLoading = false;
            }
        }
    }
};
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
