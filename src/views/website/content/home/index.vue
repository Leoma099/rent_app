<template>
    <div>
        <!-- Splashscreen with fade-in transition -->
        <div v-if="isLoading" class="splashscreen">
            <div class="splash-content">
                <img src="@/assets/images/capas_logo.png" alt="Logo" class="splash-logo" />
                <h2>Loading...</h2>
            </div>
        </div>

        <!-- Main content with fade-in transition -->
        <transition name="fade" appear>
            <div v-if="!isLoading">
                <hero-component
                    :filters="filters"
                    @search="fetchProperties"
                />
                
                <main-component
                    :items="items"
                    :isLoading="isLoading"
                />
            </div>
        </transition>
    </div>
</template>

<script>
import HeroComponent from "./content/hero.vue";
import MainComponent from "./content/main.vue";
import apiClient from "@/services";

export default
{
    components:
    {
        HeroComponent,
        MainComponent
    },

    data()
    {
        return{
            filters:
            {
                property_type: "",
                search: ""
            },
            items: [],
            isLoading: false
        };
    },

    methods:
    {
        async fetchProperties()
        {
            this.isLoading = true;

            try
            {
                const token = localStorage.getItem("access_token");
                const endpoint = token ? "/properties" : "/properties";

                const response = await apiClient.get(endpoint,
                {
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
                setTimeout(() => {
                    this.isLoading = false;
                }, 1000);
            }
        }
    },

    created()
    {
        this.fetchProperties();
    }
};
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active
{
    transition: opacity 0.6s ease;
}

.fade-enter-from,
.fade-leave-to
{
    opacity: 0;
}

.fade-enter-to,
.fade-leave-from
{
    opacity: 1;
}

.splashscreen
{
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
}

.splash-content
{
    text-align: center;
    animation: fadeInUp 0.6s ease;
}

.splash-logo
{
    width: 120px;
    height: auto;
    margin-bottom: 15px;
}

@keyframes fadeInUp
{
    from
    {
        opacity: 0;
        transform: translateY(20px);
    }
    to
    {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>
