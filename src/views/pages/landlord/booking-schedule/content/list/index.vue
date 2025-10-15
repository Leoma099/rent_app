<template>

    <h1 class="page-title mb-0">BOOKING SCHEDULE</h1>

    <div class="mt-3">

        <div class="card card-body shadow-sm border-0 rounded-0">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <router-link :to="'/administration/accounts/create'" class="btn rounded-0 button-color me-3 d-flex align-items-center">
                        <i class="bx bx-plus me-2"></i>
                        <span>Add New Lease</span>
                    </router-link>
                </div>
                <div class="col-md-4">
                    <input type="text" v-model="searchQuery" @input="loadList" placeholder="Type your search here"
                        class="form-control rounded-0">
                </div>
            </div>

            <div class="table-responsive table-scrollable">
                <table class="table table-bordered mb-0">
                    <thead>
                        <tr>
                            <th class="table-header">TENANT NAME</th>
                            <th class="table-header">PROPERTY NAME</th>
                            <th class="table-header">PROPERTY TYPE</th>
                            <th class="table-header">SCHEDULE</th>
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
                            @open-modal="openModal" />
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
        v-show="selectedBookingSchedule"
        :selectedBookingSchedule="selectedBookingSchedule"
        @refresh-list="loadList" />

    <delete-modal
        v-show="selectedBookingSchedule"
        :selectedBookingSchedule="selectedBookingSchedule"
        @refresh-list="loadList"/>

</template>

<script>
import apiClient from "@/services/index"
import ItemComponent from "./content/item"
import UpdateStatusModal from "./components/modals/update-status.vue";
import DeleteModal from "./components/modals/delete.vue";
export default
{

    components:
    {
        ItemComponent,
        UpdateStatusModal,
        DeleteModal
    },

    data() {
        return {
            items: [], // Your actual data
            searchQuery: "",
            isLoading: false,
            isEmpty: false,
            perPage: 10,
            currentPage: 1,
            selectedBookingSchedule: null
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

                    const response = await apiClient.get(`/bookings`, {
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

                }, 3000);
            }
            catch (error)
            {
                console.error(error);
                this.isLoading = false;
                this.isEmpty = true;
            }
        },

        openModal(item)
        {
            this.selectedBookingSchedule = item;
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