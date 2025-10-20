<template>
    <div class="col-md-3">
        <router-link :to="{ name: 'CommercialHubView', params: { id: item.id } }" style="text-decoration: none;">
            <div class="card h-100 shadow-sm">
                <img
                    :src="getPhotoUrl(item.photo_1)"
                    :alt="item.property_name"
                    style="height: 200px; object-fit: cover"
                    class="card-img-top">
                <div class="card-body">
                    <h5 class="card-title mb-0">{{ item.title }}</h5>
                    <p class="card-text text-muted mb-0">{{ item.address }}</p>
                    <p class="mb-0">
                        <span v-if="item.is_featured !== 0" class="badge fs-6 text-bg-success rounded-0 me-2">{{ formatFeature( item.is_featured ) }}</span>
                        <span class="badge fs-6 text-bg-secondary rounded-0">{{ formatPropStats( item.propertyStats ) }}</span>
                    </p>
                    <p class="mb-0">
                        <strong>{{ item.property_type }}</strong> ( <i class='bx bx-ruler'></i> {{ item.size }} sqm )
                    </p>
                    <span class="fw-bold text-primary">{{ formatPrice(item.price) }} / Monthly</span>
                </div>
            </div>
        </router-link>
    </div>
</template>

<script>
export default {
    props: {
        item: Object
    },
    methods:
    {
        getPhotoUrl(photoPath)
        {
            if (!photoPath)
            {
                return "/default-avatar.png"; // Fallback image
            }

            if (photoPath.startsWith("http"))
            {
                return photoPath;
            }

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

        formatFeature(feature)
        {
            const featured =
            {
                1: 'Featured',
            };
            return featured[feature] || "N/A";
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
