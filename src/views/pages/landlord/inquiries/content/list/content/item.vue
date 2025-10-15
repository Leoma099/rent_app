<template>

    <tr>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.tenant.account.full_name }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.tenant.account.email }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.tenant.account.mobile_number }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.property.title }}</span>
        </td>
        <!-- <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                {{ item.messages.length ? item.messages[0].message : 'No message' }}
            </span>
        </td> -->
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ formatDate(item.created_at) }}</span>
        </td>
        <td>
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <button
                    type="button"
                    class="btn btn-sm btn-info rounded-0"
                    data-bs-toggle="modal"
                    :data-bs-target="'#messageModal-' + item.id">
                    <i class="bx bx-show"></i>
                </button>

                <message-modal :inquiry="item" />

            </span>
        </td>
    </tr>

</template>

<script>
import MessageModal from "@/views/pages/landlord/inquiries/content/list/components/modals/messages.vue";
export default
{
    props:
    {
        item: Object,
        isLoading: Boolean,
    },

    components:
    {
        MessageModal
    },

    methods:
    {
        formatStatus(status)
        {
            const statuses =
            {
                0: { label: "Pending", badgeClass: "badge fs-6 bg-sm bg-warning" },  // Yellow
                1: { label: "Open", badgeClass: "badge fs-6 bg-sm bg-success" }, // Blue
            };
            return statuses[status] || { label: "n/a", badgeClass: "badge bg-secondary" };
        },

        formatDate(date)
        {
            if (!date) return '-';
            const d = new Date(date);
            const year = d.getFullYear();
            const month = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            return `${year}/${month}/${day}`;
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