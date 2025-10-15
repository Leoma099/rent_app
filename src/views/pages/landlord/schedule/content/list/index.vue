<template>

    <h1 class="page-title mb-0">LIST OF SCHEDULE</h1>

    <div class="mt-3">

        <div class="card card-body shadow-sm border-0 rounded-0">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <router-link
                        :to="'/landlord/schedule/create'"
                        class="btn rounded-0 button-color d-flex align-items-center me-3">
                        <i class="bx bx-plus me-2"></i>
                        <span>Add Booking Schedule</span>
                    </router-link>
                </div>
                <div class="col-md-3 ">
                    <input type="text" v-model="searchQuery" @input="fetchDelivery" placeholder="Search here"
                        class="form-control rounded-0">
                </div>
            </div>

            <div class="table-responsive table-scrollable">
                <table class="table table-bordered mb-0">
                    <thead>
                        <tr>
                            <th class="table-header">ID</th>
                            <th class="table-header">PROPERTY NAME</th>
                            <th class="table-header">AVAILABLE DAY</th>
                            <th class="table-header">TIME</th>
                            <th class="table-header">ACTION</th>
                        </tr>
                    </thead>
                    <tbody v-if="!isEmpty">
                        <item-component
                            v-for="(item, index) in isLoading ? new Array(items.length || perPage).fill(null) : items"
                            :key="item?.id || index" :item="item" :isLoading="isLoading" />
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

</template>

<script>
import apiClient from "@/services";
import ItemComponent from "./content/item.vue";
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
            currentPage: 1
        }
    },

    components:
    {
        ItemComponent
    },

    mounted()
    {
        this.onLoad();
    },

    methods:
    {
        async onLoad()
        {
            const response = await apiClient.get(`/schedules`);
            this.items = response.data;
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