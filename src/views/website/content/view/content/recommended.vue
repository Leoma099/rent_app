<template>
    <div v-if="showSplash" class="splashscreen">
        <div class="splash-content">
            <img src="@/assets/images/capas_logo.png" alt="Logo" class="splash-logo" />
            <h2>Loading...</h2>
        </div>
    </div> 
    <div v-else class="recommended mt-5">
        <h2>Recommended Properties</h2>

        <div v-if="properties.length > 0" class="row mt-3">
            <div class="col-md-4 mb-3" v-for="property in properties" :key="property.id">
                <a href="javascript:void(0)" @click="navigateToProperty(property.id)" style="text-decoration: none;">
                    <div class="card h-100 shadow-sm">
                        <img :src="getPhotoUrl(property.photo_1)" :alt="property.property_name"
                            style="height: 200px; object-fit: cover" class="card-img-top" />
                        <div class="card-body">
                            <h5 class="card-title mb-0">{{ property.title }}</h5>
                            <p class="card-text text-muted mb-0">{{ property.address }}</p>
                            <p class="mb-1">
                                <span v-if="property.is_featured !== 0" class="badge text-bg-success rounded-pill me-2">
                                    {{ formatFeature(property.is_featured) }}
                                </span>
                                <span class="badge text-bg-secondary rounded-pill">{{ formatPropStats(property.propertyStats) }}</span>
                            </p>
                            <p class="mb-0">
                                <span v-for="(type, index) in property.property_type.split(',')" :key="index"
                                    class="badge text-bg-info rounded-pill me-1">
                                    {{ type.trim() }}
                                </span>
                                ( <i class='bx bx-ruler'></i> {{ property.size }} sqm )
                            </p>
                            <span class="fw-bold text-primary">{{ formatPrice(property.price) }} / Monthly</span>
                        </div>
                    </div>
                </a>
            </div>
        </div>

        <div v-else class="text-center my-5">
            <i class='bx bx-file-find text-secondary' style="font-size:55px;opacity:.4;"></i>
            <h5 class="mt-2 text-muted">No recommended properties available</h5>
            <p class="text-secondary small">Check back soon for updates.</p>
        </div>
    </div>

</template>

<script>
import apiClient from "@/services";

export default
{
    name: "RecommendedComponent",

    props:
    {
        propertyId:
        {
            type: [Number, String],
            required: true
        }
    },

    data()
    {
        return {
            properties: [],
            showSplash: true // added splashscreen state
        };
    },

    created()
    {
        this.loadRecommended();
    },

    watch:
    {
        propertyId:
        {
            immediate: true,
            handler(newId)
            {
                this.loadRecommended(newId);
            }
        }
    },

    methods:
    {
        async loadRecommended(id = this.propertyId)
        {
            try
            {
                const response = await apiClient.get(`/properties/${id}/recommended`);
                this.properties = response.data;
                setTimeout(() =>
                {
                    this.showSplash = false;
                }, 1000);
            }
            catch(error)
            {
                console.error("Failed to load recommended properties:", error);
            }
        },

        getPhotoUrl(photoPath)
        {
            if (!photoPath) return "/default-avatar.png";
            if (photoPath.startsWith("http")) return photoPath;
            return `https://floralwhite-butterfly-259901.hostingersite.com/uploads/${photoPath}`;
        },

        formatPrice(price)
        {
            if(!price) return "₱0.00";

            return new Intl.NumberFormat('en-PH', {
                style: 'currency',
                currency: 'PHP',
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(price);
        },

        // NEW METHOD: Navigate to property with scroll to top
        navigateToProperty(id) {
            this.scrollToTop();
            this.$router.push({ name: 'CommercialHubView', params: { id: id } });
        },

        // NEW METHOD: Scroll to top
        scrollToTop() {
            window.scrollTo({
                top: 0,
                left: 0,
                behavior: 'instant'
            });
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

        formatFeature(feature)
        {
            const featured =
            {
                1: 'Featured',
            };
            return featured[feature] || "N/A";
        },
    }
};
</script>

<style scoped>
.badge {
    background-color: #e9ecef;
    color: #333;
    border-radius: 0.25rem;
    font-weight: 500;
    padding: 0.4em 0.6em;
}
.card-title
{
    font-size: 1.1rem;
    font-weight: bold;
}
.card-text
{
    font-size: 0.9rem;
    color: #555;
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
    animation: fadeIn 0.4s ease-in;
}

.splash-content
{
    text-align: center;
    animation: fadeInUp 1s ease;
}

.splash-logo
{
    width: 120px;
    height: auto;
    margin-bottom: 15px;
}
</style>