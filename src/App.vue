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
<style scoped>

/* Default (desktop/tablet) */
.Vue-Toastification__toast {
  max-width: 320px !important;
  width: 100%;
  padding: 12px 16px;
  border-radius: 10px;
  font-size: 0.95rem;
}

.Vue-Toastification__toast-body {
  word-break: break-word;
}

/* Mobile view */
@media (max-width: 480px) {
  .Vue-Toastification__toast {
    max-width: 240px !important;
    padding: 10px 14px;
    font-size: 0.85rem;
  }
}

</style>
