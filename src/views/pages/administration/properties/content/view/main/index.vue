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

        <!-- <div class="text-end mt-3">
            <router-link
                :to="'/landlord/properties'"
                class="btn rounded-0 btn-secondary me-3"
            >
                Cancel
            </router-link>
            <button type="submit" class="btn rounded-0 button-color" :disabled="isLoading">
                <span v-if="isLoading">Submitting...</span>
                <span v-else>Submit</span>
            </button>
        </div> -->
    </form>
</template>

<script>
import apiClient from "@/services/index"
import { useToast } from "vue-toastification"
import PrimaryComponent from "./content/primary.vue"
import LocationComponent from "./content/location.vue"
import ScheduleComponent from "./content/schedule/index.vue"

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
                lat: null,
                lng: null,
                price: "",
                property_type: [],
                photo_1: "",
                photo_2: "",
                photo_3: "",
                photo_4: "",
                floor_plan: "",
                size: "",
                propertyStats: "",
                landmarks: [],
                schedules: [],
                status: "",
                is_featured: ""
            },
            isLoading: false
        }
    },

    created()
    {
        this.toast = useToast()
        this.loadData()
    },

    methods:
    {
        async loadData()
        {
            try
            {
                const response = await apiClient.get(`/admin/property/${this.$route.params.id}`)
                const property = response.data
                this.form =
                {
                    ...this.form,
                    ...property,
                    lat: parseFloat(property.lat) || null,
                    lng: parseFloat(property.lng) || null,
                    property_type: Array.isArray(property.property_type)
                        ? property.property_type
                        : property.property_type?.split(',') || [],
                    schedules: property.schedules || [],
                    landmarks: property.landmarks || []
                }
            }
            catch (error)
            {
                console.error("Failed to load property:", error)
                this.toast.error("Failed to load property details.")
            }
        },

        async submit()
        {
            this.isLoading = true

            try
            {
                const formData = new FormData()

                if (this.form.photo_1 instanceof File)
                {
                    formData.append("photo_1", this.form.photo_1)
                }
                if (this.form.photo_2 instanceof File)
                {
                    formData.append("photo_2", this.form.photo_2)
                }
                if (this.form.photo_3 instanceof File)
                {
                    formData.append("photo_3", this.form.photo_3)
                }
                if (this.form.photo_4 instanceof File)
                {
                    formData.append("photo_4", this.form.photo_4)
                }
                if (this.form.floor_plan instanceof File)
                {
                    formData.append("floor_plan", this.form.floor_plan)
                }

                for (const key in this.form)
                {
                    if (!["photo_1","photo_2","photo_3","photo_4","floor_plan","schedules","landmarks"].includes(key))
                    {
                        formData.append(key, this.form[key])
                    }
                }

                formData.append("schedules", JSON.stringify(this.form.schedules))
                formData.append("landmarks", JSON.stringify(this.form.landmarks))
                formData.append("_method", "PUT")

                const response = await apiClient.post(
                    `/properties/${this.$route.params.id}`,
                    formData,
                    {
                        headers:
                        {
                            "Content-Type": "multipart/form-data"
                        }
                    }
                )

                this.toast.success("Property updated successfully!")
                this.$router.push("/landlord/properties")
                console.log("Update successfully:", response.data)
            }
            catch (error)
            {
                console.error("Failed to update property:", error)
                const message = error.response?.data?.message || "Update failed"
                this.toast.error(message)
            }
            finally
            {
                this.isLoading = false
            }
        },

        async deleteItem(scheduleId)
        {
            try
            {
                const response = await apiClient.delete(`/schedule/${scheduleId}`);
                this.form.schedules = this.form.schedules.filter(s => s.id !== scheduleId);
                console.log(response);
            }
            catch(error)
            {
                console.error(error);
            }
        }
    }
}
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
