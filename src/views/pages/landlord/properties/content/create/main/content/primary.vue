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
        <div class="row">
            <div class="col-md-3">
                <label class="form-label">* Property First View:</label>
                <input
                    type="file"
                    class="form-control rounded-0"
                    @change="uploadFirstImage">
            </div>
            <div class="col-md-3">
                <label class="form-label">* Property Second View:</label>
                <input
                    type="file"
                    class="form-control rounded-0"
                    @change="uploadSecondImage">
            </div>
            <div class="col-md-3">
                <label class="form-label">* Property Third View:</label>
                <input
                    type="file"
                    class="form-control rounded-0"
                    @change="uploadThirdImage">
            </div>
            <div class="col-md-3">
                <label class="form-label">* Property Fourth View:</label>
                <input
                    type="file"
                    class="form-control rounded-0"
                    @change="uploadFourthImage">
            </div>
        </div>
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
        uploadFirstImage(event)
        {
            const file = event.target.files[0];
            if (file) {
                this.form.photo_1 = file; // ✅ Fixed: changed from 'photo' to 'photo_1'
            } else {
                this.form.photo_1 = null;
            }
        },

        uploadSecondImage(event)
        {
            const file = event.target.files[0];
            if (file) {
                this.form.photo_2 = file; // ✅ Fixed: changed from 'photo' to 'photo_2'
            } else {
                this.form.photo_2 = null;
            }
        },

        uploadThirdImage(event)
        {
            const file = event.target.files[0];
            if (file) {
                this.form.photo_3 = file; // ✅ Fixed: changed from 'photo' to 'photo_3'
            } else {
                this.form.photo_3 = null;
            }
        },

        uploadFourthImage(event)
        {
            const file = event.target.files[0];
            if (file) {
                this.form.photo_4 = file; // ✅ Fixed: changed from 'photo' to 'photo_4'
            } else {
                this.form.photo_4 = null;
            }
        },

        // ✅ handle file upload for floor plan (this one is correct)
        handleFloorPlanUpload(event) {
            const file = event.target.files[0];
            if (file) {
                this.form.floor_plan = file;
            } else {
                this.form.floor_plan = null;
            }
        }
    }
}
</script>

<style>

</style>