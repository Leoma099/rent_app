<template>
    <div class="container my-5">
        <div class="mt-5">
            <div>
                <h2 class="mb-0"><strong>FEATURED PROPERTIES</strong></h2>
                <p class="mb-0">Top Locations Curated for Your Success.</p>
            </div>
            <div class="row g-4 mt-2">
                <template v-if="isLoadingFeatured">
                    <div class="col-md-4" v-for="n in 3" :key="'shimmer-featured-' + n">
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
                </template>
                <template v-else>
                    <div class="col-md-4" v-for="item in featured" :key="item.id">
                        <a href="javascript:void(0)" style="text-decoration: none;" @click="navigateToProperty(item.id)">
                            <div class="card h-100 shadow-sm">
                                <img
                                    :src="getPhotoUrl(item.photo_1)"
                                    :alt="item.property_name"
                                    style="height: 200px; object-fit: cover"
                                    class="card-img-top">
                                <div class="card-body">
                                    <h5 class="card-title mb-0">{{ item.title }}</h5>
                                    <p class="card-text text-muted mb-0">{{ item.address }}</p>
                                    <p class="mb-1">
                                        <span v-if="item.is_featured !== 0" class="badge rounded-pill text-bg-success me-2">
                                            {{ formatFeature(item.is_featured) }}
                                        </span>
                                        <span class="badge text-bg-secondary rounded-pill">{{ formatPropStats(item.propertyStats) }}</span>
                                    </p>
                                    <p class="mb-0">
                                        <span
                                            v-for="(type, index) in item.property_type.split(',')"
                                            :key="index"
                                            class="badge text-bg-info rounded-pill me-1">
                                            {{ type.trim() }}
                                        </span>
                                        ( <i class='bx bx-ruler'></i> {{ item.size }} sqm )
                                    </p>
                                    <span class="fw-bold text-primary">{{ formatPrice(item.price) }} / Monthly</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </template>
            </div>
        </div>

        <div class="mt-5">
            <div>
                <h2 class="mb-0"><strong>RECENT PROPERTIES</strong></h2>
                <p class="mb-0">Explore the Latest Offices and Stores for Lease.</p>
            </div>
            <div class="row g-4 mt-2">
                <template v-if="isLoadingRecent">
                    <div class="col-md-4" v-for="n in 3" :key="'shimmer-recent-' + n">
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
                </template>
                <template v-else>
                    <div class="col-md-4" v-for="item in recents" :key="item.id">
                        <a href="javascript:void(0)" style="text-decoration: none;" @click="navigateToProperty(item.id)">
                            <div class="card h-100 shadow-sm">
                                <img
                                    :src="getPhotoUrl(item.photo_1)"
                                    :alt="item.property_name"
                                    style="height: 200px; object-fit: cover"
                                    class="card-img-top">
                                <div class="card-body">
                                    <h5 class="card-title mb-0">{{ item.title }}</h5>
                                    <p class="card-text text-muted mb-0">{{ item.address }}</p>
                                    <p class="mb-1">
                                        <span v-if="item.is_featured !== 0" class="badge text-bg-success rounded-pill me-2">
                                            {{ formatFeature(item.is_featured) }}
                                        </span>
                                        <span class="badge text-bg-secondary rounded-pill">{{ formatPropStats(item.propertyStats) }}</span>
                                    </p>
                                    <p class="mb-0">
                                        <span
                                            v-for="(type, index) in item.property_type.split(',')"
                                            :key="index"
                                            class="badge text-bg-info rounded-pill me-1">
                                            {{ type.trim() }}
                                        </span>
                                        ( <i class='bx bx-ruler'></i> {{ item.size }} sqm )
                                    </p>
                                    <span class="fw-bold text-primary">{{ formatPrice(item.price) }} / Monthly</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </template>
            </div>
            <div class="mt-3">
                <div class="text-center">
                    <a href="javascript:void(0)" class="btn btn-secondary rounded-0" @click="navigateToAllProperties">
                        View all properties
                    </a>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import apiClient from '@/services';

export default
{
    data()
    {
        return{
            featured: [],
            recents: [],
            isLoadingFeatured: true,
            isLoadingRecent: true
        };
    },

    mounted()
    {
        this.fetchFeatured();
        this.fetchRecent();
    },

    methods:
    {
        getPhotoUrl(photoPath)
        {
            if (!photoPath)
            {
                return "/default-avatar.png";
            }
            if (photoPath.startsWith("http"))
            {
                return photoPath;
            }
            return `http://api.rent-app.loc/storage/${photoPath}`;
        },

        async fetchFeatured()
        {
            try
            {
                this.isLoadingFeatured = true;
                const response = await apiClient.get('/featured-properties');
                this.featured = response.data;
            }
            catch (error)
            {
                console.error("Failed to load featured properties:", error);
            }
            finally
            {
                setTimeout(() =>
                {
                    this.isLoadingFeatured = false;
                }, 1000);
            }
        },

        async fetchRecent()
        {
            try
            {
                this.isLoadingRecent = true;
                const response = await apiClient.get('/recent-properties');
                this.recents = Array.isArray(response.data) ? response.data : response.data.data;
            }
            catch (error)
            {
                console.error("Failed to load recent properties:", error);
            }
            finally
            {
                setTimeout(() =>
                {
                    this.isLoadingRecent = false;
                }, 1000);
            }
        },

        formatPrice(price)
        {
            if (!price) return "₱0.00";
            return new Intl.NumberFormat('en-PH',
            {
                style: 'currency',
                currency: 'PHP',
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(price);
        },

        formatPropStats(status)
        {
            const statuses =
            {
                0: "Under Review",
                1: "For Rent",
                2: "Rented",
                3: "Under Maintenance",
                4: "Reserved"
            };
            return statuses[status] || "N/A";
        },

        formatFeature(feature)
        {
            const featured =
            {
                1: 'Featured'
            };
            return featured[feature] || "N/A";
        },

        navigateToProperty(id)
        {
            this.scrollToTop();
            this.$router.push({ name: 'CommercialHubView', params: { id: id } });
        },

        navigateToAllProperties()
        {
            this.scrollToTop();
            this.$router.push('/commercialhub/properties');
        },

        scrollToTop()
        {
            window.scrollTo(
            {
                top: 0,
                left: 0,
                behavior: 'instant'
            });
        }
    }
};
</script>

<style scoped>
.badge
{
    background-color: #e9ecef;
    color: #333;
    border-radius: 0.25rem;
    font-weight: 500;
    padding: 0.4em 0.6em;
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
