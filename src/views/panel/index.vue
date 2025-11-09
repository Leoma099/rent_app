<template>
    <div v-if="!accessToken">
        <signin-component />
    </div>

    <div v-else-if="role === 1 || role === 2">
        <sidebar-component />
        <div class="main-wrapper">
            <header-component />
            <div class="main">
                <router-view />
            </div>
        </div>
    </div>

    <div v-else-if="role === 3">
        <router-view />
    </div>
</template>

<script>
import SidebarComponent from "@/views/layouts/sidebar";
import HeaderComponent from "@/views/layouts/header";
import SigninComponent from "@/views/pages/auth";

export default 
{
    components: 
    {
        SidebarComponent,
        HeaderComponent,
        SigninComponent
    },
    data() 
    {
        return {
            accessToken: sessionStorage.getItem("access_token"),
            role: parseInt(sessionStorage.getItem("role")) || null
        };
    }
};
</script>