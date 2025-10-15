<template>

    <h3 class="fw-bold text-primary mb-0">Property Location Info</h3>

    <div class="mt-3 d-flex gap-2">
        <input
            type="text"
            class="form-control rounded-0"
            placeholder="Search Address"
            v-model="searchAddress">
        <button
            type="button"
            class="btn btn-primary rounded-0"
            @click="pinLocation">
            <i class="bx bx-pin"></i>
        </button>
    </div>

    <div class="mt-3">
        <div id="googleMap" style="width: 100%; height: 400px;"></div>
    </div>

    <div class="mt-3">
        <div class="row">
            <div class="col-md-6">
                <label class="form-label">* Latitude:</label>
                <input
                    type="number"
                    step="any"
                    class="form-control rounded-0"
                    placeholder="ex. 15.3463"
                    v-model="form.lat">
            </div>
            <div class="col-md-6">
                <label class="form-label">* Longtitude:</label>
                <input
                    type="number"
                    step="any"
                    class="form-control rounded-0"
                    placeholder="ex. 120.5934"
                    v-model="form.lng">
            </div>
        </div>
    </div>

</template>

<script>
export default {
    data() {
        return {
            searchAddress: '',           // ✅ added
            map: null,
            marker: null,
            innerCircle: null,
            outerCircle: null
        }
    },

    computed: {
        form() {
            return this.$parent.$data.form;
        }
    },

    mounted() {
        if (!window.google) {
            const script = document.createElement('script');
            script.src = `https://maps.googleapis.com/maps/api/js?key=AIzaSyCn9IGzgS41HOIRhMz_-RXlodu0mqsTgyU`;
            script.async = true;
            script.defer = true;

            script.onload = () => {
                this.initMap();
            };

            document.head.appendChild(script);
        } else {
            this.initMap();
        }
    },

    methods: {
        initMap() {
            const mapEl = document.getElementById('googleMap');
            if (!mapEl) return;

            // Initial map center
            const centerPoint = { lat: 15.2871, lng: 120.5860 };

            this.map = new window.google.maps.Map(mapEl, {
                center: centerPoint,
                zoom: 12,
                scrollwheel: true // allow zoom with mouse
            });

            // Listen for click to place marker
            this.map.addListener('click', (e) => {
                this.placeMarker(e.latLng);
            });
        },

        // ✅ added to geocode typed address and place pin
        pinLocation() {
            if (!this.searchAddress) return;

            const geocoder = new window.google.maps.Geocoder();
            geocoder.geocode({ address: this.searchAddress }, (results, status) => {
                if (status === "OK" && results[0]) {
                    const location = results[0].geometry.location;
                    this.map.setCenter(location);
                    this.placeMarker(location);
                    this.form.address = results[0].formatted_address; // optional
                } else {
                    console.error("Geocode failed: " + status);
                }
            });
        },

        placeMarker(location) {
            // Remove previous marker if exists
            if (this.marker) {
                this.marker.setPosition(location);
            } else {
                this.marker = new window.google.maps.Marker({
                    position: location,
                    map: this.map,
                    draggable: true
                });

                // Update lat/lng on drag
                this.marker.addListener('dragend', (e) => {
                    this.form.lat = e.latLng.lat();
                    this.form.lng = e.latLng.lng();
                });
            }

            // Remove previous circles if exist
            if (this.innerCircle) this.innerCircle.setMap(null);
            if (this.outerCircle) this.outerCircle.setMap(null);

            // Inner circle (1 km)
            this.innerCircle = new window.google.maps.Circle({
                strokeColor: "#007bff",
                strokeOpacity: 0.6,
                strokeWeight: 2,
                fillColor: "#007bff",
                fillOpacity: 0.1,
                map: this.map,
                center: location,
                radius: 1000 // 1 km
            });

            // Outer circle (10 km)
            this.outerCircle = new window.google.maps.Circle({
                strokeColor: "#00FF00",
                strokeOpacity: 0.6,
                strokeWeight: 2,
                fillColor: "#00FF00",
                fillOpacity: 0.05,
                map: this.map,
                center: location,
                radius: 10000 // 10 km
            });

            this.form.lat = location.lat();
            this.form.lng = location.lng();
        }
    }
}
</script>

<style>
/* optional styles */
</style>
