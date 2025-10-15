<template>

    <div class="card card-body shadow-sm border-0">

        <p class="mb-0">EQUIPMENT LIST</p>

        <div class="mt-3">

            <div class="table-responsive">

                <table class="table table-borderless">

                    <thead class="table-primary">

                        <tr>

                            <th>Equipment Name</th>
                            <th>Type</th>
                            <th>Condition</th>
                            <th>Status</th>
                            <th>Date Registered</th>

                        </tr>

                    </thead>

                    <tbody v-for="(item, index) in items" :key="index">

                        <tr>

                            <td>{{ item.equipment_name }}</td>
                            <td>{{ item.equipment_type }}</td>
                            <td>{{ item.equipment_condition }}</td>
                            <td>{{ item.equipment_status }}</td>
                            <td>{{ item.equipment_date_reg }}</td>

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
                    equipment_name: 'Printer',
                    equipment_type: 'Printer',
                    equipment_condition: 'Good',
                    equipment_status: 'Available',
                    equipment_date_reg: 'December 23, 2024',

                }
            ]

        }

    }
}
</script>

<style>

</style>