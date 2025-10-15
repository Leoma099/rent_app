<template>
    <h3 class="fw-bold text-primary mb-0">Property Basic Info</h3>

    <div class="mt-3">
        <label class="form-label">* Property Name:</label>
        <input
            type="text"
            placeholder="ex. BUILDING 1"
            class="form-control rounded-0"
            v-model="form.title"
        />
    </div>

    <div class="mt-3">
        <label class="form-label">* Description:</label>
        <textarea
            rows="5"
            class="form-control rounded-0"
            v-model="form.description"
        ></textarea>
    </div>

    <div class="row">
        <div class="col-md-8">
            <label class="form-label">* Property Address:</label>
            <input
                type="text"
                placeholder="ex. ADDRESS 1"
                class="form-control rounded-0"
                v-model="form.address"
            />
        </div>
        <div class="col-md-4">
            <label class="form-label">* Property Status</label>
            <select class="form-select rounded-0" v-model="form.propertyStats">
                <option value="" disabled>-- select property status --</option>
                <option value="0">UNDER REVIEW</option>
                <option value="1">FOR RENT</option>
                <option value="2">RENTED</option>
                <option value="3">UNDER MAINTENANCE</option>
                <option value="4">RESERVED</option>
            </select>
        </div>
    </div>

    <div class="mt-3">
        <div class="row">
            <div class="col-md-6">
                <label class="form-label">* Business Type:</label>
                <select class="form-select rounded-0" v-model="form.property_type">
                    <option value="" disabled>-- select business type --</option>
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
                    v-model="form.price"
                />
            </div>

            <div class="col-md-3">
                <label class="form-label">* Square Meter:</label>
                <input
                    type="number"
                    placeholder="ex. 25"
                    class="form-control rounded-0"
                    v-model="form.size"
                />
            </div>
        </div>
    </div>

    <div class="mt-3">
        <label class="form-label">* Property Image:</label>
        <input type="file" class="form-control rounded-0" @change="handlePhotoUpload" />
        <div v-if="photoPreview" class="mt-2">
            <img :src="photoPreview" alt="Property Photo" class="img-fluid border" style="max-height: 200px;" />
        </div>
    </div>

    <div class="mt-3">
        <label class="form-label">* Property Floor Plan:</label>
        <input type="file" class="form-control rounded-0" @change="handleFloorPlanUpload" />
        <div v-if="floorPreview" class="mt-2">
            <img :src="floorPreview" alt="Floor Plan" class="img-fluid border" style="max-height: 200px;" />
        </div>
    </div>
</template>

<script>
export default
{
    computed:
    {
        form()
        {
            return this.$parent.form;
        },

        photoPreview()
        {
            if (this.form.photo instanceof File)
            {
                return URL.createObjectURL(this.form.photo);
            }
            else if (this.form.photo)
            {
                return `http://api.rent-app.loc/api/storage/${this.form.photo}`;
            }
            return null;
        },

        floorPreview()
        {
            if (this.form.floor_plan instanceof File)
            {
                return URL.createObjectURL(this.form.floor_plan);
            }
            else if (this.form.floor_plan)
            {
                return `http://api.rent-app.loc/api/storage/${this.form.floor_plan}`;
            }
            return null;
        }
    },

    methods:
    {
        handlePhotoUpload(event)
        {
            const file = event.target.files[0];
            this.form.photo = file ? file : null;
        },

        handleFloorPlanUpload(event)
        {
            const file = event.target.files[0];
            this.form.floor_plan = file ? file : null;
        }
    }
};
</script>

<style scoped>
img
{
    border-radius: 6px;
    object-fit: cover;
}
</style>
