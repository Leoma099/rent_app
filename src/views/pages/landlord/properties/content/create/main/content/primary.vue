<template>
    <h3 class="fw-bold text-primary mb-0">Property Basic Info</h3>

    <div class="mt-3">
        <label class="form-label">* Property Name:</label>
        <input
            type="text"
            placeholder="Ex. Building 1, Sunshine Tower"
            class="form-control rounded-0"
            v-model="form.title"
            :class="{ 'is-invalid': errors.title }"
        >
        <div v-if="errors.title" class="invalid-feedback">{{ errors.title }}</div>
    </div>

    <div class="mt-3">
        <label class="form-label">* Description:</label>
        <textarea
            rows="10"
            placeholder="Ex. 3-storey commercial building with office spaces and retail shops"
            class="form-control rounded-0"
            v-model="form.description"
            :class="{ 'is-invalid': errors.description }"
        ></textarea>
        <div v-if="errors.description" class="invalid-feedback">{{ errors.description }}</div>
    </div>

    <div class="mt-3">
        <div class="row overflow-hidden">
            <div class="col-md-8">
                <label class="form-label">* Property Address:</label>
                <input
                    type="text"
                    placeholder="Ex. Lot 4, Block 6, Main Street"
                    class="form-control rounded-0"
                    v-model="form.address"
                    :class="{ 'is-invalid': errors.address }"
                >
                <div v-if="errors.address" class="invalid-feedback">{{ errors.address }}</div>
            </div>

            <div class="col-md-4">
                <label class="form-label">* Select Barangay:</label>
                <select class="form-select rounded-0" v-model="form.barangay" :class="{ 'is-invalid': errors.barangay }">
                    <option value="" disabled selected>-- select barangay --</option>
                    <option v-for="b in barangays" :key="b" :value="b">{{ b }}</option>
                </select>
                <div v-if="errors.barangay" class="invalid-feedback">{{ errors.barangay }}</div>
            </div>
        </div>
    </div>

    <div class="mt-3">
        <label class="form-label">* Business Type:</label>
        <input
            type="text"
            placeholder="ex. Commercial"
            class="form-control rounded-0"
            :value="Array.isArray(form.property_type) ? form.property_type.join(', ') : ''"
            readonly
            :class="{ 'is-invalid': errors.property_type }"
        >
        <div v-if="errors.property_type" class="invalid-feedback">{{ errors.property_type }}</div>

        <select class="form-select rounded-0 mt-3" @change="handleBusinessTypeSelect">
            <option value="" disabled selected>-- select business type --</option>
            <option v-for="type in businessTypes" :key="type" :value="type">{{ type }}</option>
        </select>
    </div>

    <div class="mt-3">
        <div class="row">
            <div class="col-md-6">
                <label class="form-label">* Price:</label>
                <input
                    type="number"
                    placeholder="Ex. 25000"
                    class="form-control rounded-0"
                    v-model="form.price"
                    :class="{ 'is-invalid': errors.price }"
                >
                <div v-if="errors.price" class="invalid-feedback">{{ errors.price }}</div>
            </div>
            <div class="col-md-6">
                <label class="form-label">* Square Meter:</label>
                <input
                    type="number"
                    placeholder="Ex. 25"
                    class="form-control rounded-0"
                    v-model="form.size"
                    :class="{ 'is-invalid': errors.size }"
                >
                <div v-if="errors.size" class="invalid-feedback">{{ errors.size }}</div>
            </div>
        </div>
    </div>

    <!-- Image Uploads -->
    <div class="mt-3" v-for="(photo, index) in photos" :key="index">
        <div class="d-flex gap-3">

            <div
                class="image-preview rounded-3 border d-flex align-items-center justify-content-center"
                v-if="getPhotoUrl(photo.key)"
                data-bs-toggle="modal"
                :data-bs-target="'#modal-' + photo.key"
                style="cursor: pointer;"
            >
                <img :src="getPhotoUrl(photo.key)" class="img-fluid rounded" :alt="photo.label">
            </div>

            <div
                class="image-preview rounded-3 border d-flex align-items-center justify-content-center"
                v-else
            >
                <span class="text-muted small">No image</span>
            </div>

            <div class="w-100">
                <div class="form-label">{{ photo.label }}:</div>
                <div class="position-relative">
                    <input
                        type="file"
                        class="form-control rounded-3 shadow-sm"
                        @change="handleFileUpload($event, photo.key)"
                    >
                    <span
                        v-if="form[photo.key]"
                        class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold"
                        style="cursor: pointer; font-size: 1.25rem; line-height: 1;"
                        @click.prevent="clearFile(photo.key, $event)"
                    >
                        <i class="text-danger bx bx-x"></i>
                    </span>
                </div>
                <div v-if="errors[photo.key]" class="invalid-feedback d-block">{{ errors[photo.key] }}</div>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" :id="'modal-' + photo.key" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body p-0 text-center">
                        <img :src="getPhotoUrl(photo.key)" class="img-fluid" :alt="photo.label">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
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
            return this.$parent.$data.form;
        },

        errors()
        {
            return this.$parent.$data.errors || {};
        },

        photos()
        {
            return [
                { key: 'photo_1', label: 'Property 1st Image View' },
                { key: 'photo_2', label: 'Property 2nd Image View' },
                { key: 'photo_3', label: 'Property 3rd Image View' },
                { key: 'photo_4', label: 'Property Floor Plan' },
            ];
        },

        businessTypes()
        {
            return [
                "Office Space","Retail Shop","Restaurant","Warehouse","Industrial",
                "Co-working","Hotel","Clinic","House","Apartment","Townhouse",
                "Studio","Land","Commercial","Parking Space"
            ];
        },

        barangays()
        {
            return [
                "Aranguren","Bueno","Cristo Rey","Cubcub","Cutcut I","Cutcut II",
                "Dolores","Estrada","Lawy","Manga","Manlapig","Maruglu",
                "O'Donnell","Sta. Juliana","Sta. Lucia","Sta. Rita",
                "Sto. Domingo I","Sto. Domingo II","Sto. Rosario","Talaga"
            ];
        }
    },

    methods:
    {
        getPhotoUrl(key)
        {
            if (!this.form[key]) return '';
            return this.form[key] instanceof File
                ? URL.createObjectURL(this.form[key])
                : `${process.env.VUE_APP_API_URL}/storage/${this.form[key]}`;
        },

        handleBusinessTypeSelect(event)
        {
            const value = event.target.value;

            if (!Array.isArray(this.form.property_type))
            {
                this.form.property_type = [];
            }

            if (this.form.property_type.includes(value))
            {
                this.form.property_type = this.form.property_type.filter(type => type !== value);
            }
            else
            {
                if (this.form.property_type.length >= 3)
                {
                    alert("You can only select up to 3 business types.");
                    event.target.value = "";
                    return;
                }
                this.form.property_type.push(value);
            }

            event.target.value = "";
        },

        handleFileUpload(event, key)
        {
            const file = event.target.files[0];
            this.form[key] = file || null;
        },

        clearFile(key, event)
        {
            this.form[key] = null;
            event.target.closest('.position-relative').querySelector('input[type=file]').value = null;
        }
    }
};
</script>

<style scoped>
.image-preview
{
    width: 120px;
    height: 80px;
    background-color: #f8f9fa;
    border: 1px solid #dee2e6;
    overflow: hidden;
}
.is-invalid
{
    border-color: #dc3545;
}
.invalid-feedback
{
    color: #dc3545;
    font-size: 0.875rem;
    margin-top: 0.25rem;
}
</style>
