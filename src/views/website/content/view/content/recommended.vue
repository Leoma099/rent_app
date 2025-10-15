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
                <router-link :to="{ name: 'CommercialHubView', params: { id: property.id } }" style="text-decoration: none;">
                    <div class="card h-100 shadow-sm border-0 rounded-0">
                        <img
                            :src="getPhotoUrl(property.photo)"
                            :alt="property.title"
                            style="height: 200px; object-fit: cover">
                        <div class="card-body">
                            <small>{{ property.property_type }}</small>
                            <h5 class="card-title mb-0">{{ property.title }}</h5>
                            <p class="card-text text-muted mb-0">{{ property.address }}</p>
                            <span class="fw-bold text-primary">{{ formatPrice(property.price) }} / Monthly</span>
                        </div>
                    </div>
                </router-link>
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
        }
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