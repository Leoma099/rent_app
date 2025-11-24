<template>

    <h1 class="page-title mb-0">LEASES</h1>

    <div class="mt-3">
        <div class="card card-body shadow-sm border-0 rounded-0">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <router-link
                        :to="'/landlord/leases/create'"
                        class="btn rounded-0 button-color">
                        ADD NEW LEASE CONTRACTS
                    </router-link>
                </div>
                <div class="col-md-3">
                    <input
                        type="text"
                        v-model="searchQuery"
                        @input="loadList"
                        placeholder="Search here"
                        class="form-control rounded-0">
                </div>
            </div>

            <div class="table-responsive table-scrollable">
                <table class="table table-bordered mb-0">
                    <thead>
                        <tr>
                            <th class="table-header">TENANT NAME</th>
                            <th class="table-header">PROPERTY NAME</th>
                            <th class="table-header">START DATE</th>
                            <th class="table-header">END DATE</th>
                            <th class="table-header">PRICE</th>
                            <th class="table-header">STATUS</th>
                            <th class="table-header">ACTION</th>
                        </tr>
                    </thead>
                    <tbody v-if="!isEmpty">
                        <item-component
                            v-for="(item, index) in isLoading ? new Array(items.length || perPage).fill(null) : items"
                            :key="item?.id || index"
                            :item="item"
                            :isLoading="isLoading"
                            @open-status-modal="openStatusModal" />
                    </tbody>
                    <tbody v-else>
                        <tr>
                            <td colspan="8" class="text-center">No Data Record</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="pagination-container">
                <div class="entries-info">
                    Showing {{ (currentPage - 1) * perPage + 1 }} to {{ currentPage * perPage }} of {{ items.length }} records
                </div>
            </div>
        </div>
    </div>

    <!-- ✅ Include Modal -->
    <update-status-modal
        v-show="selectedLease"
        :selectedLease="selectedLease"
        @refresh-list="loadList" />

    <delete-modal
        v-show="selectedLease"
        :selectedLease="selectedLease"
        @refresh-list="loadList"/>

</template>

<script>
import apiClient from "@/services/index";
import ItemComponent from "./content/item.vue";
import UpdateStatusModal from "./components/modals/update-status.vue";
import DeleteModal from "./components/modals/delete.vue";
export default
{
    data()
    {
        return {
            items: [],
            searchQuery: "",
            isLoading: false,
            isEmpty: false,
            perPage: 10,
            currentPage: 1,
            selectedLease: null
        };
    },

    components:
    {
        ItemComponent,
        UpdateStatusModal,
        DeleteModal
    },

    mounted()
    {
        this.loadList();
    },

    methods:
    {
        async loadList()
        {
            try
            {
                this.isLoading = true;
                    const response = await apiClient.get(`/leases`, {
                        params:
                        {
                            search: this.searchQuery,
                            page: this.currentPage,
                            perPage: this.perPage
                        }
                    });

                    this.items = response.data;
                    this.isEmpty = this.items.length === 0;
                    this.isLoading = false;
            }
            catch (error)
            {
                console.error("Error fetching leases:", error);
                this.isLoading = false;
                this.isEmpty = true;
            }
        },

        openStatusModal(item)
        {
            this.selectedLease = item;
        }
    }
};
</script>

<style scoped>
.page-title {
    color: #007bff;
}

.button-color {
    background-color: #007bff;
    color: #ffffff;
}

.button-color:hover {
    background-color: #3798ff;
    color: #ffffff;
}

.table-header {
    font-size: 0.85rem;
    font-weight: 600;
    padding: 10px;
    background-color: #007bff;
    color: #ffffff;
}

.pagination-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 16px;
    font-size: 14px;
}

.entries-info {
    color: #666;
}

.pagination-buttons {
    display: flex;
    gap: 5px;
}
.table-scrollable {
    max-height: 400px;
    overflow-x: auto; /* horizontal scroll for small screens */
    overflow-y: auto; /* vertical scroll if content exceeds height */
    -webkit-overflow-scrolling: touch; /* smooth scrolling for mobile */
}

.table-scrollable table thead th
{
    position: sticky;
    top: 0;
    z-index: 10;
    background-color: #007bff;
    color: #fff;
    box-shadow: 0 2px 2px -1px rgba(0,0,0,0.4);
}

/* Optional: make table scroll nicely on mobile */
@media (max-width: 767px) {
    .table-scrollable {
        width: 100%;
        display: block;
        overflow-x: auto;
    }

    .table-scrollable table {
        min-width: 600px; /* ensure table is wider than container to trigger scroll */
    }

    .table-scrollable table thead th
    {
        position: sticky;
        top: 0;
        z-index: 10;
        background-color: #007bff;
        color: #fff;
        box-shadow: 0 2px 2px -1px rgba(0,0,0,0.4);
    }
}
</style>
