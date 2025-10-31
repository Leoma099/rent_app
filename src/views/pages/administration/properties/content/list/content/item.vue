<template>

    <tr>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.title }}</span>
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
            <span v-else>{{ item.price }}</span>
        </td>
       <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <button
                    type="button"
                    :class="formatStatus(item.status).badgeClass"
                    @click="openUpdateStatusModal"
                    data-bs-toggle="modal"
                    data-bs-target="#updateStatusModal">
                    <small>{{ formatStatus(item.status).label }}</small>
                </button>
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <router-link
                    :to="`/administration/properties/${item.id}`"
                    class="btn btn-sm btn-warning rounded-0 me-3"
                    :class="{ 'disabled-link': item.status === 0 }"
                    :tabindex="item.status === 0 ? -1 : 0"
                    :aria-disabled="item.status === 0">
                    <i class="bx bx-show"></i>
                </router-link>
                <button
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
        isLoading: Boolean, // Receive isLoading prop from parent
    },

    methods:
    {
        formatStatus(status)
        {
            const statuses =
            {
                0: { label: "Inactive", badgeClass: "btn btn-sm btn-warning rounded-0" },
                1: { label: "Active", badgeClass: "btn btn-sm btn-success rounded-0" },
            };
            return statuses[status] || { label: "n/a", badgeClass: "btn btn-sm btn-secondary rounded-0" };
        },

        openUpdateStatusModal()
        {
            this.$emit("open-status-modal", this.item); // send to parent
        }
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