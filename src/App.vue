<template>
    <!-- Render dashboard panel only if logged in -->
    <PanelComponent v-if="isLoggedIn" />
    
    <!-- Render router-view for public pages: /signin, /commercialhub -->
    <router-view v-else/>
</template>

<script>
import PanelComponent from "@/views/panel";

export default
{
    
    components:
    {
        PanelComponent
    },

    data()
    {
        return {
            accessToken: localStorage.getItem("access_token"),
        };
    },

    computed:
    {
        isLoggedIn()
        {
            return !!this.accessToken;
        },
    },

    mounted()
    {
    // Optional: watch for localStorage changes
        window.addEventListener("storage", () => {
        this.accessToken = localStorage.getItem("access_token");
        });
    },
};
</script>
