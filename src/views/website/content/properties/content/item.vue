<template>
    <div class="col-md-3">
        <template v-if="isLoading">
            <div class="card h-100 shadow-sm shimmer-card">
                <div class="shimmer-img"></div>
                <div class="card-body">
                    <div class="shimmer-text title"></div>
                    <div class="shimmer-text sub-title"></div>
                    <div class="shimmer-text badge-row"></div>
                    <div class="shimmer-text badge-row"></div>
                    <div class="shimmer-text price"></div>
                </div>
            </div>
        </template>
        <template v-else>
            <div
                @click="navigateToProperty(item)">
                <div class="card h-100 shadow-sm">
                    <img
                        :src="getPhotoUrl(item.photo_1)"
                        :alt="item.property_name"
                        style="height: 200px; object-fit: cover"
                        class="card-img-top">
                    <div class="card-body">
                        <h5 class="card-title mb-0 fw-bold">{{ item.title }}</h5>
                        <p class="text-muted small mb-1">{{ item.address }}</p>

                        <div class="mb-1">
                            <span 
                                class="badge me-2" 
                                :class="getStatusBadgeClass(item.propertyStats)">
                                {{ formatPropStats(item.propertyStats) }}
                            </span>
                        </div>

                        <div class="mb-1">
                            <span class="badge text-bg-info text-dark border me-1"
                                v-for="(type, index) in item.property_type.split(',')"
                                :key="index">{{ type.trim() }}</span>

                            <small class="text-muted"><i class='bx bx-ruler'></i> {{ item.size }} sqm</small>
                        </div>

                        <div class="fw-bold text-primary">{{ formatPrice(item.price) }} / Monthly</div>
                    </div>
                </div>
            </div>
        </template>
    </div>
</template>

<script>
export default
{
    props:
    {
        item: Object,
        isLoading: Boolean
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

            // return `${process.env.VUE_APP_API_URL}/uploads/${photoPath}`;
            return `${process.env.VUE_APP_API_URL}/storage/${photoPath}`;
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

        formatFeature(feature)
        {
            const featured =
            {
                1: 'Featured'
            };
            return featured[feature] || "N/A";
        },

        formatPropStats(status)
        {
            const statuses =
            {
                1: "For Rent",
                2: "Rented",
                3: "Under Review",
                4: "Reserved",
            };
            return statuses[status] || "N/A";
        },

        getStatusBadgeClass(status)
        {
            const classes =
            {
                1: 'text-bg-success',   // For Rent
                2: 'text-bg-danger',    // Rented
                3: 'text-bg-warning',   // Under Review
                4: 'text-bg-primary'    // Reserved
            };
            return classes[status] || 'text-bg-secondary';
        },

        navigateToProperty(item)
        {
            this.scrollToTop();
            this.$router.push({ name: 'CommercialHubView', params: { id: item.id } });
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