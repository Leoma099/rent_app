<template>
    <div class="row mb-3">
        <div class="col-md-4">
            <div class="card card-body shadow-sm  rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">{{ totalProperties }}</span>
                        <p class="indicator-title mb-0 text-primary">TOTAL PROPERTIES</p>
                    </div>
                    <i class="bx bx-laptop dashboard-icon text-primary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card card-body shadow-sm  rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">{{ totalLandlords }}</span>
                        <p class="indicator-title mb-0 text-primary">TOTAL LANDLORDS</p>
                    </div>
                    <i class="bx bx-user dashboard-icon text-primary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card card-body shadow-sm  rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">{{ totalTenants }}</span>
                        <p class="indicator-title mb-0 text-primary">TOTAL TENANTS</p>
                    </div>
                    <i class="bx bx-user dashboard-icon text-primary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card card-body shadow-sm  rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">{{ totalPendingProperties }}</span>
                        <p class="indicator-title mb-0 text-primary">TOTAL PENDING PROPERTIES</p>
                    </div>
                    <i class="bx bx-user dashboard-icon text-primary"></i>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card card-body shadow-sm  rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">{{ totalPendingAccounts }}</span>
                        <p class="indicator-title mb-0 text-primary">TOTAL PENDING ACCOUNTS</p>
                    </div>
                    <i class="bx bx-user dashboard-icon text-primary"></i>
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
        return{
            properties: 0, 
            landlords: 0,
            tenants: 0,
            pending_properties: 0,
            pending_accounts: 0,
        };
    },

    computed:
    {
        totalProperties()
        {
            return this.properties;
        },
        totalLandlords()
        {
            return this.landlords;
        },
        totalTenants()
        {
            return this.tenants;
        },
        totalPendingProperties()
        {
            return this.pending_properties;
        },
        totalPendingAccounts()
        {
            return this.pending_accounts;
        }
    },

    methods:
    {
        async loadData()
        {
            try
            {
                const propertyResponse = await apiClient.get('/totalProperties');
                console.log("Property Response:", propertyResponse.data);
                this.properties = propertyResponse.data.total_properties || 0;

                const landlordResponse = await apiClient.get('/totalLandlords');
                console.log("Landlord Response:", landlordResponse.data);
                this.landlords = landlordResponse.data.total_landlords || 0;

                const tenantResponse = await apiClient.get('/totalTenants');
                console.log("Tenant Response:", tenantResponse.data);
                this.tenants = tenantResponse.data.total_tenants || 0;

                const pendingPropertiesResponse = await apiClient.get('/totalPendingProperties');
                console.log("PendingProperty Response:", pendingPropertiesResponse.data);
                this.pending_properties = pendingPropertiesResponse.data.total_pending_properties || 0;

                const pendinAccountResponse = await apiClient.get('/totalUserPending');
                console.log("Pending Account Response:", pendinAccountResponse.data);
                this.pending_accounts = pendinAccountResponse.data.total_user_pending || 0;
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
