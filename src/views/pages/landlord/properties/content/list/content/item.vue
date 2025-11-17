<template>

    <tr>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <small>
                    {{ item.title }}
                </small>
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <small>
                    {{ item.address }}
                </small>
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <small>
                    {{ formatPropStats(item.propertyStats).label }}
                </small>
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <small>
                    {{ item.property_type }}
                </small>
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <small>
                    {{ formatPrice(item.price) }}
                </small>
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <small>
                    <small class="text-muted">{{ formatViewActivity(item.last_viewed_at) }}</small>
                </small>
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <button
                    :disabled="item.status === 0"
                    type="button"
                    :class="formatStatus(item.status).badgeClass"
                    @click="openUpdateStatusModal"
                    data-bs-toggle="modal"
                    data-bs-target="#updateStatusModal">
                    <small>{{ formatStatus(item.status).label }}</small>
                </button>
            </span>
        </td>
        <!-- <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <button
                    :disabled="item.status === 0"
                    type="button"
                    :class="formatFeature(item.is_featured).badgeClass"
                    @click="openUpdateStatusModal"
                    data-bs-toggle="modal"
                    data-bs-target="#featuredModal">
                    <small>{{ formatFeature(item.is_featured).label }}</small>
                </button>
            </span>
        </td> -->
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else class="d-flex align-items-center">
                <router-link
                    :to="item.status === 0 ? '' : `/landlord/properties/${item.id}/edit`"
                    class="btn btn-sm btn-info rounded-0 me-3"
                    :class="{ 'disabled-link': item.status === 0 }"
                    :tabindex="item.status === 0 ? -1 : 0"
                    :aria-disabled="item.status === 0">
                    <i class="bx bx-edit"></i>
                </router-link>
                <button
                    :disabled="item.status === 0"
                    type="button"
                    class="btn btn-sm btn-danger rounded-0"
                    data-bs-toggle="modal"
                    data-bs-target="#deleteModal"
                    @click="openUpdateStatusModal()">
                    <i class="bx bx-trash"></i>
                </button>
            </span>
        </td>
    </tr>

</template>

<script>
export default
{
    props:
    {
        item: Object,
        isLoading: Boolean,
    },

    methods:
    {
        formatStatus(status)
        {
            const statuses =
            {
                0: { label: "Pending", badgeClass: "btn btn-sm btn-secondary rounded-0" },
                1: { label: "Inactive", badgeClass: "btn btn-sm btn-warning rounded-0" },
                2: { label: "Active", badgeClass: "btn btn-sm btn-success rounded-0" },
            };
            return statuses[status] || { label: "n/a", badgeClass: "btn btn-sm btn-secondary rounded-0" };
        },

        formatPropStats(status)
        {
            const statuses =
            {
                0: { label: "Under Review" },
                1: { label: "For Rent" },
                2: { label: "Rented" },
                3: { label: "Under Maintenance" },
                4: { label: "Reserved" },
            };
            return statuses[status] || { label: "n/a" };
        },

        formatFeature(feature)
        {
            const featured =
            {
                0: { label: "Not featured", badgeClass: "btn btn-sm btn-warning rounded-0" },
                1: { label: "Featured", badgeClass: "btn btn-sm btn-success rounded-0" },
            };
            return featured[feature] || { label: "n/a", badgeClass: "btn btn-sm btn-secondary rounded-0" };
        },

        formatPrice(price)
        {
            if (!price) return "₱0.00";

            return new Intl.NumberFormat('en-PH', {
                style: 'currency',
                currency: 'PHP',
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(price);
        },

        formatViewActivity(lastViewed)
        {
            if (!lastViewed)
            {
                return "Never Viewed";
            }

            const last = new Date(lastViewed);
            const now = new Date();

            const diffMs = now - last;
            const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

            // viewed today
            const isToday = last.toDateString() === now.toDateString();
            if (isToday) return "Viewed today";

            // viewed within 48 hours
            if (diffDays < 2) return "Viewed recently";

            // viewed X days ago
            return `Last viewed: ${diffDays} day${diffDays > 1 ? "s" : ""} ago`;
        },

        openUpdateStatusModal()
        {
            this.$emit("open-status-modal", this.item);
        }
    }
}
</script>

<style scoped>
.table-data
{
    font-size: 0.80rem;
    font-weight: 400;
    padding: 10px;
    position: relative;
    text-transform: uppercase;
}

.shimmer-loader
{
    height: 16px;
    width: 100%;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite linear;
    border-radius: 4px;
}

@keyframes shimmer
{
    0%
    {
        background-position: -200% 0;
    }

    100%
    {
        background-position: 200% 0;
    }
}

.button-manage
{
    background-color: #007bff;
    font-size: 0.80rem;
    font-weight: 500;
    padding: 10px;
    color: #ffffff;
}

.equipment-image
{
    width: 40px;
    height: 40px;
    overflow: hidden;
    background: #e0e0e0;
}

.equipment-image img
{
    width: 100%;
    height: 100%;
    object-fit: cover;
}

span
{
    font-size: 1rem;
    font-weight: 600;
}

/* disable style for router-link */
.disabled-link
{
    pointer-events: none;
    opacity: 0.6;
}
</style>
