<template>
    <div class="container my-5">

        <div class="col-md-8 mx-auto">

            <h1 class="mb-3">Favorites</h1>

            <div v-if="items.length > 0">
                <div
                    v-for="n in items"
                    :key="n.id"
                    class="card card-body card-white shadow-sm mb-3"
                >
                    <div class="d-flex">
                        <!-- property image -->
                        <div style="width: 120px; flex-shrink: 0; margin-right: 12px;">
                            <img
                                :src="getPhotoUrl(n.property?.photo)"
                                :alt="n.property?.title || 'Property'"
                                class="img-fluid rounded"
                                style="height: 80px; width: 120px; object-fit: cover;"
                            />
                        </div>

                        <!-- property info -->
                        <div style="flex: 1;">
                            <h5 class="mb-1">{{ n.property?.title }}</h5>
                            <p class="mb-1 text-muted">{{ n.property?.address }}</p>
                            <p class="mb-0"><strong>PHP {{ n.property?.price }}</strong> /month</p>
                        </div>

                        <!-- actions -->
                        <div style="width: 150px; text-align: right;">
                            <small class="text-muted">{{ new Date(n.created_at).toLocaleString() }}</small>
                            <div class="mt-2">
                                <button
                                    type="button"
                                    class="btn btn-sm btn-outline-danger"
                                    @click="unsaveProperty(n.property_id)"
                                >
                                    <i class="bx bx-trash me-1"></i>
                                    Remove
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <p v-else class="mb-0 text-center empty">You have no favorites yet.</p>

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

            return `http://api.rent-app.loc/storage/${photoPath}`;
        }
    }
};
</script>

<style scoped>
.empty
{
    color: #666;
}
</style>
