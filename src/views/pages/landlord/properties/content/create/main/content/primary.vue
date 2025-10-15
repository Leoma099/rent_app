<template>

    <h3 class="fw-bold text-primary mb-0">Property Basic Info</h3>

    <div class="mt-3">
        <label class="form-label">* Property Name:</label>
        <input
            type="text"
            placeholder="ex. BUILDIN 1"
            class="form-control rounded-0"
            v-model="form.title">
    </div>

    <div class="mt-3">
        <label class="form-label">* Description:</label>
        <textarea rows="10" class="form-control rounded-0" v-model="form.description"></textarea>
    </div>

    <div class="mt-3">
        <label class="form-label">* Property Address:</label>
        <input
            type="text"
            placeholder="ex. ADDRESS 1"
            class="form-control rounded-0"
            v-model="form.address">
    </div>

    <div class="mt-3">
        <div class="row">
            <div class="col-md-6">
                <label class="form-label">* Business Type:</label>
                <select class="form-select rounded-0" v-model="form.property_type">
                    <option value="" disabled selected>-- select business type --</option>
                    <option value="Office Space">Office Space</option>
                    <option value="Retail Shop">Retail Shop</option>
                    <option value="Restaurant">Restaurant</option>
                    <option value="Warehouse">Warehouse</option>
                    <option value="Industrial">Industrial</option>
                    <option value="Co-working">Co-working</option>
                    <option value="Hotel">Hotel</option>
                    <option value="Clinic">Clinic</option>
                    <option value="House">House</option>
                    <option value="Apartment">Apartment</option>
                    <option value="Townhouse">Townhouse</option>
                    <option value="Studio">Studio</option>
                    <option value="Land">Land</option>
                    <option value="Commercial">Commercial</option>
                    <option value="Parking Space">Parking Space</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">* Price:</label>
                <input
                    type="number"
                    placeholder="ex. 25000"
                    class="form-control rounded-0"
                    v-model="form.price">
            </div>
            <div class="col-md-3">
                <label class="form-label">* Square Meter:</label>
                <input
                    type="number"
                    placeholder="ex. 25"
                    class="form-control rounded-0"
                    v-model="form.size">
            </div>
        </div>
    </div>

    <div class="mt-3">
        <label class="form-label">* Property Image:</label>
        <input
            type="file"
            class="form-control rounded-0"
            @change="handlePhotoUpload">
    </div>

    <div class="mt-3">
        <label class="form-label">* Property Floor Plan:</label>
        <input
            type="file"
            class="form-control rounded-0"
            @change="handleFloorPlanUpload">
    </div>

</template>

<script>
export default
{
    computed:
    {
        form()
        {
            return this.$parent.$data.form;
        }
    },

    methods:
    {
        // ✅ handle file upload for photo
        handlePhotoUpload(event) {
            const file = event.target.files[0];
            if (file) {
                this.form.photo = file; // store file in parent form
            } else {
                this.form.photo = null;
            }
        },

        // ✅ handle file upload for floor plan
        handleFloorPlanUpload(event) {
            const file = event.target.files[0];
            if (file) {
                this.form.floor_plan = file; // store file in parent form
            } else {
                this.form.floor_plan = null;
            }
        }
    }
}
</script>

<style>

</style>