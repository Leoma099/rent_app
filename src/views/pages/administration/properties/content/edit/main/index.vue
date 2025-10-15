<template>

    <div v-if="isLoading" class="loading-overlay">
        <div class="spinner"></div>
    </div>

    <form @submit.prevent="submit()">

        <div class="row mt-3">

            <div class="col-md-7">
                <div class="card card-body card-white rounded-0 p-4">
                    <primary-component />
                </div>
            </div>

            <div class="col-md-5">
                <div class="card card-body card-white rounded-0 p-4">
                    <location-component />
                </div>
            </div>

        </div>

        <div class="text-end">
            <router-link :to="'/landlord/properties'"
                class="btn rounded-0 btn-secondary me-3">Cancel
            </router-link>
            <button
                type="submit"
                class="btn rounded-0 button-color">
                <span v-if="!isLoading">Submit</span>
                <span v-else>Submitting...</span>
            </button>
        </div>

    </form>

    <map-modal />

</template>

<script>
import apiClient from '@/services';
import { useToast } from "vue-toastification";

import PrimaryComponent from "./content/primary.vue";
import LocationComponent from "./content/location.vue";
export default
{
    data()
    {
        return {
            form:
            {
                title: "",
                description: "",
                address: "",
                lat: "",
                lng: "",
                price: "",
                property_type: "",
                photo: "",
                floor_plan: "",
                size: "",
                search_address: "",
            },
            searchAddress: "",
            isLoading: false,
            map: null,
            marker: null,
            selectedLocation: null
        };
    },

    created()
    {
        this.loadData();
        this.toast = useToast();
    },

    components:
    {
        PrimaryComponent,
        LocationComponent
    },

    methods:
    {
        browseFiles()
        {
            this.$refs.fileInput.click();
        },
        handleFileChange(event)
        {
            const file = event.target.files[0];
            if (file && file.type.startsWith("image/")) {
            this.form.photo = file;
            this.createImagePreview(file);
            } else {
            alert("Please select a valid image file.");
            }
        },
        handleDrop(event)
        {
            const file = event.dataTransfer.files[0];
            if (file && file.type.startsWith("image/")) {
            this.form.photo = file;
            this.createImagePreview(file);
            } else {
            alert("Please drop a valid image file.");
            }
        },
        createImagePreview(file)
        {
            const reader = new FileReader();
            reader.onload = e => {
            this.imagePreview = e.target.result;
            };
            reader.readAsDataURL(file);
        },
        removeImage()
        {
            this.form.photo = null;
            this.imagePreview = null;
            this.$refs.fileInput.value = null;
        },
        async submit()
        {
            this.isLoading = true;
            try
            {
                const formData = new FormData();

                if (this.form.photo) {
                    formData.append("photo", this.form.photo);
                }

                formData.append("title", this.form.title);
                formData.append("address", this.form.address);
                formData.append("landmarks", this.form.landmarks);
                formData.append("description", this.form.description);
                formData.append("property_cost", this.form.property_cost);
                formData.append("size", this.form.size);
                formData.append("units", this.form.units);
                formData.append("floor", this.form.floor);
                formData.append("status", this.form.status);
                formData.append("lat", this.form.lat);
                formData.append("lng", this.form.lng);
                const response = await apiClient.put(`/properties/${this.$route.params.id}`, formData, {});
                console.log("Created data successfully:", response.data);
                setTimeout(() => {
                    this.$router.push("/administration/properties");
                }, 1000);

                this.toast.success("Update successfully!");
            }
            catch (error)
            {
                this.isLoading = false;

                const status = error.response?.status;
                const message = error.response?.data?.error || "Update failed";

                if (status === 401)
                {
                    this.toast.error("Updated unsuccessfully.");
                }
                else if (status === 403)
                {
                    this.toast.error("Something wrong.");
                }
                else
                {
                    this.toast.error("Update unsuccessful! Please try again.");
                }

                console.error('Update failed:', message);
            }

            finally
            {
                this.isLoading = false;
            }
        },

        async loadData()
        {
            try
            {
                const response = await apiClient.get(`/properties/${this.$route.params.id}`);
                this.form = {
                    ...this.form,
                    ...response.data
                };

                if (response.data.photo) {
                    this.imagePreview = `http://127.0.0.1:8000/storage/${response.data.photo}`;
                }
            }
            catch(error)
            {
                console.error("Error occured:", error);
            }
        }
    }
}
</script>

<style scoped>
.button-color {
    background-color: #007bff;
    color: #ffffff;
}

.button-color:hover {
    background-color: #3798ff;
    color: #ffffff;
}
</style>