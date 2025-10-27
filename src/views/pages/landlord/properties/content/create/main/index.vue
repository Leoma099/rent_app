<template>

    <form @submit.prevent="submit()">

        <div class="row mt-3">

            <div class="col-md-7">
                <div class="card card-body card-white rounded-0 p-4">
                    <primary-component />
                </div>
                <div class="card card-body card-white rounded-0 p-4 mt-3">
                    <schedule-componet/>
                </div>
            </div>

            <div class="col-md-5">
                <location-component />
            </div>

        </div>

        <div class="text-end mt-3">
            <router-link :to="'/landlord/properties'"
                class="btn rounded-0 btn-secondary me-3">Cancel
            </router-link>
            <button type="submit" class="btn rounded-0 button-color">
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
import ScheduleComponet from "./content/schedule/index.vue";
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
                property_type: [],
                photo_1: "",
                photo_2: "",
                photo_3: "",
                photo_4: "",
                floor_plan: "",
                size: "",
                search_address: "",
                schedules: [],
                landmarks: [],
            },
            searchAddress: "",
            isLoading: false,
            map: null,
            marker: null,
            selectedLocation: null
        };
    },

    components:
    {
        PrimaryComponent,
        LocationComponent,
        ScheduleComponet
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

            try
            {   
                const formData = new FormData();

                for (const key in this.form)
                {
                    if ((key === "photo_1" || key === "photo_2" || key === "photo_3" || key === "photo_4" || key === "floor_plan") && this.form[key])
                    {
                        formData.append(key, this.form[key]);
                    }
                    else if(key === "schedules")
                    {
                        formData.append("schedules", JSON.stringify(this.form.schedules));
                    }
                    else if(key === "landmarks")
                    {
                        formData.append("landmarks", JSON.stringify(this.form.landmarks));
                    }
                    else
                    {
                        formData.append(key, this.form[key]);
                    }
                }

                const response = await apiClient.post(`/properties`, formData, {
                    headers: { "Content-Type": "multipart/form-data" }
                });

                console.log("Created data successfully:", response.data);
                this.$router.push("/landlord/properties");

                this.toast.success("Update successfully!");
            }
            catch (error)
            {
                const status = error.response?.status;
                const message = error.response?.data?.errors || error.response?.data?.message || "Update failed";

                if (status === 401) {
                    this.toast.error("Unauthorized. Please login.");
                } else if (status === 403) {
                    this.toast.error("Forbidden. You cannot perform this action.");
                } else if (status === 422) {
                    // Laravel validation errors
                    console.error("Validation errors:", message);
                    this.toast.error("Validation failed. Check your inputs.");
                } else {
                    this.toast.error("Failed to create property. Please try again.");
                }

                console.error("Submission failed:", message);
            }

            finally
            {
                this.isLoading = false;
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

.image-upload-dropzone {
  cursor: pointer;
  border-style: dashed;
  color: #6c757d;
  user-select: none;
}
.image-upload-dropzone:hover {
  background-color: #f8f9fa;
}
</style>