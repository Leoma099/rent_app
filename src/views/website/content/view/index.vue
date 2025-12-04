<template>
    <div v-if="showSplash" class="splashscreen">
        <div class="splash-content">
            <img src="@/assets/images/capas_logo.png" alt="Logo" class="splash-logo" />
            <h2>Loading...</h2>
        </div>
    </div>
    <div class="container my-5" v-if="!showSplash" :key="$route.fullPath">

        <header-component />

        <div class="d-flex justify-content-between align-items-start mt-3">
            <div>
                <h1 class="mb-0">{{ property.title }}</h1>
                <p class="my-2">
                    <span v-if="property.is_featured !== 0" class="badge fs-6 text-bg me-2">{{ formatFeature(property.is_featured) }}</span>
                    <span class="badge fs-6 text-bg-secondary">{{ formatPropStats( property.propertyStats ) }}</span>
                </p>
                <p class="mb-0 text-secondary"><i class="bx bx-map"></i> {{ property.address }}</p>
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

        <div class="row mt-3">

            <div class="col-md-9">
                <div class="card card-body rounded-0 card-white shadow-sm">
                    <div id="propertyCarousel" class="carousel slide" data-bs-ride="carousel">
                        <div class="carousel-indicators">
                            <button 
                                v-for="(photo, index) in propertyPhotos" 
                                :key="index"
                                type="button" 
                                data-bs-target="#propertyCarousel" 
                                :data-bs-slide-to="index"
                                :class="index === 0 ? 'active' : ''"
                                :aria-current="index === 0 ? 'true' : 'false'"
                                :aria-label="'Slide ' + (index + 1)">
                            </button>
                        </div>
                        <div class="carousel-inner rounded-0 shadow-sm">
                            <div 
                                v-for="(photo, index) in propertyPhotos" 
                                :key="index"
                                class="carousel-item"
                                :class="index === 0 ? 'active' : ''">
                                <img
                                    :src="photo"
                                    :alt="property.title + ' - Photo ' + (index + 1)"
                                    class="d-block w-100"
                                    style="height: 30rem; object-fit: cover;"
                                />
                            </div>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#propertyCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Previous</span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#propertyCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Next</span>
                        </button>
                    </div>

                    <hr />

                    <!-- MAKE IT BADGE -->
                    <div>
                        <p class="mb-0"><strong>Type and Size:</strong></p>
                        <p class="mb-0">
                            <span
                                v-for="(type, index) in property.property_type.split(',')"
                                :key="index"
                                class="badge text-bg-info me-1"
                            >
                                {{ type.trim() }}
                            </span>
                            ( <i class='bx bx-ruler'></i> {{ property.size }} sqm )
                        </p>
                    </div>

                    <hr>

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
                                :src="getPhotoUrl(property.photo_4)"
                                :alt="property.title"
                                class="img-fluid card-img-top rounded-0"
                                style="height: 100%; object-fit: cover;"
                            />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="col-md-3">
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
                                class="btn btn-primary w-100 rounded-0"
                                :disabled="isLoading">
                                <span v-if="isLoading">Sending Message...</span>
                                <span v-else>Send Message</span>
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

                        <div v-if="property.propertyStats === 2">
                            <button
                                class="btn btn-secondary rounded-0 w-100"
                                disabled>
                                Occupied
                            </button>
                        </div>
                        <div v-else>
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
                    </div>

                </form>
            </div>
        </div>
        <recommended-component :propertyId="property.id" :key="property.id" />
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
            businessTypes:
            {
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
            showSplash: true,
            isLoading: false,
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
        }, 1000);
    },

    computed:
    {
        isLoggedIn()
        {
            return !!localStorage.getItem("access_token");
        },

        propertyPhotos()
        {
            if (!this.property) return [];
            
            const photos = [];
            // Add all available photos in order
            if (this.property.photo_1) photos.push(this.getPhotoUrl(this.property.photo_1));
            if (this.property.photo_2) photos.push(this.getPhotoUrl(this.property.photo_2));
            if (this.property.photo_3) photos.push(this.getPhotoUrl(this.property.photo_3));
            
            return photos;
        }
    },

    watch:
    {
        '$route.params.id':
        {
            immediate: true,
            handler(newId) {
                this.showSplash = true;
                this.property = null;
                this.loadProperty(newId).then(() => {
                    this.showSplash = false;
                    window.scrollTo({ top: 0, left: 0, behavior: 'instant' });
                });
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

        formatPropStats(status)
        {
            const statuses =
            {
                0: "Under Review",
                1: "For Rent",
                2: "Rented",
                3: "Under Maintenance",
                4: "Reserved",
            };
            return statuses[status] || "N/A";
        },

        formatFeature(feature)
        {
            const featured =
            {
                1: 'Featured',
            };
            return featured[feature] || "N/A";
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
            if (this.selectedScheduleId === schedule.id) {
                return true;
            }

            return [0,1].includes(schedule.status);
        },

        async bookSched()
        {
            if (!this.bookForm.sched)
            {
                alert("Please select a schedule before booking.");
                return;
            }

            this.isBooking = true;

            try
            {
                const payload =
                {
                    property_id: this.property.id,
                    landlord_id: this.property.landlord.id,
                    schedule_id: Number(this.bookForm.sched)
                };

                const response = await apiClient.post("/bookings", payload);

                console.log("Book success:", response.data);

                const schedId = Number(this.bookForm.sched);
                const idx = this.property.schedules.findIndex(function (s)
                {
                    return s.id === schedId;
                });

                if (idx !== -1)
                {
                    this.$set
                        ? this.$set(this.property.schedules[idx], "booked", true)
                        : (this.property.schedules[idx].booked = true);
                }

                this.selectedScheduleId = null;
                this.bookForm.sched = "";

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
                this.form.message = `Hello, I am interested in ${this.property.title}`;

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
            return `${process.env.VUE_APP_API_URL}/${photoPath}`;
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
            this.isLoading = true;
            try
            {
                await new Promise(resolve => setTimeout(resolve, 1000));
                
                const payload =
                {
                    property_id: this.property.id,
                    landlord_id: this.property.landlord.id,
                    message: this.form.message,
                }
                const response = await apiClient.post(`/inquiries`, payload);
                console.log("Send message:", response.data);
                this.form.message = "";
                this.toast.success("Inquiry message send successfully.");
            }
            catch(error)
            {
                console.log(error);
                this.toast.error("Inquiry message send unsuccessfully.");
            }
            finally
            {
                this.isLoading = false;
            }
        },
    },
};
</script>

<style scoped>
.badge {
    background-color: #e9ecef;
    color: #333;
    border-radius: 0.25rem;
    font-weight: 500;
    padding: 0.4em 0.6em;
}

ul.list-unstyled li img
{
    display: inline-block;
    margin-right: 6px;
}
.fade-enter-active,
.fade-leave-active
{
    transition: opacity 0.6s ease;
}

.fade-enter-from,
.fade-leave-to
{
    opacity: 0;
}

.fade-enter-to,
.fade-leave-from
{
    opacity: 1;
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
}

.splash-content
{
    text-align: center;
    animation: fadeInUp 0.6s ease;
}

.splash-logo
{
    width: 120px;
    height: auto;
    margin-bottom: 15px;
}

@keyframes fadeInUp
{
    from
    {
        opacity: 0;
        transform: translateY(20px);
    }
    to
    {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Carousel styling to maintain same position */
#propertyCarousel {
    height: 30rem;
}

.carousel-inner,
.carousel-item,
.carousel-item img {
    height: 100%;
}
</style>