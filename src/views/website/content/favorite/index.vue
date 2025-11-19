<template>
    <div class="container my-5">

        <div class="col-md-8 mx-auto">

            <h1 class="mb-4">Favorites</h1>

            <div class="favorite-card ">

                <div v-if="items.length > 0">
                    <div
                        v-for="n in items"
                        :key="n.id"
                        class="mb-3">
                        
                        <div class="favorite-card-inner">

                            <a
                                href="javascript:void(0)"
                                @click="navigateToProperty(n.property.id)"
                                class="d-flex text-decoration-none">

                                <!-- property image -->
                                <div class="property-image me-3 mb-2 mb-md-0">
                                    <img
                                        :src="getPhotoUrl(n.property?.photo_1)"
                                        :alt="n.property?.title || 'Property'"
                                        class="img-fluid rounded"
                                    />
                                </div>

                                <!-- property info -->
                                <div class="flex-grow-1">
                                    <p class="mb-0 text-black"><strong>{{ n.property?.title }}</strong></p>
                                    <div><small class="mb-0 text-muted">{{ n.property?.address }}</small></div>
                                    <div><small class="mb-0 text-muted">PHP {{ n.property?.price }} /month</small></div>
                                </div>

                            </a>

                        </div>
                    </div>
                </div>

                <p v-else class="mb-0 text-center empty my-5">You have no favorites yet.</p>

            </div>

        </div>

    </div>
</template>

<script>
import apiClient from '@/services';
import { useToast } from "vue-toastification";

export default
{
    data()
    {
        return {
            items: [],
            favoritesInterval: null,
            toast: null
        };
    },

    created()
    {
        this.toast = useToast();
        this.loadFavorites();
    },

    beforeUnmount()
    {
        if (this.favoritesInterval)
        {
            clearInterval(this.favoritesInterval);
            this.favoritesInterval = null;
        }
    },

    methods:
    {
        async loadFavorites()
        {
            try
            {
                const response = await apiClient.get('/saved-properties');
                this.items = response.data;
            }
            catch (error)
            {
                console.error('Error loading favorites:', error);
                if (this.toast) 
                {
                    this.toast.error("Failed to load favorites.");
                }
            }
        },

        async unsaveProperty(propertyId)
        {
            try
            {
                await apiClient.delete(`/saved-properties/${propertyId}`);

                // Remove from local array
                this.items = this.items.filter(item =>
                {
                    return item.property_id !== propertyId;
                });

                if (this.toast)
                {
                    this.toast.success("Property removed from favorites!");
                }
            }
            catch (error)
            {
                console.error("Error removing favorite:", error);
                if (this.toast)
                {
                    this.toast.error("Failed to remove favorite.");
                }
            }
        },

        getPhotoUrl(photoPath)
        {
            if (!photoPath) 
            {
                return '/default-avatar.png';
            }

            if (photoPath.startsWith('http')) 
            {
                return photoPath;
            }

            return `${process.env.VUE_APP_API_URL}/uploads/${photoPath}`;
        },

        // NEW METHOD: Navigate to property with scroll to top
        navigateToProperty(id)
        {
            this.scrollToTop();
            this.$router.push({ name: 'CommercialHubView', params: { id: id } });
        },

        // NEW METHOD: Scroll to top
        scrollToTop()
        {
            window.scrollTo({
                top: 0,
                left: 0,
                behavior: 'instant'
            });
        },
    }
};
</script>

<style scoped>
.empty
{
    color: #666;
    font-size: 1rem;
}

.favorite-card
{
    min-height: 800px;
    overflow-y: auto;
    background-color: #ffffff;
    border-radius: 15px;
    padding: 20px;
    display: flex;
    flex-direction: column;
}

.favorite-card-inner
{
    border-radius: 5px;
    transition: all 0.2s ease-in;
    padding: 10px;
}

.favorite-card-inner:hover
{
    background: #f0f0f0;
}

.property-image img
{
    width: 120px;
    height: 80px;
    object-fit: cover;
    border-radius: 8px;
}

.actions button
{
    min-width: 80px;
}
</style>
