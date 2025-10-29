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
                setTimeout(async () => {
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
                }, 1000);
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
.page-title
{
    color: #007bff;
}

.button-color
{
    background-color: #007bff;
    color: #ffffff;
}

.button-color:hover
{
    background-color: #3798ff;
    color: #ffffff;
}

.table-header
{
    font-size: 0.85rem;
    font-weight: 600;
    padding: 10px;
    background-color: #007bff;
    color: #ffffff;
}

.table-scrollable
{
    max-height: 650px;
    overflow: hidden;
}
.table-scrollable:hover
{
    overflow-y: auto;
}
</style>
