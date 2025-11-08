<template>

    <div class="card card-body shadow-sm border-0">

        <p class="mb-0">USER LIST</p>

        <div class="mt-3">

            <div class="table-responsive">

                <table class="table table-borderless">

                    <thead class="table-primary">

                        <tr>

                            <th>User ID</th>
                            <th>Name</th>
                            <th>Equipment Issued</th>
                            <th>Department</th>

                        </tr>

                    </thead>

                    <tbody v-for="(item, index) in items" :key="index">

                        <tr>

                            <td>{{ item.user_id }}</td>
                            <td>{{ item.user_fullName }}</td>
                            <td>{{ item.equipment_issued }}</td>
                            <td>{{ item.user_department }}</td>

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
                    user_fullName: 'Gabriel Peralta',
                    equipment_issued: 'January 19, 2024',
                    user_department: 'Department of Fire Rescue',

                }
            ]

        }

    }
}
</script>

<style>

</style>