<template>

    <!-- Splash Screen (only on first load) -->
    <div v-if="showSplash" class="splashscreen">
        <div class="splash-content">
            <img src="@/assets/images/capas_logo.png" alt="Logo" class="splash-logo" />
            <h2>Loading...</h2>
        </div>
    </div>

    <!-- Page Content -->
    <div v-else>
        <div class="position-relative text-center text-white">
            <img
                class="img-fluid w-100"
                src="@/assets/images/property/residences.jpg"
                alt="Featured Property"
                style="max-height: 400px; object-fit: cover; filter: brightness(50%)">

            <div class="position-absolute top-50 start-50 translate-middle text-center">
                <h1 class="display-4 fw-bold">Browse Properties</h1>
                <p class="lead">Find, compare, and inquire — all in one place.</p>
            </div>
        </div>

        <div class="container my-5">

            <!-- Filters -->
            <div>
                <div class="row g-3 align-items-center">
                    <div class="col-md-3">
                        <select v-model="filters.property_type" class="form-select" @change="fetchProperties">
                            <option value="">All Property</option>
                            <option value="Office Space">Office Space</option>
                            <option value="Retail Shop">Retail Shop</option>
                            <option value="Restaurant">Restaurant</option>
                            <option value="Warehouse">Warehouse</option>
                            <option value="Industrial">Industrial</option>
                            <option value="Co-working">Co-working</option>
                            <option value="Hotel">Hotel</option>
                            <option value="Clinic">Clinic</option>
                            <option value="House">House</option>
                            <option value="Apartment">Apartment</option>
                            <option value="Townhouse">Townhouse</option>
                            <option value="Studio">Studio</option>
                            <option value="Land">Land</option>
                            <option value="Commercial">Commercial</option>
                            <option value="Parking Space">Parking Space</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <input
                            v-model="filters.search"
                            type="text"
                            class="form-control"
                            placeholder="Enter location or property name">
                    </div>

                    <div class="col-md-3 d-grid">
                        <button type="button" class="btn btn-primary w-100" @click="fetchProperties">
                            Search
                        </button>
                    </div>
                </div>
            </div>

            <!-- Spinner (only for data reload, not for splash) -->
            <div v-if="isLoading" class="text-center my-5">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="mb-0">Loading search results. Please wait.</p>
            </div>

            <!-- Property List -->
            <div v-else>
                <div class="mt-3">
                    <p class="text-secondary fs-5 mb-0">{{ propertyCount }} listings</p>
                </div>

                <div class="mt-3">
                    <div class="row g-4">
                        <item-component
                            v-for="(item, index) in items"
                            :key="index"
                            :item="item" />
                    </div>
                </div>
            </div>
        </div>
    </div>

</template>

<script>
import apiClient from "@/services";
import ItemComponent from "./content/item.vue";

export default
{
    components:
    {
        ItemComponent
    },

    data()
    {
        return {
            filters:
            {
                property_type: "",
                search: ""
            },
            items: [],
            isLoading: false,
            showSplash: true
        };
    },

    computed:
    {
        propertyCount()
        {
            return this.items.length;
        }
    },

    async created()
    {
        const query = this.$route.query;
        this.filters.property_type = query.property_type || "";
        this.filters.search = query.search || "";

        // Simulate initial splashscreen
        await this.fetchProperties();
        setTimeout(() =>
        {
            this.showSplash = false;
        }, 1000);
    },

    methods:
    {
        async fetchProperties()
        {
            this.isLoading = true;

            // Add delay before making API call
            setTimeout(async () =>
            {
                try
                {
                    const token = localStorage.getItem("access_token");
                    const endpoint = token ? "/properties" : "/commercialhub/properties";

                    const response = await apiClient.get(endpoint,
                    {
                        headers: token ? { Authorization: `Bearer ${token}` } : {},
                        params: this.filters
                    });

                    this.items = response.data;
                }
                catch (error)
                {
                    console.error("Error fetching properties:", error);
                }
                finally
                {
                    this.isLoading = false;
                }
            }, 1000); // 3 seconds delay
        }
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