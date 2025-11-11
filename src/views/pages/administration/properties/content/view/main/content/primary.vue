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
                    disabled
                >
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

    <div class="mt-3" v-for="(photo, index) in photos" :key="index">
        <div class="d-flex gap-3">
            <div class="image-preview rounded-3 border d-flex align-items-center justify-content-center">
                <img v-if="getPhotoUrl(photo.key)" :src="getPhotoUrl(photo.key)" class="img-fluid rounded" :alt="photo.label">
                <span v-else class="text-muted small">No image</span>
            </div>
            <div class="w-100">
                <div class="form-label">{{ photo.label }}:</div>
                <div class="position-relative">
                    <input type="file" class="form-control rounded-3 shadow-sm" disabled />
                </div>
            </div>
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
        photos()
        {
            return [
                { key: 'photo_1', label: 'Property 1st Image View' },
                { key: 'photo_2', label: 'Property 2nd Image View' },
                { key: 'photo_3', label: 'Property 3rd Image View' },
                { key: 'photo_4', label: 'Property 4th Image View' },
                { key: 'floor_plan', label: 'Property Floor Plan' }
            ];
        }
    },
    methods:
    {
        getPhotoUrl(key)
        {
            if (!this.form[key]) return '';
            if (this.form[key] instanceof File) return URL.createObjectURL(this.form[key]);
            if (this.form[key].startsWith("http")) return this.form[key];
            return `${process.env.VUE_APP_API_URL}/storage/${this.form[key]}`;
        },
        handleBusinessTypeSelect(event)
        {
            const value = event.target.value;
            if (!Array.isArray(this.form.property_type)) this.form.property_type = [];
            if (!this.form.property_type.includes(value) && this.form.property_type.length < 3)
            {
                this.form.property_type.push(value);
            }
            event.target.value = "";
        }
    }
}
</script>

<style scoped>
.image-preview
{
    width: 120px;
    height: 80px;
    background-color: #f8f9fa;
    border: 1px solid #dee2e6;
}
</style>