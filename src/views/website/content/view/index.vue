<template>
    <div v-if="showSplash" class="splashscreen">
        <div class="splash-content">
            <img src="@/assets/images/capas_logo.png" alt="Logo" class="splash-logo" />
            <h2>Loading...</h2>
        </div>
    </div>
    <div class="container my-5" v-else :key="$route.fullPath">

        <header-component />

        <div class="row mt-3">
            <div class="col-md-8">
                <div class="card card-body rounded-0 card-white shadow-sm">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h1 class="mb-0">{{ property.title }}</h1>
                            <small><i class="bx bx-pin"></i> {{ property.address }}</small>
                        </div>

                        <div class="text-end">
                            <div v-if="!isLoggedIn">
                                <router-link
                                    :to="`/signin`"
                                    class="btn btn-secondary rounded-0 d-inline-flex align-items-center">
                                    <i class="bx bx-bookmark me-2"></i>
                                    <span>Save</span>
                                </router-link>
                            </div>
                            <div v-else>
                                <button
                                    v-if="!isSaved"
                                    type="button"
                                    class="btn btn-secondary rounded-0 d-inline-flex align-items-center"
                                    @click="saveProperty">
                                    <i class="bx bx-bookmark me-2"></i>
                                    <span>Save</span>
                                </button>
                                <button
                                    v-else
                                    type="button"
                                    class="btn btn-danger rounded-0 d-inline-flex align-items-center"
                                    @click="unsaveProperty">
                                    <i class="bx bxs-bookmark me-2"></i>
                                    <span>Unsave</span>
                                </button>
                            </div>

                            <p class="mb-0 mt-2"><strong>{{ formatPrice(property.price) }}</strong> /month</p>
                        </div>
                    </div>

                    <img
                        :src="getPhotoUrl(property.photo)"
                        :alt="property.property_name"
                        class="img-fluid rounded shadow-sm card-img-top mt-3"
                        style="height: 30rem; object-fit: cover;"
                    />

                    <hr />

                    <div>
                        <div>
                            <p>
                                <strong>Description:</strong>
                                <br />{{ property.description }}
                                <br />{{ property.units }} {{ property.floor }}
                            </p>
                        </div>

                        <hr />

                        <!-- Nearby Area -->
                        <div class="mt-3">
                            <map-location-component
                                v-if="property"
                                :property="property"
                                :businessTypes="businessTypes"
                            />
                        </div>

                        <hr />

                        <!-- Floor Plan -->
                        <div class="mt-3">
                            <h3 class="mb-0">Floor Plan</h3>
                            <img
                                :src="getFloorPlanUrl(property.floor_plan)"
                                :alt="property.title"
                                class="img-fluid card-img-top"
                                style="height: 100%; object-fit: cover;"
                            />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="col-md-4">
                <div class="card card-body rounded-0 card-white shadow-sm">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p>Listing provided by: <strong>{{ property.landlord.account.full_name }}</strong></p>
                        </div>
                    </div>

                    <div class="mt-3">
                        <h5 class="mb-0">Contact landlord</h5>
                        <p class="mb-0">Email: <strong>{{ property.landlord.account.email }}</strong></p>
                        <p class="mb-0">Mobile number: <strong>+63-999-123-4567</strong></p>
                    </div>

                    <form @submit.prevent="submit()">
                        <div class="mt-3">
                            <label class="form-label">* Message:</label>
                            <textarea
                                v-model="form.message"
                                rows="5"
                                class="form-control rounded-0"
                                placeholder="I'm interested..."></textarea>
                        </div>

                        <div class="mt-3" v-if="!isLoggedIn">
                            <router-link
                                :to="`/signin`"
                                class="btn btn-primary w-100 rounded-0">
                                Send Message
                            </router-link>
                        </div>
                        <div class="mt-3" v-else>
                            <button
                                type="submit"
                                class="btn btn-primary w-100 rounded-0">
                                Send Message
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Available Schedules -->
                <form @submit.prevent="bookSched()">

                    <div class="card card-body card-white rounded-0 shadow-sm mt-3">
                        <p class="mb-0"><strong>Available Schedule</strong></p>

                        <div class="mt-3" v-if="property.schedules && property.schedules.length">
                            <div v-for="schedule in property.schedules" :key="schedule.id" class="form-check">
                                <input
                                    class="form-check-input"
                                    type="radio"
                                    :value="schedule.id"
                                    v-model="bookForm.sched"
                                    :disabled="schedule.is_booked"
                                />
                                <label class="form-check-label">
                                    {{ schedule.available_day }} ({{ formatTime(schedule.start_time) }} - {{ formatTime(schedule.end_time) }})
                                    <span v-if="schedule.is_booked" class="badge bg-secondary ms-2">Booked</span>
                                </label>

                            </div>
                        </div>

                        <div class="mt-3" v-if="!isLoggedIn">
                            <router-link
                                :to="`/signin`"
                                class="btn btn-primary rounded-0 w-100">
                                Book Schedule
                            </router-link>
                        </div>
                        <div class="mt-3" v-else>
                            <button
                                type="submit"
                                class="btn btn-primary rounded-0 w-100">
                                Book Schedule
                            </button>
                        </div>
                    </div>

                </form>
            </div>
        </div>
        <recommended-component :propertyId="property.id"/>
    </div>
</template>

<script>
import apiClient from "@/services";
import { useToast } from "vue-toastification";

import HeaderComponent from "./content/header.vue";
import RecommendedComponent from "./content/recommended.vue";
import MapLocationComponent from "./content/map-location.vue";

// ICONS
import restaurantIcon from "@/assets/icons/restaurant.png";
import convienceIcon from "@/assets/icons/convenience-store.png";
import supermarketIcon from "@/assets/icons/supermarkets.png";
import bankIcon from "@/assets/icons/bank.png";
import atmIcon from "@/assets/icons/atm-machine.png";
import hospitalIcon from "@/assets/icons/hospital.png";
import schoolIcon from "@/assets/icons/school.png";
import gymIcon from "@/assets/icons/gym.png";
import parkIcon from "@/assets/icons/park.png";
import hotelIcon from "@/assets/icons/hotel.png";
export default {
    name: "CommercialHubView",

    data()
    {
        return {
            property: null,
            selectedScheduleId: null,
            businessTypes: {
                restaurant: { name: "Restaurant", icon: restaurantIcon },
                convenience_store: { name: "Convenience Store", icon: convienceIcon },
                supermarket: { name: "Supermarket", icon: supermarketIcon },
                bank: { name: "Bank", icon: bankIcon },
                atm: { name: "ATM", icon: atmIcon },
                hospital: { name: "Hospital", icon: hospitalIcon },
                school: { name: "School", icon: schoolIcon },
                gym: { name: "Gym", icon: gymIcon },
                park: { name: "Park", icon: parkIcon },
                hotel: { name: "Hotel", icon: hotelIcon }
            },
            form:
            {
                message: ""
            },
            bookForm:
            {
                sched: "",
            },
            isSaved: false,
            showSplash: true // added splashscreen state
        };
    },

    components:
    {
        HeaderComponent,
        RecommendedComponent,
        MapLocationComponent
    },

    created()
    {
        this.loadProperty();
        this.toast = useToast();
        
        // simulate splash load for 1.5 seconds
        setTimeout(() =>
        {
            this.showSplash = false;
        }, 1500);
    },

    computed:
    {

        isLoggedIn()
        {
            // Example: check localStorage token or user object
            return !!localStorage.getItem("access_token"); 
            // Or: return this.$store.state.user != null;
        }
    },

    watch:
    {
        '$route.params.id':
        {
            immediate: false,
            handler(newId)
            {
                this.loadProperty(newId);
            }
        },

        selectedBusinessType()
        {
            this.showBusinessMarkers();
        }
    },

    methods:
    {
        formatPrice(price)
        {
            if(!price) return "₱0.00";

            return new Intl.NumberFormat('en-PH', {
                style: 'currency',
                currency: 'PHP',
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(price);
        },

        async checkIfSaved()
        {
            try
            {
                const response = await apiClient.get(`/saved-properties`);
                this.isSaved = response.data.some(p => p.property_id === this.property?.id);
            }
            catch (error)
            {
                console.error("Error checking saved property:", error);
            }
        },

        async saveProperty()
        {
            try
            {
                await apiClient.post(`/saved-properties`, { property_id: this.property.id });
                this.isSaved = true;
                if (this.toast) this.toast.success("Property saved!");
            }
            catch (error)
            {
                console.error("Save property error:", error);
                if (this.toast) this.toast.error("Failed to save property.");
            }
        },

        async unsaveProperty()
        {
            try
            {
                await apiClient.delete(`/saved-properties/${this.$route.params.id}`);
                this.isSaved = false;
                if (this.toast) this.toast.success("Property removed from saved!");
            }
            catch (error)
            {
                console.error("Unsave property error:", error);
                if (this.toast) this.toast.error("Failed to unsave property.");
            }
        },

        isScheduleDisabled(schedule)
        {
            // 🔹 disable if already booked OR if user has selected it
            if (this.selectedScheduleId === schedule.id) {
                return true;
            }

            // 🔹 disable if schedule.status is pending/approved
            return [0,1].includes(schedule.status);
        },

        async bookSched()
        {
            // simple guard
            if (!this.bookForm.sched)
            {
                alert("Please select a schedule before booking.");
                return;
            }

            // optional UI lock to prevent double-submit
            this.isBooking = true;

            try
            {
                const payload =
                {
                    property_id: this.property.id,
                    landlord_id: this.property.landlord.id,   // correct reference from your JSON
                    schedule_id: Number(this.bookForm.sched) // send a number (backend usually expects integer)
                };

                const response = await apiClient.post("/bookings", payload);

                console.log("Book success:", response.data);

                // --- Update UI: mark selected schedule as booked/disabled locally ---
                const schedId = Number(this.bookForm.sched);
                const idx = this.property.schedules.findIndex(function (s)
                {
                    return s.id === schedId;
                });

                if (idx !== -1)
                {
                    // add a flag so your template can disable that option
                    this.$set
                        ? this.$set(this.property.schedules[idx], "booked", true) // if you use Vue.set (Vue2 style)
                        : (this.property.schedules[idx].booked = true);           // Vue3: direct assignment works
                }

                // reset selection
                this.selectedScheduleId = null;
                this.bookForm.sched = "";

                // toast if available
                if (this.toast && typeof this.toast.success === "function")
                {
                    this.toast.success("Booked successfully!");
                }
                await this.loadProperty();
            }
            catch (error)
            {
                console.error("Booking error:", error);

                if (this.toast && typeof this.toast.error === "function")
                {
                    this.toast.error("Something went wrong!");
                }
                else
                {
                    alert("Something went wrong while booking.");
                }
            }
            finally
            {
                this.isBooking = false;
            }
        },

        toggleSchedule(id)
        {
            if (this.selectedScheduleId === id) {
                this.selectedScheduleId = null;
            } else {
                this.selectedScheduleId = id;
            }
        },

        formatTime(time)
        {
            if (!time) return "";
            const date = new Date(`1970-01-01T${time}Z`);
            return date.toLocaleTimeString([], {
                hour: "2-digit",
                minute: "2-digit",
                hour12: true
            });
        },

        async loadProperty()
        {
            try
            {
                const id = this.$route.params.id;
                const response = await apiClient.get(`/commercialhub/properties/${id}`);
                this.property = response.data;

                this.property.landmarksSummary = [];
                this.property.landmarks = [];

                this.checkIfSaved();
            }
            catch (error)
            {
                console.error("Error loading property:", error);
            }
        },

        getPhotoUrl(photoPath)
        {
            if (!photoPath) return "/default-avatar.png";
            if (photoPath.startsWith("http")) return photoPath;
            return `http://api.rent-app.loc/storage/${photoPath}`;
        },

        getFloorPlanUrl(floorPlanPath)
        {
            if (!floorPlanPath) return "/default-avatar.png";
            if (floorPlanPath.startsWith("http")) return floorPlanPath;
            return `http://api.rent-app.loc/storage/${floorPlanPath}`;
        },

        clearAllBusinessMarkers()
        {
            Object.values(this.landmarkMarkers).forEach((markersArray) =>
            {
                markersArray.forEach((m) =>
                {
                    try
                    {
                        m.setMap(null);
                    }
                    catch(error)
                    {
                        console.log(error);
                    }
                });
            });
        },

        async submit()
        {
            try
            {
                const payload =
                {
                    property_id: this.property.id,
                    landlord_id: this.property.landlord.id, // or landlord_id from property object
                    message: this.form.message,
                }
                const response = await apiClient.post(`/inquiries`, payload);
                console.log("Send message:", response.data);
                this.form.message = "";
            }
            catch(error)
            {
                console.log(error);
            }
        },
    },
};
</script>

<style scoped>
ul.list-unstyled li img
{
    display: inline-block;
    margin-right: 6px;
}
.splashscreen
{
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100vh;
    background: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    animation: fadeIn 0.4s ease-in;
}

.splash-content
{
    text-align: center;
    animation: fadeInUp 1s ease;
}

.splash-logo
{
    width: 120px;
    height: auto;
    margin-bottom: 15px;
}
</style>
