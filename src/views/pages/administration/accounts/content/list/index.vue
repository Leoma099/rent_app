<template>

    <h1 class="page-title mb-0">ACCOUNTS</h1>

    <div class="mt-3">

        <div class="card card-body shadow-sm border-0 rounded-0">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <router-link :to="'/administration/accounts/create'" class="btn rounded-0 button-color me-3">
                        <i class="bx bx-plus me-2"></i> Add User
                    </router-link>
                </div>
                <div class="col-md-4">
                    <input type="text" v-model="searchQuery" @input="fetchAccount" placeholder="Type your search here"
                        class="form-control rounded-0">
                </div>
            </div>

            <div class="table-responsive table-scrollable">
                <table class="table table-bordered mb-0">
                    <thead>
                        <tr>
                            <th class="table-header">ID NUMBER</th>
                            <th class="table-header">FULL NAME</th>
                            <th class="table-header">EMAIL</th>
                            <th class="table-header">MOBILE NUMBER</th>
                            <th class="table-header">STATUS</th>
                            <th class="table-header">ROLE</th>
                            <th class="table-header">CREATED DATE</th>
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
        v-show="selectedUser"
        :selectedUser="selectedUser"
        @refresh-list="fetchAccount" />

</template>

<script>
import apiClient from "@/services/index"
import ItemComponent from "./content/item"
import UpdateStatusModal from "./components/modals/update-status.vue";
export default
{

    components:
    {
        ItemComponent,
        UpdateStatusModal,
    },

    data() {
        return {
            items: [], // Your actual data
            searchQuery: "",
            isLoading: false,
            isEmpty: false,
            perPage: 10,
            currentPage: 1,
            selectedUser: null
        };
    },

    computed:
    {

        totalPages() {
            return Math.ceil(this.totalEntries / this.perPage);
        },

        startEntry() {
            return (this.currentPage - 1) * this.perPage + 1;
        },

        endEntry() {
            return Math.min(this.currentPage * this.perPage, this.totalEntries);
        },

        visiblePages() {
            const pages = [];
            const maxPages = 6;
            let start = Math.max(1, this.currentPage - Math.floor(maxPages / 2));
            let end = Math.min(this.totalPages, start + maxPages - 1);

            for (let i = start; i <= end; i++) {
                pages.push(i);
            }
            return pages;
        }

    },

    mounted()
    {
        this.fetchAccount();
    },

    methods:
    {
        async fetchAccount() {
            try {
                this.isLoading = true;
                setTimeout(async () => {
                    const response = await apiClient.get(`/admin/accounts`, {
                        params: {
                            search: this.searchQuery,
                            page: this.currentPage,
                            perPage: this.perPage
                        }
                    });

                    console.log("Fetched Equipment Data:", response.data); // Debugging

                    this.items = response.data.data;
                    this.isEmpty = this.items.length === 0; // Check if items array is empty
                    this.isLoading = false;
                }, 3000);
            } catch (error) {
                console.error("Error fetching equipment:", error);
                this.isLoading = false;
                this.isEmpty = true; // Assume empty on error
            }
        },

        openStatusModal(item)
        {
            this.selectedUser = item;
        }

    },

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