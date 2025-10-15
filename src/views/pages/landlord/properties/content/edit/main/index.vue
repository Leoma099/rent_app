<template>
    <form @submit.prevent="submit()">
        <div class="row mt-3">
            <div class="col-md-7">
                <div class="card card-body card-white rounded-0 p-4">
                    <primary-component />
                </div>
                <div class="card card-body card-white rounded-0 p-4 mt-3">
                    <schedule-component />
                </div>
            </div>

            <div class="col-md-5">
                <location-component />
            </div>
        </div>

        <div class="text-end mt-3">
            <router-link
                :to="'/landlord/properties'"
                class="btn rounded-0 btn-secondary me-3"
            >
                Cancel
            </router-link>
            <button type="submit" class="btn rounded-0 button-color" :disabled="isLoading">
                <span v-if="isLoading" class="spinner-border spinner-border-sm me-2"></span>
                Submit
            </button>
        </div>
    </form>
</template>

<script>
import apiClient from "@/services/index";
import { useToast } from "vue-toastification";
import PrimaryComponent from "./content/primary.vue";
import LocationComponent from "./content/location.vue";
import ScheduleComponent from "./content/schedule/index.vue";

export default
{
    components:
    {
        PrimaryComponent,
        LocationComponent,
        ScheduleComponent
    },

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
                propertyStats: "",
                landmarks: [],
                schedules: []
            },
            isLoading: false
        };
    },

    created()
    {
        this.toast = useToast();
        this.loadData();
    },

    methods:
    {
        async loadData()
        {
            try
            {
                const response = await apiClient.get(`/properties/${this.$route.params.id}`);
                const property = response.data;

                // Assign loaded property data to form
                this.form =
                {
                    ...this.form,
                    ...property,
                    schedules: property.schedules || [],
                    landmarks: property.landmarks || []
                };
            }
            catch (error)
            {
                console.error("Failed to load property:", error);
                this.toast.error("Failed to load property details.");
            }
        },

        async submit()
        {
            this.isLoading = true;

            try
            {
                const formData = new FormData();

                // ✅ If user selected a new photo/floor plan file
                if (this.form.photo instanceof File) {
                    formData.append("photo", this.form.photo);
                }

                if (this.form.floor_plan instanceof File) {
                    formData.append("floor_plan", this.form.floor_plan);
                }

                // ✅ Add all other fields
                formData.append("title", this.form.title);
                formData.append("description", this.form.description);
                formData.append("address", this.form.address);
                formData.append("lat", this.form.lat);
                formData.append("lng", this.form.lng);
                formData.append("price", this.form.price);
                formData.append("property_type", this.form.property_type);
                formData.append("size", this.form.size);
                formData.append("propertyStats", this.form.propertyStats); // must match Laravel
                formData.append("status", this.form.status);
                formData.append("is_featured", this.form.is_featured);

                // ✅ Add JSON fields
                formData.append("schedules", JSON.stringify(this.form.schedules));
                formData.append("landmarks", JSON.stringify(this.form.landmarks));

                // ✅ Ensure PUT request is recognized by Laravel
                formData.append("_method", "PUT");

                // Send request
                const response = await apiClient.post(
                    `/properties/${this.$route.params.id}`,
                    formData,
                    {
                        headers: {
                            "Content-Type": "multipart/form-data"
                        }
                    }
                );

                this.toast.success("Property updated successfully!");
                this.$router.push("/landlord/properties");
                console.log("Update successfully:", response.data);
            }
            catch (error)
            {
                console.error("Failed to update property:", error);
                const message = error.response?.data?.message || "Update failed";
                this.toast.error(message);
            }
            finally
            {
                this.isLoading = false;
            }
        }
    }
};
</script>

<style scoped>
.button-color
{
    background-color: #007bff;
    color: #ffffff;
}

.button-color:hover
{
    background-color: #3798ff;
    color: #ffffff;
}
</style>
