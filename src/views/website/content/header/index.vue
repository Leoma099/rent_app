<template>
    <nav class="navbar navbar-expand-lg shadow-sm" style="background-color: #000080;">
        <div class="container">
            <!-- Left Logo -->
            <router-link :to="'/commercialhub'">
                <img src="@/assets/images/capas_logo.png" alt="" width="30">
            </router-link>

            <button
                class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarNav"
                aria-controls="navbarNav"
                aria-expanded="false"
                aria-label="Toggle navigation"
            >
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Right Navigation -->
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav d-flex align-items-center">

                    <!-- Always visible link -->
                    <li class="nav-item">
                        <router-link class="nav-link text-white" :to="'/commercialhub'">
                            <i class="bx bx-home me-1"></i>
                            <span>Home</span>
                        </router-link>
                    </li>

                    <li class="nav-item">
                        <router-link class="nav-link d-flex align-items-center text-white" :to="'/commercialhub/properties'">
                            <i class="bx bx-building-house me-1"></i>
                            <span>Properties</span>
                        </router-link>
                    </li>

                    <li
                        class="nav-item position-relative"
                        v-if="!isLoggedIn">
                        
                    </li>

                    <li class="nav-item position-relative" v-else>
                        <router-link class="nav-link text-white" :to="'/notification'">
                            <i class="bx bx-bell"></i>
                            <span v-if="notificationCount > 0" class="badge">{{ notificationCount }}</span>
                        </router-link>
                    </li>

                    <li v-if="!isLoggedIn" class="nav-item">
                        <div class="d-flex align-items-center">
                            <router-link class="nav-link text-white" :to="'/signin'">Login</router-link>
                            /<router-link class="nav-link text-white" :to="'/registration'">Register</router-link>
                        </div>
                    </li>

                    <li v-else class="nav-item dropdown">
                        <a
                            class="nav-link text-white"
                            href="#"
                            role="button"
                            data-bs-toggle="dropdown"
                            aria-expanded="false">
                            <i class="bx bx-user"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end rounded-0 mt-2" style="height: auto;">
                            <li class="m-0">
                                <router-link class="dropdown-item" :to="`/account/profile`"><i class="bx bx-user me-2"></i> My Profile</router-link>
                            </li>
                            <li class="m-0">
                                <router-link class="dropdown-item" :to="`/favorite`"><i class="bx bx-heart me-2"></i> Saved Properties</router-link>
                            </li>
                            <li>
                                <a class="dropdown-item" href="#" @click.prevent="logout"><i class="bx bx-log-out me-2"></i> Logout</a>
                            </li>
                        </ul>
                    </li>


                </ul>
            </div>
        </div>
    </nav>
</template>

<script>
import { useToast } from "vue-toastification";
import apiClient from '@/services';

export default
{
    data()
    {
        return {
            userName: localStorage.getItem("full_name") || "",
            role: parseInt(localStorage.getItem("role")) || null,
            notificationCount: 0,
            toast: null,
            notificationInterval: null
        };
    },

    computed:
    {
        isLoggedIn()
        {
            return !!localStorage.getItem("access_token");
        },

        dashboardLink()
        {
            return this.role === 3 ? "/commercialhub" : "/dashboard";
        }
    },

    mounted()
    {
        this.toast = useToast();

        // ✅ Only run notification check if user is logged in
        if (this.isLoggedIn)
        {
            this.loadNotificationCount();

            // ✅ Fetch every 10 seconds (10000 ms)
            this.notificationInterval = setInterval(() =>
            {
                this.loadNotificationCount();
            }, 10000);
        }
    },

    beforeUnmount()
    {
        clearInterval(this.notificationInterval);
    },

    methods:
    {
        logout()
        {
            localStorage.clear();
            this.userName = "";
            this.role = null;

            if (this.toast)
            {
                this.toast.success("You have been logged out successfully.");
            }

            this.$router.push("/commercialhub").then(() =>
            {
                window.location.reload();
            });
        },

        async loadNotificationCount()
        {
            // ✅ Don't call API if not logged in
            if (!this.isLoggedIn)
            {
                this.notificationCount = 0;
                return;
            }

            try
            {
                const res = await apiClient.get('/notifications');
                const notifications = res.data.data || [];
                this.notificationCount = notifications.filter(n => !n.read_at).length;
            }
            catch (error)
            {
                console.error("Error loading notifications:", error);
            }
        }
    }
};
</script>


<style scoped>
.navbar 
{
    padding: 0.5rem 1rem;
}
.navbar .nav-link {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0.5rem;
}
.badge 
{
    position: absolute;
    top: 0;
    left: 15px;
    background: red;
    color: white;
    font-size: 0.6rem;
    border-radius: 100px;
}
</style>
