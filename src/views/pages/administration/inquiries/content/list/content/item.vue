<template>

    <tr>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.id }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.property_name }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.landlord.account.full_name }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.address }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.property_cost }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.units }} {{ item.floor }} {{ item.size }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span :class="formatStatus(item.status).badgeClass" v-else>
                {{ formatStatus(item.status).label }}
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <router-link
                    :to="`/administration/properties/${this.item.id}/edit`"
                    class="btn btn-sm btn-outline-info">
                    <i class="bx bx-edit"></i>
                </router-link>
                <!-- <button
                    class="btn btn-sm btn-danger rounded-0">
                    Delete
                </button> -->
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
        isLoading: Boolean, // Receive isLoading prop from parent
    },

    methods:
    {
        formatStatus(status)
        {
            const statuses =
            {
                0: { label: "Pending", badgeClass: "badge px-2 px-2 fs-6 bg-warning" },  // Yellow
                1: { label: "Active", badgeClass: "badge px-2 px-2 fs-6 bg-success" }, // Blue
                2: { label: "Occupied", badgeClass: "badge px-2 px-2 fs-6 bg-danger" }, // Green
                3: { label: "Inactive", badgeClass: "badge px-2 px-2 fs-6 bg-info" }, // Red
            };
            return statuses[status] || { label: "n/a", badgeClass: "badge bg-secondary" };
        },
    }
}
</script>

<style scoped>
.table-data {
    font-size: 0.80rem;
    font-weight: 400;
    padding: 10px;
    position: relative;
    text-transform: uppercase;
}

/* Shimmer Loader */
.shimmer-loader {
    height: 16px;
    width: 100%;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite linear;
    border-radius: 4px;
}

@keyframes shimmer {
    0% {
        background-position: -200% 0;
    }

    100% {
        background-position: 200% 0;
    }
}

.button-manage {
    background-color: #007bff;
    font-size: 0.80rem;
    font-weight: 500;
    padding: 10px;
    color: #ffffff;
}

.equipment-image {
    width: 40px;
    height: 40px;
    overflow: hidden;
    background: #e0e0e0;
}

.equipment-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

span
{
    font-size: 1rem;
    font-weight: 600;
}
</style>