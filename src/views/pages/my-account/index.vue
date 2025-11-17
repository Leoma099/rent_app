<template>

    <h1>My Account</h1>

    <router-link :to="'/administration/dashboard'">Go back to page</router-link>

    <div class="mt-3">

        <div class="col-md-4 mx-md-auto">

            <div class="card card-body shadow-sm border-0">
                <h3 class="page-title">Account Info</h3>
                <div>
                    <div class="d-flex align-items-center">
                        <small class="mb-0 me-3">Full Name:</small>
                        <p class="mb-0"><strong>{{ user.full_name }}</strong></p>
                    </div>
                    <div class="d-flex align-items-center">
                        <small class="mb-0 me-3">Email Address:</small>
                        <p class="mb-0"><strong>{{ user.email }}</strong></p>
                    </div>
                    <div class="d-flex align-items-center">
                        <small class="mb-0 me-3">MOBILE NUMBER:</small>
                        <p class="mb-0"><strong>{{ user.mobile_number }}</strong></p>
                    </div>
                </div>
                <hr>
                <h3 class="page-title">System Info</h3>
                <div>
                    <div class="d-flex align-items-center">
                        <small class="mb-0 me-3">username:</small>
                        <p class="mb-0"><strong>{{ user.username }}</strong></p>
                    </div>
                </div>

                <button
                    class="btn btn-outline-primary mt-3 rounded-0"
                    data-bs-toggle="modal"
                    data-bs-target="#updateProfile">
                    Update Profile
                </button>
            </div>

        </div>

    </div>

    <update-modal />

</template>
<script>
import UpdateModal from "./components/update.vue";
export default
{
    data()
    {
        return{
            user: null
        }
    },

    components:
    {
        UpdateModal
    },

    created()
    {
        this.fetchUserData();
    },

    methods:
    {
        fetchUserData()
        {
            const user = {
                id_number: localStorage.getItem('id_number'),
                full_name: localStorage.getItem('full_name'),
                mobile_number: localStorage.getItem('mobile_number'),
                office_name: localStorage.getItem('office_name'),
                office_address: localStorage.getItem('office_address'),
                position: localStorage.getItem('position'),
                email: localStorage.getItem('email'),
                username: localStorage.getItem('username'),
                address: localStorage.getItem('address'),
            };

            if(user.full_name)
            {
                this.user = user
            }
        }
    }

}
</script>

<style scoped>
.page-title
{
    color: #007bff;
}
</style>