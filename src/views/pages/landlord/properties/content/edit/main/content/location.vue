<template>
    <div class="card card-body card-white rounded-0 p-4">
        <h3 class="fw-bold text-primary mb-0">Location Info</h3>

        <div class="mt-3">
            <div class="position-relative">
                <input
                    type="text"
                    class="form-control rounded-0 pe-5"
                    placeholder="Search Address"
                    v-model="searchAddress"
                    ref="inputRef"
                />

                <span
                    class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold"
                    style="cursor: pointer; font-size: 1.25rem; line-height: 1;"
                    @click.prevent="clearMap()"
                >
                    <i class="bx bx-x"></i>
                </span>
            </div>
        </div>

        <div class="mt-3">
            <div id="googleMap" style="width: 100%; height: 400px;"></div>
        </div>
    </div>

    <div class="card card-body card-white rounded-0 p-4 mt-3">
        <h3 class="fw-bold text-primary mb-0">Nearby Area Info</h3>

        <div class="mt-3">
            <ul class="list-group" style="max-height: 350px; overflow-y: auto;">
                <li
                    class="list-group mb-3"
                    v-for="(landmark, index) in nearbyLandmarks"
                    :key="index">
                    <div class="card card-body">
                        <p class="mb-0 fw-semibold d-flex align-items-center">
                            <img v-if="landmark.icon" :src="landmark.icon" class="me-2" style="width:24px;height:24px;" />
                            <small>{{ landmark.name }}</small>
                        </p>
                        <small>
                            {{ landmark.vicinity }}
                            <span v-if="landmark.distance"> ({{ landmark.distance }})</span>
                        </small>
                    </div>
                </li>

                <li v-if="!nearbyLandmarks.length">
                    <p class="mb-0 text-center">No landmarks found</p>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
export default
{
    data()
    {
        return {
            searchAddress: "",
            map: null,
            marker: null,
            innerCircle: null,
            outerCircle: null,
            landmarkMarkers: [],
            nearbyLandmarks:[],
            apiKey: process.env.VUE_APP_GOOGLE_MAPS_API_KEY,
            isClearing: false,
        };
    },

    computed:
    {
        form()
        {
            return this.$parent.$data.form;
        }
    },

    mounted()
    {
        if (!window.google)
        {
            const script = document.createElement("script");
            script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKey}&libraries=places,geometry&loading=async`;
            script.async = true;
            script.defer = true;
            script.onload = () => this.initMap();
            document.head.appendChild(script);
        }
        else
        {
            this.initMap();
        }
    },

    methods:
    {
        initMap()
        {
            const mapEl = document.getElementById("googleMap");
            if (!mapEl) return;

            const centerPoint =
            {
                lat: 15.3461466,
                lng: 120.5926823
            };

            this.map = new window.google.maps.Map(mapEl,
            {
                center: centerPoint,
                zoom: 12,
                scrollwheel: true
            });

            this.map.addListener("click", (e) =>
            {
                this.placeMarker(e.latLng);
            });

            if (this.form.lat && this.form.lng)
            {
                this.placeMarker(new window.google.maps.LatLng(this.form.lat, this.form.lng));
            }

            if (this.$refs.inputRef)
            {
                const autocomplete = new window.google.maps.places.Autocomplete(this.$refs.inputRef,
                {
                    componentRestrictions: { country: "ph" },
                    fields: ["geometry", "formatted_address"]
                });
                autocomplete.addListener("place_changed", () =>
                {
                    const place = autocomplete.getPlace();
                    if (!place.geometry || !place.geometry.location) return;
                    this.placeMarker(place.geometry.location);
                });
            }
        },

        loadInitialMarker()
        {
            if (this.isClearing) return;

            if (this.map && this.form.lat && this.form.lng)
            {
                const latLng = new window.google.maps.LatLng(this.form.lat, this.form.lng);
                this.placeMarker(latLng);
                this.searchAddress = this.form.address || "";
                this.nearbyLandmarks = [...(this.form.landmarks || [])];
            }
        },

        placeMarker(location)
        {
            if (this.isClearing) return;

            console.log("📍 Placing marker at:", location);

            const latLng = location instanceof window.google.maps.LatLng
                ? location
                : new window.google.maps.LatLng(location.lat(), location.lng());

            if (this.marker)
            {
                console.log("🔁 Marker already exists, updating position...");
                this.marker.setPosition(latLng);
            }
            else
            {
                console.log("🆕 Creating new marker...");
                this.marker = new window.google.maps.Marker(
                {
                    position: latLng,
                    map: this.map,
                    draggable: true
                });

                this.marker.addListener("dragend", (e) =>
                {
                    const newLatLng = e.latLng;
                    console.log("📍 Marker dragged to:", newLatLng.lat(), newLatLng.lng());
                    this.form.lat = newLatLng.lat();
                    this.form.lng = newLatLng.lng();
                    this.updateAddress(newLatLng);
                    this.showLandmarks(newLatLng);
                    this.updateCircles(newLatLng);
                });
            }

            this.form.lat = latLng.lat();
            this.form.lng = latLng.lng();
            console.log("🧭 Updated form coordinates:", this.form.lat, this.form.lng);

            this.updateAddress(latLng);
            this.showLandmarks(latLng);
            this.updateCircles(latLng);
            this.map.panTo(latLng);
        },

        updateAddress(location)
        {
            const geocoder = new window.google.maps.Geocoder();
            geocoder.geocode({ location }, (results, status) =>
            {
                if (status === "OK" && results[0])
                {
                    // this.form.address = results[0].formatted_address;
                    this.searchAddress = results[0].formatted_address;
                }
            });
        },

        updateCircles(location)
        {
            const latLng = location instanceof window.google.maps.LatLng
                ? location
                : new window.google.maps.LatLng(location.lat, location.lng);

            if (this.innerCircle)
            {
                this.innerCircle.setMap(null);
                this.innerCircle = null;
            }
            if (this.outerCircle)
            {
                this.outerCircle.setMap(null);
                this.outerCircle = null;
            }

            this.innerCircle = new window.google.maps.Circle(
            {
                strokeColor: "#007bff",
                strokeOpacity: 0.6,
                strokeWeight: 2,
                fillColor: "#007bff",
                fillOpacity: 0.1,
                map: this.map,
                center: latLng,
                radius: 1000
            });

            this.outerCircle = new window.google.maps.Circle(
            {
                strokeColor: "#00FF00",
                strokeOpacity: 0.6,
                strokeWeight: 2,
                fillColor: "#00FF00",
                fillOpacity: 0.05,
                map: this.map,
                center: latLng,
                radius: 10000
            });
        },

        showLandmarks(location)
        {
            if (!window.google || !this.map || this.isClearing)
            {
                return
            }

            this.landmarkMarkers.forEach((m) =>
            {
                m.setMap(null)
            })
            this.landmarkMarkers = []
            this.nearbyLandmarks = []

            const allowedTypes = ["restaurant", "convenience_store", "supermarket", "bank", "hospital", "school", "gym", "park", "hotel"]
            const typeIcons = 
            {
                restaurant: "https://maps.google.com/mapfiles/kml/shapes/dining.png",
                convenience_store: "https://maps.google.com/mapfiles/kml/shapes/shopping.png",
                supermarket: "https://maps.google.com/mapfiles/kml/shapes/shopping.png",
                bank: "https://maps.gstatic.com/mapfiles/place_api/icons/bank_dollar-71.png",
                hospital: "https://maps.google.com/mapfiles/kml/shapes/hospitals.png",
                school: "https://maps.google.com/mapfiles/kml/shapes/schools.png",
                gym: "https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png",
                park: "https://maps.google.com/mapfiles/kml/shapes/parks.png",
                hotel: "https://maps.google.com/mapfiles/kml/shapes/lodging.png"
            }

            const service = new window.google.maps.places.PlacesService(this.map)

            allowedTypes.forEach((type) =>
            {
                const request =
                {
                    location: location,
                    radius: 5000,
                    type: type
                }

                service.nearbySearch(request, (results, status) =>
                {
                    if (this.isClearing)
                    {
                        return
                    }

                    if (status === window.google.maps.places.PlacesServiceStatus.OK && results.length)
                    {
                        results.forEach((place) =>
                        {
                            if (!place.geometry || !place.geometry.location)
                            {
                                return
                            }

                            const placeType = place.types?.find((t) => allowedTypes.includes(t))
                            if (!placeType)
                            {
                                return
                            }

                            const distance = window.google.maps.geometry.spherical.computeDistanceBetween(location, place.geometry.location)
                            const distanceKm = (distance / 1000).toFixed(2)

                            const marker = new window.google.maps.Marker(
                            {
                                position: place.geometry.location,
                                map: this.map,
                                title: place.name,
                                icon:
                                {
                                    url: typeIcons[placeType] || null,
                                    scaledSize: new window.google.maps.Size(24, 24)
                                }
                            })

                            this.landmarkMarkers.push(marker)
                            this.nearbyLandmarks.push(
                            {
                                name: place.name,
                                vicinity: place.vicinity || "",
                                distance: distanceKm,
                                lat: place.geometry.location.lat(),
                                lng: place.geometry.location.lng(),
                                type: placeType,
                                icon: typeIcons[placeType] || null
                            })

                            this.$parent.form.landmarks = [...this.nearbyLandmarks]
                        })
                    }
                })
            })
        },

        clearMap()
        {
            console.log("🧹 Clearing map and resetting state...");
            this.isClearing = true;

            // 1️⃣ Remove the main marker
            if (this.marker)
            {
                console.log("❌ Removing main marker...");
                this.marker.setMap(null);
                this.marker = null;
            }

            // 2️⃣ Remove the circles
            if (this.innerCircle)
            {
                console.log("❌ Removing inner circle...");
                this.innerCircle.setMap(null);
                this.innerCircle = null;
            }
            if (this.outerCircle)
            {
                console.log("❌ Removing outer circle...");
                this.outerCircle.setMap(null);
                this.outerCircle = null;
            }

            // 3️⃣ Remove landmark markers
            if (this.landmarkMarkers.length)
            {
                console.log(`❌ Removing ${this.landmarkMarkers.length} landmark markers...`);
                this.landmarkMarkers.forEach(marker => marker.setMap(null));
            }
            this.landmarkMarkers = [];
            this.nearbyLandmarks = [];

            // 4️⃣ Reset parent form data (if exists)
            if (this.$parent?.form)
            {
                console.log("🧾 Resetting parent form data...");
                this.$parent.form.landmarks = [];
                this.$parent.form.lat = "";
                this.$parent.form.lng = "";
                this.$parent.form.address = "";
            }

            // 5️⃣ Clear search input
            this.searchAddress = "";

            // 6️⃣ Reset map center and zoom
            
            const defaultCenter =
            {
                lat: 15.3461466,
                lng: 120.5926823
            };
            if (this.map)
            {
                console.log("🔄 Resetting map center and zoom...");
                this.map.panTo(defaultCenter);
                this.map.setZoom(16);
            }

            // 7️⃣ Reinitialize map properly (to allow repinning)
            console.log("🗺️ Reinitializing map...");
            this.map = new window.google.maps.Map(document.getElementById("googleMap"), {
                center: defaultCenter,
                zoom: 16,
                scrollwheel: true
            });

            // Reattach map click event
            this.map.addListener("click", (e) =>
            {
                console.log("📍 Map clicked — placing new marker...");
                this.isClearing = false; // allow new marker again
                this.placeMarker(e.latLng);
            });

            // 8️⃣ Reset state flag
            setTimeout(() =>
            {
                this.isClearing = false;
                console.log("✅ Map cleared and ready for new pin.");
            }, 300);
        }
    },

    watch:
    {
        'form.lat'(newLat)
        {
            if (this.isClearing) return;
            if (newLat && this.form.lng && this.map && !this.marker)
            {
                this.loadInitialMarker();
            }
        },

        'form.lng'(newLng)
        {
            if (this.isClearing) return;
            if (newLng && this.form.lat && this.map && !this.marker)
            {
                this.loadInitialMarker();
            }
        },

    }
};
</script>
