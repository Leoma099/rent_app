<template>
    <h3 class="fw-bold text-primary mb-0">Property Basic Info</h3>

    <div class="mt-3">
        <label class="form-label">* Property Name:</label>
        <input
            type="text"
            placeholder="ex. BUILDING 1"
            class="form-control rounded-0"
            v-model="form.title"
            disabled
        />
    </div>

    <div class="mt-3">
        <label class="form-label">* Description:</label>
        <textarea
            rows="5"
            class="form-control rounded-0"
            v-model="form.description"
            disabled
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
                disabled
            />
        </div>
        <div class="col-md-4">
            <label class="form-label">* Property Status</label>
            <select class="form-select rounded-0" v-model="form.propertyStats" disabled>
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
                <input
                    type="text"
                    class="form-control rounded-0"
                    :value="Array.isArray(form.property_type) ? form.property_type.join(', ') : ''"
                    disabled
                />
                <select
                    class="form-select rounded-0 mt-3"
                    @change="handleBusinessTypeSelect"
                    disabled>
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
                    v-model="form.price"
                    disabled
                />
            </div>

            <div class="col-md-3">
                <label class="form-label">* Square Meter:</label>
                <input
                    type="number"
                    placeholder="ex. 25"
                    class="form-control rounded-0"
                    v-model="form.size"
                    disabled
                />
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
                    @change="uploadFirstImage"
                    disabled/>
            </div>
            <div class="col-md-3">
                <label class="form-label">* Property Second View:</label>
                <input
                    type="file"
                    class="form-control rounded-0"
                    @change="uploadSecondImage"
                    disabled/>
            </div>
            <div class="col-md-3">
                <label class="form-label">* Property Third View:</label>
                <input
                    type="file"
                    class="form-control rounded-0"
                    @change="uploadThirdImage"
                    disabled/>
            </div>
            <div class="col-md-3">
                <label class="form-label">* Property Fourth View:</label>
                <input
                    type="file"
                    class="form-control rounded-0"
                    @change="uploadFourthImage"
                    disabled/>
            </div>
        </div>
    </div>

    <div class="mt-3">
        <label class="form-label">* Property Floor Plan:</label>
        <input
            type="file"
            class="form-control rounded-0"
            @change="handleFloorPlanUpload"
            disabled/>
    </div>
</template>

<script>
export default
{
    computed:
    {
        form()
        {
            return this.$parent.form
        }
    },

    methods:
    {
        handleBusinessTypeSelect(event)
        {
            const value = event.target.value

            if (!Array.isArray(this.form.property_type))
            {
                this.form.property_type = []
            }

            if (this.form.property_type.includes(value))
            {
                this.form.property_type = this.form.property_type.filter(type => type !== value)
            }
            else
            {
                if (this.form.property_type.length >= 3)
                {
                    alert("You can only select up to 3 business types.")
                    event.target.value = ""
                    return
                }

                this.form.property_type.push(value)
            }

            event.target.value = ""
        },

        uploadFirstImage(event)
        {
            const file = event.target.files[0]
            this.form.photo_1 = file || null
        },

        uploadSecondImage(event)
        {
            const file = event.target.files[0]
            this.form.photo_2 = file || null
        },

        uploadThirdImage(event)
        {
            const file = event.target.files[0]
            this.form.photo_3 = file || null
        },

        uploadFourthImage(event)
        {
            const file = event.target.files[0]
            this.form.photo_4 = file || null
        },

        handleFloorPlanUpload(event)
        {
            const file = event.target.files[0]
            this.form.floor_plan = file || null
        }
    }
}
</script>

<style scoped>
img
{
    border-radius: 6px;
    object-fit: cover;
}
</style>
