<template>
    <tr>
        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.id }}</span>
        </td>

        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.full_name }}</span>
        </td>

        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.email }}</span>
        </td>

        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ item.mobile_number }}</span>
        </td>

        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>
                <button
                    type="button"
                    :class="formatStatus(item.user.status).badgeClass"
                    @click="openUpdateStatusModal"
                    data-bs-toggle="modal"
                    data-bs-target="#updateStatusModal">
                    <small>{{ formatStatus(item.user.status).label }}</small>
                </button>
            </span>
        </td>

        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ formatRoles( item.user.role ) }}</span>
        </td>

        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <span v-else>{{ formatDateTime(item.created_at) }}</span>
        </td>

        <td class="table-data">
            <div v-if="isLoading" class="shimmer-loader"></div>
            <div v-else>
                <router-link
                    :to="`/administration/accounts/${item.id}/edit`"
                    class="btn btn-sm btn-info rounded-0 me-3">
                    <i class="bx bx-edit"></i>
                </router-link>

                <button
                    type="button"
                    class="btn btn-sm btn-danger rounded-0"
                    data-bs-toggle="modal"
                    data-bs-target="#deleteModal"
                    @click="openUpdateStatusModal">
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
        isLoading: Boolean
    },

    methods:
    {
        formatRoles(role)
        {
            const roles =
            {
                1: "Admin",
                2: "Landlord",
                3: "Tenant"
            };

            return roles[role] || "n/a";
        },

        formatStatus(status)
        {
            const statuses =
            {
                0: { label: "Inactive", badgeClass: "btn btn-sm btn-warning rounded-0" },
                1: { label: "Active", badgeClass: "btn btn-sm btn-success rounded-0" }
            };

            return statuses[status] || { label: "n/a", badgeClass: "btn btn-sm btn-secondary rounded-0" };
        },

        formatDateTime(dateString)
        {
            const date = new Date(dateString);

            const datePart = date.toLocaleDateString('en-CA');
            const timePart = date.toLocaleTimeString('en-US',
            {
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });

            return `${datePart} | ${timePart}`;
        },

        openUpdateStatusModal()
        {
            this.$emit("open-status-modal", this.item);
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
