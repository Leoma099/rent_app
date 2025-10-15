<template>

    <div class="card card-body shadow-sm border-0">

        <p class="mb-0">OVERDUE LIST</p>

        <div class="mt-3">

            <div class="table-responsive">

                <table class="table table-borderless">

                    <thead class="table-primary">

                        <tr>

                            <th>User ID</th>
                            <th>Name</th>
                            <th>Equipment ID</th>
                            <th>Overdue</th>
                            <th>Status</th>

                        </tr>

                    </thead>

                    <tbody v-for="(item, index) in items" :key="index">

                        <tr>

                            <td>{{ item.user_id }}</td>
                            <td>{{ item.user_fullName }}</td>
                            <td>{{ item.eequipment_id }}</td>
                            <td>{{ item.equipment_overdue }}</td>
                            <td>{{ item.equipment_status }}</td>

                        </tr>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</template>

<script>
export default
{
    data(){

        return{

            items:
            [
                {
                    user_id: '#MISO10001',
                    user_fullName: 'Jeffrey Culanag',
                    eequipment_id: '#EQP-1002',
                    equipment_overdue: '3 Days',
                    equipment_status: 'Returned (late)'
                }
            ]

        }

    }
}
</script>

<style>

</style>