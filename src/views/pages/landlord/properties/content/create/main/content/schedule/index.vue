<template>

    <div class="modal fade" id="scheduleModal" tabindex="-1" aria-labelledby="scheduleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-0">

                <form @submit.prevent="submit()">

                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="scheduleModalLabel">Set day and time</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        
                        <div class="mb-3">
                            <label for="">* Available Day:</label>
                            <select
                                class="form-select rounded-0"
                                v-model="form.available_day"
                                required>
                                <option value="" disabled selected>-- select day --</option>
                                <option value="Monday">Monday</option>
                                <option value="Tuesday">Tuesday</option>
                                <option value="Wednesday">Wednesday</option>
                                <option value="Thursday">Thursday</option>
                                <option value="Friday">Friday</option>
                                <option value="Saturday">Saturday</option>
                                <option value="Sunday">Sunday</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="">* Select Start Time:</label>
                            <input
                                type="time"
                                class="form-control rounded-0"
                                v-model="form.start_time"
                                required>
                        </div>

                        <div class="mb-3">
                            <label for="">* Select End Time:</label>
                            <input
                                type="time"
                                class="form-control rounded-0"
                                v-model="form.end_time"
                                required>
                        </div>

                        <div class="text-end">
                            <button type="button" class="btn btn-sm rounded-0 btn-secondary me-2" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-sm rounded-0 btn-primary">Save</button>
                        </div>

                    </div>

                </form>

            </div>
        </div>
    </div>

    <div class="d-flex justify-content-between">

        <div>
            <h3 class="fw-bold text-primary mb-0">Schedule Visit Info</h3>
        </div>

        <div>
            <button
                type="button"
                class="btn btn-sm rounded-0 btn-primary d-flex align-items-center"
                data-bs-toggle="modal"
                data-bs-target="#scheduleModal">
                <i class="bx bx-plus"></i>
                <span>Add Schedule</span>
            </button>
        </div>

    </div>

    <div class="mt-3">

        <table class="table table-bordered mb-0">
            <thead>
                <tr>
                    <th class="table-header">DAY</th>
                    <th class="table-header">TIME</th>
                    <th class="table-header text-end">ACTION</th>
                </tr>
            </thead>
            <tbody v-if="schedules.length > 0">
                
                <item-component
                    v-for="(schedule, index) in schedules"
                    :key="index"
                    :schedule="schedule"
                    :deleteSchedule="deleteSchedule"/>

            </tbody>
            <tbody v-else>
                <tr>
                    <td colspan="8" class="text-center">No Schedule</td>
                </tr>
            </tbody>
        </table>

    </div>

</template>

<script>
import ItemComponent from "./content/item.vue";
export default
{
    data()
    {
        return{
            
            form:
            {
                available_day: "",
                start_time: this.getCurrentTime(),
                end_time: this.getEndTime(this.getCurrentTime()),
            },

        }
    },

    computed:
    {
        schedules()
        {
            return this.$parent.$data.form.schedules;
        },

        deleteSchedule()
        {
            return this.$parent.deleteSchedule;
        }
    },

    components:
    {
        ItemComponent
    },

    methods: 
    {
        async submit() 
        {
            if (
                !this.form.available_day ||
                !this.form.start_time ||
                !this.form.end_time
            ) 
            {
                alert("Please fill out all required fields.");
                return;
            }

            this.schedules.unshift(Object.assign({}, this.form));

            this.form.available_day = "";
        },

        getCurrentTime() 
        {
            const now = new Date();
            const hours = String(now.getHours()).padStart(2, "0");
            const minutes = String(now.getMinutes()).padStart(2, "0");
            return `${hours}:${minutes}`;
        },

        getEndTime(startTime) 
        {
            const [h, m] = startTime.split(":").map(Number);
            const date = new Date();
            date.setHours(h);
            date.setMinutes(m + 30);
            const hours = String(date.getHours()).padStart(2, "0");
            const minutes = String(date.getMinutes()).padStart(2, "0");
            return `${hours}:${minutes}`;
        },
    }
}
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
    font-size: 0.80rem;
    font-weight: 600;
    padding: 8px;
    background-color: #007bff;
    color: #ffffff;
}

.pagination-container 
{
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 16px;
    font-size: 14px;
}

.entries-info 
{
    color: #666;
}

.pagination-buttons 
{
    display: flex;
    gap: 5px;
}

.table-scrollable
{
    max-height: 500px;
    overflow: hidden;
}

.table-scrollable:hover
{
    overflow-y: auto;
}
</style>
