<template>
    <div class="row">
        <div
            v-for="(card, index) in cards"
            :key="index"
            class="col-md-2"
            :class="{ 'col-md-4': index === 0 }"
        >
            <div class="card card-body shadow-sm rounded-0 mb-3">
                <div class="d-flex justify-content-between align-items-center text-primary">
                    <div>
                        <span class="total-number mb-0">
                            <div v-if="card.loading" class="loader"></div>
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

export default
{
    data()
    {
        return {
            cards:
            [
                { label: "TOTAL PROPERTY", value: 0, icon: "bx bx-laptop", loading: true, endpoint: "/totalProperties", key: "total_properties" },
                { label: "TOTAL LEASE", value: 0, icon: "bx bx-user", loading: true, endpoint: "/leaseCount", key: "total_leases" },
                { label: "TOTAL PENDING", value: 0, icon: "bx bx-hourglass-top", loading: true, endpoint: "/pendingCount", key: "total_pending" },
                { label: "TOTAL BOOKED", value: 0, icon: "bx bx-book", loading: true, endpoint: "/bookedCount", key: "total_booked" },
                { label: "TOTAL INQUIRED", value: 0, icon: "bx bx-message-detail", loading: true, endpoint: "/inquireCount", key: "total_inquire" }
            ]
        };
    },

    methods:
    {
        async loadData()
        {
            try
            {
                await new Promise(resolve => setTimeout(resolve, 1000));
                // Load all data simultaneously
                const promises = this.cards.map(card => apiClient.get(card.endpoint));
                const responses = await Promise.all(promises);

                responses.forEach((res, i) => {
                    this.cards[i].value = res.data[this.cards[i].key] || 0;
                    this.cards[i].loading = false;
                });
            }
            catch (error)
            {
                console.error("Error loading data:", error);
            }
        }
    },

    created()
    {
        this.loadData();
    }
};
</script>

<style scoped>
.indicator-title
{
    font-size: 0.8rem;
    font-weight: 600;
}

.total-number
{
    font-size: 3rem;
    font-weight: 600;
}

.dashboard-icon
{
    font-size: 4rem;
}

/* Circular Loader */
.loader
{
    width: 50px;
    aspect-ratio: 1;
    border-radius: 50%;
    background:
        radial-gradient(farthest-side,#0d6efd 94%,#0000) top/8px 8px no-repeat,
        conic-gradient(#0000 30%,#0d6efd);
    -webkit-mask: radial-gradient(farthest-side,#0000 calc(100% - 8px),#000 0);
    animation: rotateLoader 1s infinite linear;
    margin-bottom: 0.5rem;
}

@keyframes rotateLoader
{
    100% { transform: rotate(1turn); }
}
</style>