<template>
    <header>
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <nav class="navbar-expand-lg">
                        <a
                            href="/"
                            class="navbar-brand">
                                <img src="@/assets/images/capas_logo.png" alt="" width="40">
                        </a>
                        
                        <div class="d-flex align-items-center">
                            <div class="me-3 bell-icon">
                                <a v-if="!isLoggedIn" href="#"></a>
                                <a v-else href="/notification" style="color: #fff;">
                                    <i class="bx bx-bell"></i>
                                    <span v-if="notificationCount > 0" class="badge">{{ notificationCount }}</span>
                                </a>
                            </div>
                            <div class="sc-button-nav">
                                <button
                                    type="button"
                                    class="navbar-toggler bx bx-menu"
                                    data-bs-toggle="offcanvas"
                                    data-bs-target="#offcanvasNavbar"
                                    aria-controls="offcanvasNavbar"
                                    aria-label="Toggle navigation">
                                </button>
                            </div>
                        </div>

                        <div class="offcanvas offcanvas-start sc-offcanvas-inner" tabindex="-1" id="offcanvasNavbar" aria-labelledby="offcanvasNavbarLabel">
                            <div class="offcanvas-header sc-button-close">
                                <button
                                    type="button"
                                    data-bs-dismiss="offcanvas"
                                    aria-label="Close">
                                    <i class="bx bx-x" style="color: #fff; font-size: 2rem;"></i>
                                </button>
                            </div>
                            <div class="offcanvas-body text-center" style="background-color: #000080;">
                                <ul class="navbar-nav justify-content-end flex-grow-1 sc-menu-nav">
                                    <li>
                                        <i class="bx bx-home me-2" style="color: #fff;"></i>
                                        <a href="/">Home</a>
                                    </li>
                                    <li>
                                        <i class="bx bx-building-house me-2" style="color: #fff;"></i>
                                        <a href="/commercialhub/properties">Properties</a>
                                    </li>

                                    <div class="bell-icon-def">
                                        <li v-if="!isLoggedIn"></li>
                                        <li v-else>
                                            <a href="/notification">
                                                <i class="bx bx-bell"></i>
                                                <span v-if="notificationCount > 0" class="badge">{{ notificationCount }}</span>
                                            </a>
                                        </li>
                                    </div>
 
                                    <div v-if="!isLoggedIn" class="desktop-view" style="margin-left: 0px;">
                                        <li style="margin-left: 0px;">
                                            <i class="bx bx-user me-2" style="color: #fff;"></i>
                                            <a href="/signin">Login</a>
                                        </li>
                                        <li>
                                            <i class="bx bx-user-plus me-2" style="color: #fff;"></i>
                                            <a href="/registration">Register</a>
                                        </li>
                                    </div>

                                    <div v-if="!isLoggedIn" class="mobile-view" style="margin-left: 0px;">
                                        <li style="margin-left: 0px;">
                                            <i class="bx bx-user me-2" style="color: #fff;"></i>
                                            <a href="/signin">Login</a>
                                        </li>
                                        <li>
                                            <i class="bx bx-user-plus me-2" style="color: #fff;"></i>
                                            <a href="/registration">Register</a>
                                        </li>
                                    </div>

                                    <li v-else class="dropdown desktop-view">
                                        <a
                                            href="#"
                                            role="button"
                                            data-bs-toggle="dropdown"
                                            aria-expanded="false">
                                            <i class="bx bx-user"></i>
                                        </a>
                                        <ul class="dropdown-menu dropdown-menu-end rounded-0 mt-4" style="height: auto;">
                                            <li class="m-0">
                                                <a href="/account/profile" class="dropdown-item d-flex align-items-center" style="color: #000;">
                                                    <i class="bx bx-user me-2"></i>
                                                    <span>My Profile</span>
                                                </a>
                                            </li>
                                            <li class="m-0">
                                                <a href="/favorite" class="dropdown-item d-flex align-items-center" style="color: #000;">
                                                    <i class="bx bx-heart me-2"></i>
                                                    <span>Saved Properties</span>
                                                </a>
                                            </li>
                                            <li class="m-0">
                                                <a href="/message" class="dropdown-item d-flex align-items-center" style="color: #000;">
                                                    <i class="bx bx-message me-2"></i>
                                                    <span>Messages</span>
                                                </a>
                                            </li>
                                            <li style="margin-left: 0px">
                                                <a class="dropdown-item d-flex align-items-center" href="#" @click.prevent="logout" style="color: #000;">
                                                    <i class="bx bx-log-out me-2"></i>
                                                    <span>Logout</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>

                                    
                                    <div v-if="!isLoggedIn"></div>
                                    <div v-else class="mobile-view">
                                        <li>
                                            <a href="/account/profile">
                                                <i class="bx bx-user me-2"></i>
                                                <span>My Profile</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="/favorite">
                                                <i class="bx bx-heart me-2"></i>
                                                <span>Saved Properties</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="/message">
                                                <i class="bx bx-message me-2"></i>
                                                <span>Messages</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#" @click.prevent="logout">
                                                <i class="bx bx-log-out me-2"></i>
                                                <span>Logout</span>
                                            </a>
                                        </li>
                                    </div>
                                    
                                </ul>
                            </div>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </header>
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

        if (this.isLoggedIn)
        {
            this.loadNotificationCount();

            this.notificationInterval = setInterval(() =>
            {
                this.loadNotificationCount();
            }, 3000);
        }

        const inquiryId = this.$route.query.inquiry_id;

        if (inquiryId)
        {
            console.log("Redirect to inquiry:", inquiryId);
            this.openInquiry(inquiryId);
        }
    },

    beforeUnmount()
    {
        clearInterval(this.notificationInterval);
    },

    methods:
    {
        async openInquiry(inquiryId)
        {
            try
            {
                const res = await apiClient.get(`/inquiries/${inquiryId}/messages`);
                this.messages = res.data; // assuming you have messages array
                this.activeInquiryId = inquiryId;
            }
            catch (error)
            {
                console.error("Failed to load inquiry messages:", error);
            }
        },

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

.navbar .nav-link
{
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0.5rem;
}

header
{
    background-color: #000080;
}

header nav
{
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    z-index: 500;
}

header nav .sc-button-nav button
{
    background-color: transparent;
    border: none;
    outline: none;
    font-size: 28px;
    color: #ffffff;
}

header nav .sc-menu-nav li
{
    margin-left: 20px;
}

header nav .sc-menu-nav li a
{
    text-decoration: none;
    color: #ffffff;
    cursor: pointer;
}

header nav .sc-offcanvas-inner
{
    background-color: #000080;
}

header nav .sc-offcanvas-inner .sc-button-close button
{
    background: transparent;
    outline: none;
    border: none;
}

header nav .sc-offcanvas-inner .desktop-view
{
    display: flex;
}

.bell-icon-def
{
    position: relative;
    display: inline-block;
}

.bell-icon-def .badge
{
    position: absolute;
    top: 0;
    right: 0;
    transform: translate(50%, -50%);
    background: red;
    color: white;
    font-size: 0.6rem;
    border-radius: 100px;
    padding: 2px 6px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.bell-icon
{
    position: relative;
    display: inline-block;
}

.bell-icon .badge
{
    position: absolute;
    top: 0;
    right: 0;
    transform: translate(50%, -50%);
    background: red;
    color: white;
    font-size: 0.6rem;
    border-radius: 100px;
    padding: 2px 6px;
    display: flex;
    align-items: center;
    justify-content: center;
}

header nav .sc-offcanvas-inner .mobile-view
{
    display: none;
}

@media (max-width: 767px)
{
    header nav .sc-offcanvas-inner
    {
        width: 100% !important;
    }

    header nav .sc-menu-nav li
    {
        margin-left: 0px;
        padding-bottom: 20px;
    }

    header nav .sc-menu-nav li a
    {
        font-size: 1.5rem;
        font-weight: 400;
    }

    header nav .sc-offcanvas-inner .sc-button-close
    {
        display: flex;
        justify-content: flex-end;
        align-items: flex-end;
    }

    header nav .sc-offcanvas-inner .desktop-view
    {
        display: none;
    }

    header nav .sc-offcanvas-inner .mobile-view
    {
        display: block;
    }

    .bell-icon-def
    {
        display: none;
    }

    .bell-icon
    {
        display: inline-block;
    }

    .bell-icon .badge
    {
        top: 0;
        right: 0;
        transform: translate(50%, -50%);
    }
}

@media (min-width: 768px)
{
    .bell-icon
    {
        display: none;
    }

    .bell-icon-def
    {
        display: inline-block;
    }
}
</style>