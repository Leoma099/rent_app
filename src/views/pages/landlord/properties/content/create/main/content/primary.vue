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
        <textarea
            rows="10"
            class="form-control rounded-0"
            v-model="form.description"></textarea>
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
        <label class="form-label">* Business Type:</label>
        <input
            type="text"
            class="form-control rounded-0"
            :value="Array.isArray(form.property_type) ? form.property_type.join(', ') : ''"
            readonly>

        <select
            class="form-select rounded-0 mt-3"
            @change="handleBusinessTypeSelect">
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

    <div class="mt-3">
        <div class="row">
            <div class="col-md-6">
                <label class="form-label">* Price:</label>
                <input
                    type="number"
                    placeholder="ex. 25000"
                    class="form-control rounded-0"
                    v-model="form.price">
            </div>
            <div class="col-md-6">
                <label class="form-label">* Square Meter:</label>
                <input
                    type="number"
                    placeholder="ex. 25"
                    class="form-control rounded-0"
                    v-model="form.size">
            </div>
        </div>
    </div>

    <!-- Property Image Views -->
     <div class="mt-3">

        <!-- Property Image View 1 -->
        <div class="mb-3">
            <div class="d-flex gap-3">
                <!-- Preview -->
                <div class="image-preview rounded-3 border d-flex align-items-center justify-content-center">
                    <img v-if="photo1Url" :src="photo1Url" class="img-fluid rounded" alt="First View">
                    <span v-else class="text-muted small">No image</span>
                </div>
                <!-- Input -->
                <div class="w-100">
                    <div class="form-label">* Property 1st Image View:</div>
                    <div class="position-relative">
                        <input type="file" class="form-control rounded-3 shadow-sm" @change="uploadFirstImage">
                        <span
                            v-if="form.photo_1"
                            class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold"
                            style="cursor: pointer; font-size: 1.25rem; line-height: 1;"
                            @click.prevent="
                                form.photo_1 = null;
                                $event.target.closest('.position-relative').querySelector('input[type=file]').value = null;
                            ">
                            <i class="text-danger bx bx-x"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Property Image View 2 -->
        <div class="mb-3">
            <div class="d-flex gap-3">
                <div class="image-preview rounded-3 border d-flex align-items-center justify-content-center">
                    <img v-if="photo2Url" :src="photo2Url" class="img-fluid rounded" alt="Second View">
                    <span v-else class="text-muted small">No image</span>
                </div>
                <div class="w-100">
                    <div class="form-label">* Property 2nd Image View:</div>
                    <div class="position-relative">
                        <input type="file" class="form-control rounded-3 shadow-sm" @change="uploadSecondImage">
                        <span
                            v-if="form.photo_2"
                            class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold"
                            style="cursor: pointer; font-size: 1.25rem; line-height: 1;"
                            @click.prevent="
                                form.photo_2 = null;
                                $event.target.closest('.position-relative').querySelector('input[type=file]').value = null;
                            ">
                            <i class="text-danger bx bx-x"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Property Image View 3 -->
        <div class="mb-3">
            <div class="d-flex gap-3">
                <div class="image-preview rounded-3 border d-flex align-items-center justify-content-center">
                    <img v-if="photo3Url" :src="photo3Url" class="img-fluid rounded" alt="Third View">
                    <span v-else class="text-muted small">No image</span>
                </div>
                <div class="w-100">
                    <div class="form-label">* Property 3rd Image View:</div>
                    <div class="position-relative">
                        <input type="file" class="form-control rounded-3 shadow-sm" @change="uploadThirdImage">
                        <span
                            v-if="form.photo_3"
                            class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold"
                            style="cursor: pointer; font-size: 1.25rem; line-height: 1;"
                            @click.prevent="
                                form.photo_3 = null;
                                $event.target.closest('.position-relative').querySelector('input[type=file]').value = null;
                            ">
                            <i class="text-danger bx bx-x"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Property Image View 4 -->
        <div class="mb-3">
            <div class="d-flex gap-3">
                <div class="image-preview rounded-3 border d-flex align-items-center justify-content-center">
                    <img v-if="photo4Url" :src="photo4Url" class="img-fluid rounded" alt="Fourth View">
                    <span v-else class="text-muted small">No image</span>
                </div>
                <div class="w-100">
                    <div class="form-label">* Property 4th Image View:</div>
                    <div class="position-relative">
                        <input type="file" class="form-control rounded-3 shadow-sm" @change="uploadFourthImage">
                        <span
                            v-if="form.photo_4"
                            class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold"
                            style="cursor: pointer; font-size: 1.25rem; line-height: 1;"
                            @click.prevent="
                                form.photo_4 = null;
                                $event.target.closest('.position-relative').querySelector('input[type=file]').value = null;
                            ">
                            <i class="text-danger bx bx-x"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Property Floor Plan Image -->
        <div class="mb-3">
            <div class="d-flex gap-3">
                <div class="image-preview rounded-3 border d-flex align-items-center justify-content-center">
                    <img v-if="floorPlanUrl" :src="floorPlanUrl" class="img-fluid rounded" alt="Floor Plan">
                    <span v-else class="text-muted small">No image</span>
                </div>
                <div class="w-100">
                    <div class="form-label">* Property Floor Plan Image:</div>
                    <div class="position-relative">
                        <input type="file" class="form-control rounded-3 shadow-sm" @change="handleFloorPlanUpload">
                        <span
                            v-if="form.floor_plan"
                            class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold"
                            style="cursor: pointer; font-size: 1.25rem; line-height: 1;"
                            @click.prevent="
                                form.floor_plan = null;
                                $event.target.closest('.position-relative').querySelector('input[type=file]').value = null;
                            ">
                            <i class="text-danger bx bx-x"></i>
                        </span>
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
        photo1Url() {
            if (!this.form.photo_1) return '';
            return this.form.photo_1 instanceof File
                ? URL.createObjectURL(this.form.photo_1)
                : `https://floralwhite-butterfly-259901.hostingersite.com/${this.form.photo_1}`;
        },
        photo2Url() {
            if (!this.form.photo_2) return '';
            return this.form.photo_2 instanceof File
                ? URL.createObjectURL(this.form.photo_2)
                : `https://floralwhite-butterfly-259901.hostingersite.com/${this.form.photo_2}`;
        },
        photo3Url() {
            if (!this.form.photo_3) return '';
            return this.form.photo_3 instanceof File
                ? URL.createObjectURL(this.form.photo_3)
                : `https://floralwhite-butterfly-259901.hostingersite.com/${this.form.photo_3}`;
        },
        photo4Url() {
            if (!this.form.photo_4) return '';
            return this.form.photo_4 instanceof File
                ? URL.createObjectURL(this.form.photo_4)
                : `https://floralwhite-butterfly-259901.hostingersite.com/${this.form.photo_4}`;
        },
        floorPlanUrl() {
            if (!this.form.floor_plan) return '';
            return this.form.floor_plan instanceof File
                ? URL.createObjectURL(this.form.floor_plan)
                : `https://floralwhite-butterfly-259901.hostingersite.com/${this.form.floor_plan}`;
        }

    },

    props:
    {
        selectedDisplay:
        {
            type: String,
            default: ''
        }
    },

    methods:
    {
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

        uploadFirstImage(event)
        {
            const file = event.target.files[0];
            this.form.photo_1 = file || null;
        },

        uploadSecondImage(event)
        {
            const file = event.target.files[0];
            this.form.photo_2 = file || null;
        },

        uploadThirdImage(event)
        {
            const file = event.target.files[0];
            this.form.photo_3 = file || null;
        },

        uploadFourthImage(event)
        {
            const file = event.target.files[0];
            this.form.photo_4 = file || null;
        },

        handleFloorPlanUpload(event)
        {
            const file = event.target.files[0];
            this.form.floor_plan = file || null;
        }
    }
}
</script>

<style scoped>
.image-preview {
    width: 120px;
    height: 80px;
    background-color: #f8f9fa;
    border: 1px solid #dee2e6;
}
</style>
