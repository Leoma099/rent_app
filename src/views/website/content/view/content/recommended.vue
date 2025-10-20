<template>
    <div v-if="showSplash" class="splashscreen">
        <div class="splash-content">
            <img src="@/assets/images/capas_logo.png" alt="Logo" class="splash-logo" />
            <h2>Loading...</h2>
        </div>
    </div> 
    <div v-else class="recommended mt-5">
        <h2>Recommended Properties</h2>

        <div class="row mt-3">
            <div class="col-md-4 mb-3" v-for="property in properties" :key="property.id">
                <a 
                    href="javascript:void(0)" 
                    style="text-decoration: none;"
                    @click="navigateToProperty(property.id)">
                    <div class="card h-100 shadow-sm">
                        <img
                            :src="getPhotoUrl(property.photo_1)"
                            :alt="property.property_name"
                            style="height: 200px; object-fit: cover"
                            class="card-img-top">
                        <div class="card-body">
                            <h5 class="card-title mb-0">{{ property.title }}</h5>
                            <p class="card-text text-muted mb-0">{{ property.address }}</p>
                            <p class="mb-0">
                                <span class="badge fs-6 text-bg-secondary rounded-0">{{ formatPropStats( property.propertyStats ) }}</span>
                            </p>
                            <p class="mb-0">
                                <strong>{{ property.property_type }}</strong> ( <i class='bx bx-ruler'></i> {{ property.size }} sqm )
                            </p>
                            <span class="fw-bold text-primary">{{ formatPrice(property.price) }} / Monthly</span>
                        </div>
                    </div>
                </a>
            </div>
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
                }, 1500);
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
            return `http://api.rent-app.loc/storage/${photoPath}`;
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
    }
};
</script>

<style scoped>
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