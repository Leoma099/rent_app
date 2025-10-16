<template>

    <h1 class="page-title mb-0">LIST OF PROPERTIES</h1>

    <div class="mt-3">

        <div class="card card-body shadow-sm border-0 rounded-0">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <router-link
                        :to="'/landlord/properties/create'"
                        class="btn rounded-0 button-color">ADD NEW PROPERTY
                    </router-link>
                </div>
                <div class="col-md-3 ">
                    <input type="text" v-model="searchQuery" @input="loadList" placeholder="Search here"
                        class="form-control rounded-0">
                </div>
            </div>

            <div class="table-responsive table-scrollable">
                <table class="table table-bordered mb-0">
                    <thead>
                        <tr>
                            <th class="table-header"><small>PROPERTY NAME</small></th>
                            <th class="table-header"><small>ADDRESS</small></th>
                            <th class="table-header"><small>PROPERTY STATUS</small></th>
                            <th class="table-header"><small>TYPE</small></th>
                            <th class="table-header"><small>PRICE</small></th>
                            <th class="table-header"><small>STATUS</small></th>
                            <th class="table-header"><small>FEATURED</small></th>
                            <th class="table-header"><small>ACTION</small></th>
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
            <!-- Pagination is here -->
            <div class="pagination-container">
                <div class="entries-info">
                    Showing {{ (currentPage - 1) * perPage + 1 }} to {{ currentPage * perPage }} of {{ items.length }} records
                </div>
                <div class="pagination-buttons">
                    <!-- Pagination buttons here -->
                </div>
            </div>
        </div>

    </div>

    <update-status-modal
        v-show="selectedProperty"
        :selectedProperty="selectedProperty"
        @refresh-list="loadList" />

    <delete-modal
        v-show="selectedProperty"
        :selectedProperty="selectedProperty"
        @refresh-list="loadList"/>

    <featured-modal
        v-show="selectedProperty"
        :selectedProperty="selectedProperty"
        @refresh-list="loadList"/>

</template>

<script>
import apiClient from "@/services/index"
import ItemComponent from "./content/item"
import UpdateStatusModal from "./components/modals/update-status.vue";
import DeleteModal from "./components/modals/delete.vue";
import FeaturedModal from "./components/modals/featured.vue";
export default
{
    data()
    {
        return{
            items: [],
            searchQuery: "",
            isLoading: false,
            isEmpty: false,
            perPage: 10,
            currentPage: 1,
            selectedProperty: null
        }
    },

    components:
    {
        ItemComponent,
        UpdateStatusModal,
        DeleteModal,
        FeaturedModal
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
                    const response = await apiClient.get(`/properties`, {
                        params: {
                            search: this.searchQuery,
                            page: this.currentPage,
                            perPage: this.perPage
                        }
                    });

                    console.log("Fetched Properties Data:", response.data); // Debugging

                    this.items = response.data;
                    this.isEmpty = this.items.length === 0; // Check if items array is empty
                    this.isLoading = false;
                }, 3000);
            }
            catch (error)
            {
                console.error("Error fetching properties:", error);
                this.isLoading = false;
                this.isEmpty = true; // Assume empty on error
            }
        },

        openStatusModal(item)
        {
            this.selectedProperty = item;
        }
    }
}
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
.table-scrollable
{
    max-height: 500px;
    overflow: hidden; /* Hidden by default */
}
.table-scrollable:hover
{
    overflow-y: auto; /* Show scrollbar when hovering */
}
</style>