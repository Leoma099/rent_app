<template>
    <div class="row mb-3">
        <div
            v-for="(card, index) in cards"
            :key="index"
            class="col-md-2"
            :class="{ 'col-md-4': index === 0 }"
        >
            <div class="card card-body shadow-sm rounded-0">
                <div class="d-flex justify-content-between align-items-center text-primary">
                    <div>
                        <span class="total-number mb-0">
                            <div v-if="card.loading" class="shimmer-loader"></div>
                            <span v-else>{{ card.value }}</span>
                        </span>
                        <p class="indicator-title mb-0">{{ card.label }}</p>
                    </div>
                    <i :class="[card.icon, 'dashboard-icon']"></i>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import apiClient from "@/services/index";

export default {
    data() {
        return {
            cards: [
                { label: "TOTAL PROPERTY", value: 0, icon: "bx bx-laptop", loading: true, endpoint: "/totalProperties", key: "total_properties" },
                { label: "TOTAL LEASE", value: 0, icon: "bx bx-user", loading: true, endpoint: "/leaseCount", key: "total_leases" },
                { label: "TOTAL PENDING", value: 0, icon: "bx bx-hourglass-top", loading: true, endpoint: "/pendingCount", key: "total_pending" },
                { label: "TOTAL BOOKED", value: 0, icon: "bx bx-book", loading: true, endpoint: "/bookedCount", key: "total_booked" },
                { label: "TOTAL INQUIRED", value: 0, icon: "bx bx-message-detail", loading: true, endpoint: "/inquireCount", key: "total_inquire" },
            ],
        };
    },

    methods: {
        async loadData() {
            try {
                for (const card of this.cards) {
                    const response = await apiClient.get(card.endpoint);
                    setTimeout(() => {
                        card.value = response.data[card.key] || 0;
                        card.loading = false;
                    }, 1000);
                }
            } catch (error) {
                console.error("Error loading data:", error);
            }
        },
    },

    created() {
        this.loadData();
    },
};
</script>

<style scoped>
.indicator-title {
    font-size: 0.8rem;
    font-weight: 600;
}
.total-number {
    font-size: 3rem;
    font-weight: 600;
}
.dashboard-icon {
    font-size: 4rem;
}

/* Shimmer Loader */
.shimmer-loader {
    height: 40px;
    width: 80px;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite linear;
    border-radius: 4px;
}

@keyframes shimmer {
    0% { background-position: -200% 0; }
    100% { background-position: 200% 0; }
}
</style>
