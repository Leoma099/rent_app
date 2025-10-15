<template>
    <!-- Splash screen while loading -->
    <div v-if="isLoading" class="splashscreen">
        <div class="splash-content">
            <img src="@/assets/images/capas_logo.png" alt="Logo" class="splash-logo" />
            <h2>Loading...</h2>
        </div>
    </div>

    <!-- Main content -->
    <div v-else>
        <hero-component
            :filters="filters"
            @search="fetchProperties"
        />

        <main-component
            :items="items"
            :isLoading="isLoading"
        />
    </div>
</template>

<script>
import HeroComponent from "./content/hero.vue";
import MainComponent from "./content/main.vue";
import apiClient from "@/services";

export default {
    components: {
        HeroComponent,
        MainComponent
    },

    data() {
        return {
            filters: {
                property_type: "",
                search: ""
            },
            items: [],
            isLoading: false,
        };
    },

    methods:
    {
        async fetchProperties()
        {
            try
            {
                this.isLoading = true;

                const token = localStorage.getItem("access_token");
                const endpoint = token ? "/properties" : "/properties";

                const response = await apiClient.get(endpoint, {
                    headers: token ? { Authorization: `Bearer ${token}` } : {},
                    params: this.filters
                });

                this.items = response.data;
                console.log("Filtered Properties:", response.data);
            }
            catch (error)
            {
                console.error("Error fetching properties:", error);
            }
            finally
            {
                // Simulate small delay to show splash animation smoothly
                setTimeout(() => {
                    this.isLoading = false;
                }, 3000);
            }
        }
    },

    created() {
        this.fetchProperties();
    }
};
</script>

<style scoped>
.splashscreen {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100vh;
    background: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    animation: fadeIn 0.4s ease-in;
}

.splash-content {
    text-align: center;
    animation: fadeInUp 1s ease;
}

.splash-logo {
    width: 120px;
    height: auto;
    margin-bottom: 15px;
}

/* @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
} */
</style>
