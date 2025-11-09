<template>
    <div class="sidebar">
        <div class="sidebar-logo">
            <img src="@/assets/images/capas_logo.png" alt="">
        </div>

        <ul class="sidebar-nav ps-0">
            <!-- Show AdminAccount component if role is 1 (admin) -->
            <admin-account v-if="role === 1" />

            <!-- Show UserAccount component if role is 2 (user) -->
            <landlord-account v-if="role === 2" />

            <li>
                <a @click="logout"><i class="bx bx-log-out me-2"></i>Logout</a>
            </li>
        </ul>
    </div>
</template>

<script>
import AdminAccount from "./content/admin.vue";
import LandlordAccount from "./content/landlord.vue";
import { useToast } from "vue-toastification";
export default
{
    components:
    {
        AdminAccount,
        LandlordAccount
    },

    data()
    {
        return {
            // Get role from sessionStorage as an integer (parse it)
            role: parseInt(sessionStorage.getItem('role')) || 0, // Default to 0 (guest) if role not found
        };
    },

    created()
    {
        this.toast = useToast();
    },

    methods:
    {
        logout()
        {
            // Clear the sessionStorage
            sessionStorage.removeItem('role');
            sessionStorage.removeItem('access_token');  // If token is stored as well
            sessionStorage.removeItem('user_id');  // If token is stored as well

            // ACCOUNT INFO
            sessionStorage.removeItem('account');
            sessionStorage.removeItem('full_name');
            sessionStorage.removeItem('id_number');
            sessionStorage.removeItem('office_name');
            sessionStorage.removeItem('office_address');
            sessionStorage.removeItem('position');
            sessionStorage.removeItem('mobile_number');
            sessionStorage.removeItem('username');
            sessionStorage.removeItem('email');
            sessionStorage.removeItem('address');

            // Show the toast first
            this.toast.success("Logged out successfully!");

            // Redirect after short delay to allow the toast to show
            setTimeout(() => {
                window.location.href = '/signin';
            }, 1000); // 1 second delay (adjust if needed)
        }
    }
};
</script>

<style>
</style>
