<template>
    <tr>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else style="font-size: 18px;">{{ item.tenant.account.full_name }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else style="font-size: 18px;">{{ item.property?.title || 'Deleted Property' }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else style="font-size: 18px;">{{ item.property?.property_type || '-' }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                {{ item.schedule?.available_day || '-' }}, 
                {{ formatTime(item.schedule?.start_time) }}-{{ formatTime(item.schedule?.end_time) }}
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <button
                    type="button"
                    :class="formatStatus(item.status).badgeClass"
                    data-bs-toggle="modal"
                    data-bs-target="#updateStatusModal"
                    @click="openModal">
                    <small>{{ formatStatus(item.status).label }}</small>
                </button>
            </span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <div v-else>
                <button
                    type="button"
                    class="btn btn-sm btn-danger rounded-0"
                    data-bs-toggle="modal"
                    data-bs-target="#deleteModal"
                    @click="openModal">
                    <i class="bx bx-trash"></i>
                </button>
            </div>
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
                0: { label: "PENDING",   badgeClass: "btn btn-sm btn-warning rounded-0" },
                1: { label: "CONFIRMED",  badgeClass: "btn btn-sm btn-success rounded-0" },
            };

            return statuses[status] || { label: "N/A", badgeClass: "badge rounded-0 bg-secondary small" };
        },

        formatTime(time)
        {
            if (!time) return "";
            const date = new Date(`1970-01-01T${time}Z`);
            return date.toLocaleTimeString([], {
                hour: "2-digit",
                minute: "2-digit",
                hour12: true
            });
        },

        openModal()
        {
            this.$emit("open-modal", this.item); // correct event name
        }


    }
};
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

span {
    font-size: 1rem;
    font-weight: 600;
}
</style>
