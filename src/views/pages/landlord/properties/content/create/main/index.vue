<template>
    <form @submit.prevent="submit()">

        <div class="row mt-3">

            <div class="col-md-7">
                <div class="card card-body card-white rounded-0 p-4">
                    <primary-component :errors="errors" />
                </div>

                <div class="card card-body card-white rounded-0 p-4 mt-3">
                    <schedule-component :errors="errors" />
                </div>
            </div>

            <div class="col-md-5">
                <location-component :errors="errors" />
            </div>

        </div>

        <div class="text-end mt-3">
            <router-link
                :to="'/landlord/properties'"
                class="btn rounded-0 btn-secondary me-3">
                Cancel
            </router-link>

            <button
                type="submit"
                class="btn rounded-0 button-color"
                :disabled="isLoading">
                <span v-if="isLoading">Submitting...</span>
                <span v-else>Submit</span>
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
    name: "CreatePropertyForm",

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
                property_type: [],
                photo_1: "",
                photo_2: "",
                photo_3: "",
                photo_4: "",
                floor_plan: "",
                size: "",
                search_address: "",
                schedules: [],
                landmarks: []
            },
            errors: {},
            searchAddress: "",
            isLoading: false,
            map: null,
            marker: null,
            selectedLocation: null
        };
    },

    created()
    {
        this.toast = useToast();
    },

    methods:
    {
        
        async submit()
        {
            this.isLoading = true;
            this.errors = {};

            try
            {
                const formData = new FormData();

                for (const key in this.form)
                {
                    if ((key === "photo_1" ||
                        key === "photo_2" ||
                        key === "photo_3" ||
                        key === "photo_4" ||
                        key === "floor_plan") &&
                        this.form[key])
                    {
                        formData.append(key, this.form[key]);
                    }
                    else if (key === "schedules")
                    {
                        formData.append("schedules", JSON.stringify(this.form.schedules));
                    }
                    else if (key === "landmarks")
                    {
                        formData.append("landmarks", JSON.stringify(this.form.landmarks));
                    }
                    else
                    {
                        formData.append(key, this.form[key]);
                    }
                }

                const response = await apiClient.post(`/properties`, formData);
                console.log("Created data successfully:", response.data);

                this.$router.push("/landlord/properties");
                this.toast.success("Property created successfully!");
            }
            catch (error)
            {
                const status = error.response?.status;
                const responseErrors = error.response?.data?.errors || {};
                const message = error.response?.data?.message || "Update failed";

                if (status === 422)  // Laravel validation errors
                {
                    const formattedErrors = {};
                    for (const key in responseErrors)
                    {
                        // Take the first message and make it friendly
                        formattedErrors[key] = responseErrors[key][0]
                            .replace("The ", "")
                            .replace(" field is required.", " is required");
                    }
                    this.errors = formattedErrors;

                    this.toast.error("Validation failed. Check your inputs.");
                    console.error("Validation errors:", formattedErrors);
                }
                else if (status === 401)
                {
                    this.toast.error("Unauthorized. Please login.");
                }
                else if (status === 403)
                {
                    this.toast.error("Forbidden. You cannot perform this action.");
                }
                else
                {
                    this.toast.error(message);
                }

                console.error("Submission failed:", message);
            }
            finally
            {
                this.isLoading = false;
            }
        },

        deleteSchedule(schedule)
        {
            const index = this.form.schedules.indexOf(schedule);
            if (index !== -1)
            {
                this.form.schedules.splice(index, 1);
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

.image-upload-dropzone
{
    cursor: pointer;
    border-style: dashed;
    color: #6c757d;
    user-select: none;
}

.image-upload-dropzone:hover
{
    background-color: #f8f9fa;
}
</style>