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
            // Get role from localStorage as an integer (parse it)
            role: parseInt(localStorage.getItem('role')) || 0, // Default to 0 (guest) if role not found
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
            // Clear only keys that exist in login
            localStorage.removeItem('access_token');
            localStorage.removeItem('role');
            localStorage.removeItem('user_id');
            localStorage.removeItem('account');
            localStorage.removeItem('full_name');
            localStorage.removeItem('mobile_number');
            localStorage.removeItem('username');
            localStorage.removeItem('email');
            localStorage.removeItem('expiresAt'); // important for auto-logout

            // Show logout toast
            this.toast.success("Logged out successfully!");

            // Redirect to signin after 1 second
            setTimeout(() => {
                window.location.href = '/signin';
            }, 1000);
        }

    }
};
</script>

<style>
</style>
