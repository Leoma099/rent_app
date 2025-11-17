<template>
    <div>
        <div v-if="showSplash" class="splashscreen">
            <div class="splash-content">
                <img src="@/assets/images/capas_logo.png" alt="Logo" class="splash-logo" />
                <h2>Loading...</h2>
            </div>
        </div>

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
                <div>
                    <div class="row g-3 align-items-center">
                        <div class="col-md-2">
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

                        <div class="col-md-2">
                            <select v-model="filters.barangay" class="form-select" @change="fetchProperties">
                                <option value="">All Barangay</option>
                                <option value="ARANGUREN">ARANGUREN</option>
                                <option value="BUENO">BUENO</option>
                                <option value="CRISTO REY">CRISTO REY</option>
                                <option value="CUBCUB">CUBCUB</option>
                                <option value="CUTCUT I">CUTCUT I</option>
                                <option value="CUTCUT II">CUTCUT II</option>
                                <option value="DOLORES">DOLORES</option>
                                <option value="ESTRADA">ESTRADA</option>
                                <option value="LAWY">LAWY</option>
                                <option value="MANGA">MANGA</option>
                                <option value="MANLAPIG">MANLAPIG</option>
                                <option value="MARUGLU">MARUGLU</option>
                                <option value="O’DONNELL">O’DONNELL</option>
                                <option value="STA. JULIANA">STA. JULIANA</option>
                                <option value="STA. LUCIA">STA. LUCIA</option>
                                <option value="STA. RITA">STA. RITA</option>
                                <option value="STO. DOMINGO I">STO. DOMINGO I</option>
                                <option value="STO. DOMINGO II">STO. DOMINGO II</option>
                                <option value="STO. ROSARIO">STO. ROSARIO</option>
                                <option value="TALAGA">TALAGA</option>
                            </select>
                        </div>

                        <div class="col-md-5">
                            <div class="position-relative">
                                <input
                                    v-model="filters.search"
                                    type="text"
                                    class="form-control"
                                    placeholder="Enter location or property name">
                                <span
                                    v-if="filters.search"
                                    class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                                    @click="clearSearch"
                                    style="user-select: none;"
                                >
                                    x
                                </span>
                            </div>
                        </div>

                        <div class="col-md-3 d-grid">
                            <button type="button" class="btn btn-primary w-100" @click="fetchProperties">
                                Search
                            </button>
                        </div>
                    </div>
                </div>

                <div v-if="isLoading" class="row g-4 mt-4">
                    <div class="col-md-3" v-for="n in 12" :key="'shimmer-' + n">
                        <div class="card h-100 shadow-sm shimmer-card border-0">
                            <div class="shimmer-img"></div>
                            <div class="card-body">
                                <div class="shimmer-text title"></div>
                                <div class="shimmer-text sub-title"></div>
                                <div class="shimmer-text badge-row"></div>
                                <div class="shimmer-text badge-row"></div>
                                <div class="shimmer-text price"></div>
                            </div>
                        </div>
                    </div>
                </div>

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

        <div v-if="!isLoading && items.length === 0" class="text-center py-5 fade-in">
            <i class='bx bx-file-find text-secondary' style="font-size: 55px; opacity: .4;"></i>
            <h5 class="mt-2 text-muted">No properties found</h5>
            <p class="text-secondary small">Check back soon for new listings.</p>
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
        return{
            filters:
            {
                property_type: "",
                barangay: "",
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
        this.filters.barangay = query.barangay || "";
        this.filters.search = query.search || "";

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
            }, 1000);
        },

        clearSearch()
        {
            this.filters.search = "";
            this.fetchProperties();
        }
    }
};
</script>

<style scoped>
.fade-in
{
    animation: fadeIn .3s ease-in-out;
}

@keyframes fadeIn
{
    0% { opacity: 0; transform: translateY(8px); }
    100% { opacity: 1; transform: translateY(0); }
}
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

.shimmer-card
{
    animation: shimmer 1.5s infinite linear;
    background: #f6f7f8;
    background: linear-gradient(to right, #f6f7f8 0%, #edeef1 20%, #f6f7f8 40%, #f6f7f8 100%);
    background-size: 200% auto;
}

@keyframes shimmer
{
    0%
    {
        background-position: -200% center;
    }
    100%
    {
        background-position: 200% center;
    }
}

.shimmer-img
{
    height: 200px;
    width: 100%;
    background-color: #e0e0e0;
    margin-bottom: 1rem;
}

.shimmer-text
{
    height: 15px;
    background-color: #e0e0e0;
    margin-bottom: 0.5rem;
    border-radius: 4px;
}

.shimmer-text.title
{
    width: 60%;
    height: 20px;
}

.shimmer-text.sub-title
{
    width: 80%;
}

.shimmer-text.badge-row
{
    width: 50%;
    height: 18px;
}

.shimmer-text.price
{
    width: 40%;
    height: 18px;
}
</style>
