<template>
    <div class="row">
        <div class="col-md-4 mb-3">
            <div class="card card-body shadow-sm rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">
                            <template v-if="properties !== null">{{ totalProperties }}</template>
                            <template v-else>
                                <div class="loader"></div>
                            </template>
                        </span>
                        <p class="indicator-title mb-0 text-primary">TOTAL PROPERTIES</p>
                    </div>
                    <i class="bx bx-laptop dashboard-icon text-primary"></i>
                </div>
            </div>
        </div>

        <div class="col-md-2 mb-3">
            <div class="card card-body shadow-sm rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">
                            <template v-if="landlords !== null">{{ totalLandlords }}</template>
                            <template v-else>
                                <div class="loader"></div>
                            </template>
                        </span>
                        <p class="indicator-title mb-0 text-primary">TOTAL LANDLORDS</p>
                    </div>
                    <i class="bx bx-user dashboard-icon text-primary"></i>
                </div>
            </div>
        </div>

        <div class="col-md-2 mb-3">
            <div class="card card-body shadow-sm rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">
                            <template v-if="tenants !== null">{{ totalTenants }}</template>
                            <template v-else>
                                <div class="loader"></div>
                            </template>
                        </span>
                        <p class="indicator-title mb-0 text-primary">TOTAL TENANTS</p>
                    </div>
                    <i class="bx bx-user dashboard-icon text-primary"></i>
                </div>
            </div>
        </div>

        <div class="col-md-2 mb-3">
            <div class="card card-body shadow-sm rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">
                            <template v-if="pending_properties !== null">{{ totalPendingProperties }}</template>
                            <template v-else>
                                <div class="loader"></div>
                            </template>
                        </span>
                        <p class="indicator-title mb-0 text-primary">TOTAL PENDING PROPERTIES</p>
                    </div>
                    <i class="bx bx-user dashboard-icon text-primary"></i>
                </div>
            </div>
        </div>

        <div class="col-md-2 mb-3">
            <div class="card card-body shadow-sm rounded-0">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="total-number mb-0 text-primary">
                            <template v-if="pending_accounts !== null">{{ totalPendingAccounts }}</template>
                            <template v-else>
                                <div class="loader"></div>
                            </template>
                        </span>
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
            properties: null, 
            landlords: null,
            tenants: null,
            pending_properties: null,
            pending_accounts: null,
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
                // Optional delay to show loader
                await new Promise(resolve => setTimeout(resolve, 1000));

                const [
                    propertyResponse,
                    landlordResponse,
                    tenantResponse,
                    pendingPropertiesResponse,
                    pendinAccountResponse
                ] = await Promise.all([
                    apiClient.get('/admin/dashboard/summary/properties'),
                    apiClient.get('/admin/dashboard/summary/user/landlords'),
                    apiClient.get('/admin/dashboard/summary/user/tenants'),
                    apiClient.get('/admin/dashboard/summary/total/properties'),
                    apiClient.get('/admin/dashboard/summary/users')
                ]);

                this.properties = propertyResponse.data.total_properties || 0;
                this.landlords = landlordResponse.data.total_landlords || 0;
                this.tenants = tenantResponse.data.total_tenants || 0;
                this.pending_properties = pendingPropertiesResponse.data.total_pending_properties || 0;
                this.pending_accounts = pendinAccountResponse.data.total_user_pending || 0;
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
    font-size: .80rem;
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

.loader
{
    width: 50px;
    aspect-ratio: 1;
    border-radius: 50%;
    background: 
        radial-gradient(farthest-side,#0d6efd 94%,#0000) top/8px 8px no-repeat,
        conic-gradient(#0000 30%,#0d6efd);
    -webkit-mask: radial-gradient(farthest-side,#0000 calc(100% - 8px),#000 0);
    animation: l13 1s infinite linear;
}

@keyframes l13
{ 
    100%
    {
        transform: rotate(1turn);
    }
}
</style>
