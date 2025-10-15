<template>

    <div class="container my-5">

        <div class="col-md-6 mx-auto">

            <div class="card card-body card-white rounded-0 shadow-sm">

                <p><strong>* Fill out the form appropriately</strong></p>

                <form @submit.prevent="submit()">

                    <div class="mb-3">
                        <label for="" class="form-label"><small>* Tenant Name:</small></label>
                        <select class="form-select rounded-0  border-0 border-bottom border-2" v-model="form.tenant_id">
                            <option value="" disabled>-- choose tenant name --</option>
                            <option
                                v-for="account in accounts"
                                :key="account.id"
                                :value="account.id">
                                {{ account.full_name }}
                            </option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="" class="form-label"><small>* Property Name:</small></label>
                        <select class="form-select rounded-0  border-0 border-bottom border-2" v-model="form.property_id">
                            <option value="" disabled>-- choose property name --</option>
                            <option
                                v-for="property in properties"
                                :key="property.id"
                                :value="property.id">
                                {{ property.title }}
                            </option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="" class="form-label"><small>* Start Date:</small></label>
                        <input
                            v-model="form.start_date"
                            type="date"
                            class="form-control rounded-0 border-0 border-bottom border-2">
                    </div>

                    <div class="mb-3">
                        <label for="" class="form-label"><small>* End Date:</small></label>
                        <input
                            v-model="form.end_date"
                            type="date"
                            class="form-control rounded-0 border-0 border-bottom border-2">
                    </div>

                    <div class="text-end">
                        <router-link
                            :to="'/landlord/leases'"
                            class="btn btn-sm btn-secondary rounded-0 me-3">
                            Cancel
                        </router-link>
                        <button
                            type="submit"
                            class="btn btn-sm btn-primary rounded-0">
                            Submit
                        </button>
                    </div>

                </form>

            </div>

        </div>

    </div>

</template>

<script>
import apiClient from '@/services';
import { useToast } from "vue-toastification";
export default
{
    data()
    {
        return {
            properties: [],
            accounts: [],
            form:
            {
                tenant_id: "",
                property_id: "",
                start_date: this.currentDate(),
                end_date: this.futureDate(30),
                status: 0,
            }

        }
    },

    created()
    {
        this.loadUser();
        this.loadProperty();
        this.toast = useToast();
    },

    methods:
    {
        async loadUser()
        {
            const response = await apiClient.get(`/accounts`);
            this.accounts = response.data.data.filter(account => account.user.role === 3);
        },

        async loadProperty()
        {
            const response = await apiClient.get(`/properties`);
            this.properties = response.data;
        },

        async submit()
        {
            try
            {
                const response = await apiClient.post(`/leases`, this.form);
                this.items = response.data;
                setTimeout(() => {
                    this.$router.push('/landlord/leases');
                }, 1000);
                this.toast.success("Create lease successfully!");
            }
            catch(error)
            {
                console.error("Error:", error);
                this.toast.error("Failed to create lease. Please try again.");
            }
        },

        currentDate()
        {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, "0"); // add leading zero
            const day = String(today.getDate()).padStart(2, "0");
            return `${year}-${month}-${day}`;
        },

        futureDate(days = 30)
        {
            const today = new Date();
            today.setDate(today.getDate() + days); // add days (default 30)

            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, "0");
            const day = String(today.getDate()).padStart(2, "0");
            return `${year}-${month}-${day}`;
        }
    }


}
</script>

<style scoped>
input:focus,
textarea:focus,
select:focus {
  outline: none !important;
  box-shadow: none !important;
}
</style>