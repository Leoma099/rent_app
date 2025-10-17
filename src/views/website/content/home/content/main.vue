<template>
    <div class="container my-5">

        <div class="mt-5">

            <div class="text-center">
                <h2 class="mb-0"><strong>FEATURED PROPERTIES</strong></h2>
                <p class="mb-0">Top Locations Curated for Your Success.</p>
            </div>

            <div class="row g-4 mt-2" v-if="featured.length > 0">
                <div class="col-md-4" v-for="(item, index) in featured" :key="index">
                    <a 
                        href="javascript:void(0)" 
                        style="text-decoration: none;"
                        @click="navigateToProperty(item.id)">
                        
                        <div class="card h-100 shadow-sm">
                            <img
                                :src="getPhotoUrl(item.photo)"
                                :alt="item.property_name"
                                style="height: 200px; object-fit: cover"
                                class="card-img-top">
                            <div class="card-body">
                                <small class="text-secondary">{{ formatPropStats( item.propertyStats ) }} . {{ item.property_type }}</small>
                                <h5 class="card-title mb-0">{{ item.title }}</h5>
                                <p class="card-text text-muted mb-0">{{ item.address }}</p>
                                <span class="fw-bold text-primary">{{ formatPrice(item.price) }} / Monthly</span>
                            </div>
                        </div>

                    </a>
                </div>
            </div>
        </div>

        <div class="mt-5">

            <div class="text-center">
                <h2 class="mb-0"><strong>RECENT PROPERTIES</strong></h2>
                <p class="mb-0">Explore the Latest Offices and Stores for Lease.</p>
            </div>

            <div class="row g-4 mt-2" v-if="recents.length > 0">
                <div class="col-md-4" v-for="(item, index) in recents" :key="index">
                    <a 
                        href="javascript:void(0)" 
                        style="text-decoration: none;"
                        @click="navigateToProperty(item.id)">
                        
                        <div class="card h-100 shadow-sm">
                            <img
                                :src="getPhotoUrl(item.photo)"
                                :alt="item.property_name"
                                style="height: 200px; object-fit: cover"
                                class="card-img-top">
                            <div class="card-body">
                                <small class="text-secondary">{{ formatPropStats( item.propertyStats ) }} . {{ item.property_type }}</small>
                                <h5 class="card-title mb-0">{{ item.title }}</h5>
                                <p class="card-text text-muted mb-0">{{ item.address }}</p>
                                <span class="fw-bold text-primary">{{ formatPrice(item.price) }} / Monthly</span>
                            </div>
                        </div>

                    </a>
                </div>
            </div>

            <div class="mt-3">
                <div class="text-center">
                    <a
                        href="javascript:void(0)"
                        class="btn btn-secondary rounded-0"
                        @click="navigateToAllProperties">
                        View all properties
                    </a>
                </div>
            </div>
        </div>

    </div>
</template>

<script>
import apiClient from '@/services';

export default {
    data() {
        return {
            featured: [],
            recents: [],
            isLoadingFeatured: true,
            isLoadingRecent: true,
        };
    },

    mounted() {
        this.fetchFeatured();
        this.fetchRecent();
    },

    methods: {
        getPhotoUrl(photoPath) {
            if (!photoPath) {
                return "/default-avatar.png";
            }
            if (photoPath.startsWith("http")) {
                return photoPath;
            }
            return `http://api.rent-app.loc/storage/${photoPath}`;
        },

        async fetchFeatured() {
            try {
                this.isLoadingFeatured = true;
                const response = await apiClient.get('/featured-properties');
                this.featured = response.data;
            } catch (error) {
                console.error("Failed to load featured properties:", error);
            } finally {
                this.isLoadingFeatured = false;
            }
        },

        async fetchRecent() {
            try {
                this.isLoadingRecent = true;
                const response = await apiClient.get('/recent-properties');
                // check if data is nested
                this.recents = Array.isArray(response.data) ? response.data : response.data.data;
            } catch (error) {
                console.error("Failed to load recent properties:", error);
            } finally {
                this.isLoadingRecent = false;
            }
        },

        formatPrice(price) {
            if (!price) return "₱0.00";
            return new Intl.NumberFormat('en-PH', {
                style: 'currency',
                currency: 'PHP',
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(price);
        },

        formatPropStats(status)
        {
            const statuses = {
                0: "Under Review",
                1: "For Rent",
                2: "Rented",
                3: "Under Maintenance",
                4: "Reserved",
            };
            return statuses[status] || "N/A";
        },

        // NEW METHOD: Navigate to property with scroll to top
        navigateToProperty(id) {
            this.scrollToTop();
            this.$router.push({ name: 'CommercialHubView', params: { id: id } });
        },

        // NEW METHOD: Navigate to all properties with scroll to top
        navigateToAllProperties() {
            this.scrollToTop();
            this.$router.push('/commercialhub/properties');
        },

        // Scroll to top method
        scrollToTop() {
            window.scrollTo({
                top: 0,
                left: 0,
                behavior: 'instant'
            });
        }

    }
}
</script>

<style>

</style>