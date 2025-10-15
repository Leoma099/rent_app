<template>

    <tr>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ schedule.available_day }}</span>
        </td>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ formatTime(schedule.start_time) }} - {{ formatTime(schedule.end_time) }}</span>
        </td>
        <td class="table-data">
            <div class="text-end">
                <button
                class="btn btn-sm btn-info rounded-0 me-2">
                <i class="bx bx-edit"></i>
            </button>
            <button
                class="btn btn-sm btn-danger rounded-0">
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
        schedule: Object,
        isLoading: Boolean, // Receive isLoading prop from parent
    },

    methods:
    {
        formatTime(time)
        {
            if (!time) return '';
            const date = new Date(`1970-01-01T${time}`);
            return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true });
        }
    }
}
</script>

<style scoped>
.table-data {
    font-size: 0.10rem;
    font-weight: 400;
    padding: 5px;
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