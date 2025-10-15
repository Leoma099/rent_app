<template>
    <div class="row mb-3">
        <div class="col-md-3">
            <router-link :to="'/equipment/list'" style="text-decoration: none;">
                <div class="card card-body shadow-sm  rounded-0">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="total-number mb-0">{{ totalProperties }}</span>
                            <p class="indicator-title mb-0">TOTAL PROPERTY</p>
                        </div>
                        <i class="bx bx-laptop dashboard-icon"></i>
                    </div>
                </div>
            </router-link>
        </div>
        <div class="col-md-3">
            <router-link :to="'/borrow/list'" style="text-decoration: none;">
                <div class="card card-body shadow-sm  rounded-0">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="total-number mb-0">{{ totalAccounts }}</span>
                            <p class="indicator-title mb-0">TOTAL ACCOUNT</p>
                        </div>
                        <i class="bx bx-collection dashboard-icon"></i>
                    </div>
                </div>
            </router-link>
        </div>
        <div class="col-md-3">
            <router-link :to="'/account/list'" style="text-decoration: none;">
                <div class="card card-body shadow-sm  rounded-0">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="total-number mb-0">{{ totalRents }}</span>
                            <p class="indicator-title mb-0">TOTAL RENT</p>
                        </div>
                        <i class="bx bx-user dashboard-icon"></i>
                    </div>
                </div>
            </router-link>
        </div>
        <div class="col-md-3">
            <router-link :to="'/account/list'" style="text-decoration: none;">
                <div class="card card-body shadow-sm  rounded-0">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="total-number mb-0">{{ totalPending }}</span>
                            <p class="indicator-title mb-0">TOTAL PENDING</p>
                        </div>
                        <i class="bx bx-user dashboard-icon"></i>
                    </div>
                </div>
            </router-link>
        </div>
    </div>
</template>

<script>
import apiClient from "@/services/index";

export default 
{
    data()
    {
        return{
            properties: [], 
            accounts: [],
            rents: [],
            pending: []
        };
    },

    computed:
    {
        totalProperties()
        {
            return this.properties || 0;
        },
        totalAccounts()
        {
            return (this.accounts || []).length;
        },
        totalRents()
        {
            return (this.rents || []).length;
        },
        totalPending()
        {
            return (this.pending || []).length;
        },
    },

    methods:
    {
        async loadData()
        {
            try
            {
                const propertyResponse = await apiClient.get('/totalProperties');
                console.log("Equipment Response:", propertyResponse.data);
                this.properties = propertyResponse.data.total_properties || 0;

                const accountResponse = await apiClient.get('/accounts');
                console.log("Borrow Response:", accountResponse.data);
                this.accounts = accountResponse.data?.data || [];

                const rentResponse = await apiClient.get('/rents');
                console.log("Borrow Response:", rentResponse.data);
                this.rents = rentResponse.data?.data || [];

                const pendingResponse = await apiClient.get('/pendings');
                console.log("Borrow Response:", pendingResponse.data);
                this.pendings = pendingResponse.data?.data || [];
            }
            catch (error)
            {
                console.error("Error loading data:", error);
            }
        }
    },

    created() {
        this.loadData();
    },
};
</script>

<style scoped>
.indicator-title {
    font-size: .80rem;
    font-weight: 600;
}
.total-number {
    font-size: 3rem;
    font-weight: 600;
}
.dashboard-icon {
    font-size: 4rem;
}
</style>
