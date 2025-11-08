<template>
    <div>
        <div class="card card-body card-white rounded-0 p-4">
            <h3 class="fw-bold text-primary mb-0">Location Info</h3>

            <div class="mt-3 d-flex gap-2">
                <input
                    type="text"
                    class="form-control rounded-0"
                    placeholder="Search Address"
                    v-model="searchAddress"
                    ref="inputRef"
                    disabled
                />
                <button type="button" class="btn btn-outline-secondary" @click="clearMap" disabled>
                    Clear Map
                </button>
            </div>

            <div class="mt-3">
                <div id="googleMap" style="width: 100%; height: 400px;" disabled></div>
            </div>
        </div>

        <div class="card card-body card-white rounded-0 p-4 mt-3">
            <h3 class="fw-bold text-primary mb-0">Nearby Area Info</h3>

            <div class="mt-3">
                <ul class="list-group" style="max-height: 350px; overflow-y: auto;">
                    <li
                        class="list-group mb-3"
                        v-for="(landmark, index) in nearbyLandmarks"
                        :key="index"
                    >
                        <div class="card card-body bg-primary text-white border-0">
                            <p class="mb-0"><strong>{{ landmark.name }}</strong></p>
                            <small>{{ landmark.vicinity }} ({{ landmark.distance }} km)</small>
                        </div>
                    </li>
                    <li v-if="!nearbyLandmarks.length">
                        <p class="mb-0 text-center">No landmarks found</p>
                    </li>
                </ul>
            </div>
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
            nearbyLandmarks: [],
            apiKey: process.env.VUE_APP_GOOGLE_MAPS_API_KEY, // <-- use .env
            isClearing: false // 👈 Added flag to prevent reloading during clear
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
            script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKey}&libraries=places,geometry,visualization`;
            script.async = true;
            script.defer = true;
            script.onload = () =>
            {
                this.initMap();
                this.loadInitialMarker();
            };
            document.head.appendChild(script);
        }
        else
        {
            this.initMap();
            this.loadInitialMarker();
        }
    },

    methods:
    {
        initMap()
        {
            const mapEl = document.getElementById("googleMap");
            if (!mapEl) return;

            const centerPoint = { lat: 15.2871, lng: 120.5860 };
            this.map = new window.google.maps.Map(mapEl, {
                center: centerPoint,
                zoom: 12,
                scrollwheel: true
            });

            this.map.addListener("click", (e) =>
            {
                this.placeMarker(e.latLng);
            });

            if (this.$refs.inputRef)
            {
                const autocomplete = new window.google.maps.places.Autocomplete(this.$refs.inputRef, {
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
            if (!this.map) return;

            const latLng = location instanceof window.google.maps.LatLng
                ? location
                : new window.google.maps.LatLng(location.lat(), location.lng());

            if (this.marker)
            {
                this.marker.setPosition(latLng);
            }
            else
            {
                this.marker = new window.google.maps.Marker({
                    position: latLng,
                    map: this.map,
                    draggable: true
                });

                this.marker.addListener("dragend", (e) =>
                {
                    const newLatLng = e.latLng;
                    this.form.lat = newLatLng.lat();
                    this.form.lng = newLatLng.lng();
                    this.updateAddress(newLatLng);
                    this.showLandmarks(newLatLng);
                    this.updateCircles(newLatLng);
                });
            }

            this.form.lat = latLng.lat();
            this.form.lng = latLng.lng();
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
                    this.form.address = results[0].formatted_address;
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

            this.innerCircle = new window.google.maps.Circle({
                strokeColor: "#007bff",
                strokeOpacity: 0.6,
                strokeWeight: 2,
                fillColor: "#007bff",
                fillOpacity: 0.1,
                map: this.map,
                center: latLng,
                radius: 1000
            });

            this.outerCircle = new window.google.maps.Circle({
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
            if (!window.google || !this.map) return;

            this.landmarkMarkers.forEach((m) => m.setMap(null));
            this.landmarkMarkers = [];
            this.nearbyLandmarks = [];

            const service = new window.google.maps.places.PlacesService(this.map);
            const types = ["restaurant", "school", "hospital", "supermarket", "gas_station", "store"];

            types.forEach((type) =>
            {
                const request = { location: location, radius: 5000, type: type };

                service.nearbySearch(request, (results, status) =>
                {
                    if (status === window.google.maps.places.PlacesServiceStatus.OK && results.length)
                    {
                        results.forEach((place) =>
                        {
                            if (!place.geometry || !place.geometry.location) return;

                            const marker = new window.google.maps.Marker({
                                position: place.geometry.location,
                                map: this.map,
                                title: place.name,
                                icon: {
                                    path: window.google.maps.SymbolPath.CIRCLE,
                                    scale: 8,
                                    fillColor: "#4285F4",
                                    fillOpacity: 1,
                                    strokeWeight: 1
                                }
                            });

                            const infoWindow = new window.google.maps.InfoWindow({
                                content: `<strong>${place.name}</strong><br/>${place.vicinity || ""}`
                            });

                            marker.addListener("click", () =>
                            {
                                infoWindow.open(this.map, marker);
                            });

                            const distance = window.google.maps.geometry.spherical.computeDistanceBetween(
                                location,
                                place.geometry.location
                            );
                            const distanceKm = (distance / 1000).toFixed(2);

                            this.landmarkMarkers.push(marker);

                            this.nearbyLandmarks.push({
                                name: place.name,
                                vicinity: place.vicinity || "",
                                distance: distanceKm,
                                lat: place.geometry.location.lat(),
                                lng: place.geometry.location.lng()
                            });

                            this.$parent.form.landmarks = [...this.nearbyLandmarks];
                        });
                    }
                });
            });
        },

        clearMap()
        {
            if (!this.map) return;

            // Keep flag true during entire reset
            this.isClearing = true;

            // Always remove marker and circles
            if (this.marker)
            {
                this.marker.setMap(null);
                this.marker = null;
            }
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

            // Clear all nearby markers and info
            this.landmarkMarkers.forEach((m) => m.setMap(null));
            this.landmarkMarkers = [];
            this.nearbyLandmarks = [];

            // Reset form data
            this.form.lat = null;
            this.form.lng = null;
            this.form.address = "";
            this.searchAddress = "";
            this.$parent.form.landmarks = [];

            // Reset map position
            const centerPoint = { lat: 15.2871, lng: 120.5860 };
            this.map.setCenter(centerPoint);
            this.map.setZoom(12);

            // Keep clearing state slightly longer
            setTimeout(() =>
            {
                this.isClearing = false;
            }, 600);
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
}
</script>