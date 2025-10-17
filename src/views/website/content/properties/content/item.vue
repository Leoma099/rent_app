<template>
    <div class="col-md-3">
        <router-link :to="{ name: 'CommercialHubView', params: { id: item.id } }" style="text-decoration: none;">
            <div class="card h-100 shadow-sm border-0 rounded-0">
                <img
                    :src="getPhotoUrl(item.photo)"
                    :alt="item.property_name"
                    style="height: 200px; object-fit: cover">
                <div class="card-body">
                    <small>{{ item.propertyStats }} . {{ item.property_type }}</small>
                    <h5 class="card-title mb-0">{{ item.property_name }}</h5>
                    <p class="card-text text-muted mb-0">{{ item.address }}</p>
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

            return `http://api.rent_api.loc/storage/${photoPath}`;
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
    }
};
</script>
