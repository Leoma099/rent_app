<template>

    <div class="card card-body card-white rounded-0 shadow-sm">

        <h5 class="mb-0">Property Active Listings</h5>

        <div class="mt-3">

            <div class="table-responsive table-scrollable">
                <table class="table table-bordered mb-0">
                    <thead>
                        <tr>
                            <th class="table-header">ADDRESS</th>
                            <th class="table-header">LANDLORD</th>
                            <th class="table-header">CREATED DATE</th>
                            <th class="table-header">STATUS</th>
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
                <div class="pagination-buttons">
                    <!-- Pagination buttons here -->
                </div>
            </div>

        </div>

    </div>

</template>

<script>
import apiClient from "@/services/index"
import ItemComponent from "./content/item"
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
        ItemComponent
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
                    const response = await apiClient.get(`/admin/dashboard/properties/options`, {
                        params: {
                            search: this.searchQuery,
                            page: this.currentPage,
                            perPage: this.perPage
                        }
                    });

                    console.log("Fetched Properties Data:", response.data); // Debugging

                    this.items = response.data.properties || [];
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
    max-height: 400px;
    overflow: hidden; /* Hidden by default */
}
.table-scrollable:hover
{
    overflow-y: auto; /* Show scrollbar when hovering */
}
</style>