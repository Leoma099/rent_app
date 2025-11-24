<template>
    <div>
        <div class="card card-body card-white rounded-0 p-4 mb-3">
            <h3 class="fw-bold text-primary mb-3">Location Info</h3>
            <div class="position-relative mb-3">
                <input type="text" class="form-control rounded-0 pe-5" placeholder="Search Address" v-model="searchAddress" readonly />
                <span class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold" style="cursor: pointer; font-size: 1.25rem; line-height: 1;" @click.prevent="clearMap()">
                    <i class="bx bx-x"></i>
                </span>
            </div>
            <div id="leafletMap" style="width: 100%; height: 400px;"></div>
            <div class="mt-3">
                <p>Selected Coordinates: {{ selectedLat }}, {{ selectedLng }}</p>
                <p>Address: {{ searchAddress }}</p>
            </div>
        </div>
        <div class="card card-body card-white rounded-0 p-4">
            <h3 class="fw-bold text-primary mb-3">Nearby Area Info</h3>
            <ul class="list-group" style="max-height: 350px; overflow-y: auto;">
                <li class="list-group mb-3" v-for="(landmark, index) in nearbyLandmarks" :key="index">
                    <div class="card card-body">
                        <p class="mb-0 fw-semibold d-flex align-items-center">
                            <img v-if="landmark.icon" :src="landmark.icon" class="me-2" style="width:24px;height:24px;" />
                            <small>{{ landmark.name }}</small>
                        </p>
                        <small>{{ landmark.vicinity }}<span v-if="landmark.distance"> ({{ landmark.distance }} km)</span></small>
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
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import apiClient from "@/services";

export default
{
    name: "LocationLeaflet",
    data()
    {
        return {
            map: null,
            marker: null,
            innerCircle: null,
            outerCircle: null,
            selectedLat: null,
            selectedLng: null,
            searchAddress: "",
            nearbyLandmarks: [],
            landmarkMarkers: [],
            defaultCenter: [15.3461466, 120.5926823],
            markerIconUrl: "https://www.svgrepo.com/show/476893/marker.svg",
            allowedTypes:
            {
                restaurant: "restaurant",
                convenience_store: "convenience",
                supermarket: "supermarket",
                bank: "bank",
                hospital: "hospital",
                school: "school",
                gym: "gym",
                park: "park",
                hotel: "hotel"
            },
            typeIcons:
            {
                restaurant: "https://www.svgrepo.com/show/281640/restaurant-fork.svg",
                convenience: "https://www.svgrepo.com/show/501826/shop.svg",
                supermarket: "https://www.svgrepo.com/show/380509/market-store-shop-winter.svg",
                bank: "https://www.svgrepo.com/show/513266/bank.svg",
                hospital: "https://www.svgrepo.com/show/500071/hospital.svg",
                school: "https://www.svgrepo.com/show/530144/school.svg",
                gym: "https://www.svgrepo.com/show/19975/gym-weight.svg",
                park: "https://www.svgrepo.com/show/286284/park.svg",
                hotel: "https://www.svgrepo.com/show/500047/hotel.svg"
            }
        };
    },
    mounted()
    {
        this.initMap();
    },
    methods:
    {
        initMap()
        {
            this.map = L.map("leafletMap").setView(this.defaultCenter, 16);
            L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", { attribution: "&copy; OpenStreetMap contributors" }).addTo(this.map);
            this.placeMarker(L.latLng(...this.defaultCenter));
            this.map.on("click", e =>
            {
                this.placeMarker(e.latlng);
            });
        },
        placeMarker(latlng)
        {
            const customIcon = L.icon({ iconUrl: this.markerIconUrl, iconSize: [32, 32], iconAnchor: [16, 32] });
            if (this.marker)
            {
                this.marker.setLatLng(latlng);
            }
            else
            {
                this.marker = L.marker(latlng, { icon: customIcon, draggable: true }).addTo(this.map);
                this.marker.on("dragend", e =>
                {
                    this.updateSelected(e.target.getLatLng());
                });
            }
            this.updateSelected(latlng);
        },
        async updateSelected(latlng)
        {
            this.selectedLat = latlng.lat;
            this.selectedLng = latlng.lng;
            try
            {
                const res = await apiClient.get(`https://nominatim.openstreetmap.org/reverse?lat=${latlng.lat}&lon=${latlng.lng}&format=json`);
                this.searchAddress = res.data.display_name || "";
            }
            catch
            {
                this.searchAddress = "";
            }
            this.loadNearby(latlng);
            this.showCircles(latlng);
        },
        async loadNearby(latlng)
        {
            this.landmarkMarkers.forEach(m => m.remove());
            this.landmarkMarkers = [];
            this.nearbyLandmarks = [];
            const radius = 5000;
            const types = Object.values(this.allowedTypes);
            try
            {
                const res = await apiClient.get(`/landmarks?lat=${latlng.lat}&lng=${latlng.lng}&radius=${radius}&types=${types.join(",")}`);
                res.data.forEach(el =>
                {
                    if (!el.lat || !el.lng) return;
                    const typeKey = el.type || "unknown";
                    const distanceKm = (this.map.distance([latlng.lat, latlng.lng], [el.lat, el.lng]) / 1000).toFixed(2);
                    const iconUrl = this.typeIcons[typeKey] || this.markerIconUrl;
                    const marker = L.marker([el.lat, el.lng], { icon: L.icon({ iconUrl, iconSize: [24, 24] }) }).addTo(this.map);
                    this.landmarkMarkers.push(marker);
                    this.nearbyLandmarks.push({ name: el.name, vicinity: el.vicinity, distance: distanceKm, lat: el.lat, lng: el.lng, type: typeKey, icon: iconUrl });
                });
            }
            catch (err)
            {
                console.error(err);
            }
        },
        showCircles(latlng)
        {
            if (this.innerCircle) this.innerCircle.remove();
            if (this.outerCircle) this.outerCircle.remove();
            this.innerCircle = L.circle([latlng.lat, latlng.lng], { color: "#007bff", fillColor: "#007bff", fillOpacity: 0.1, radius: 1000 }).addTo(this.map);
            this.outerCircle = L.circle([latlng.lat, latlng.lng], { color: "#00FF00", fillColor: "#00FF00", fillOpacity: 0.05, radius: 10000 }).addTo(this.map);
        },
        clearMap()
        {
            if (this.marker) this.marker.setLatLng(this.defaultCenter);
            this.map.setView(this.defaultCenter, 16);
            this.selectedLat = this.defaultCenter[0];
            this.selectedLng = this.defaultCenter[1];
            this.searchAddress = "";
            this.landmarkMarkers.forEach(m => m.remove());
            this.landmarkMarkers = [];
            this.nearbyLandmarks = [];
            if (this.innerCircle) this.innerCircle.remove();
            if (this.outerCircle) this.outerCircle.remove();
        }
    }
};
</script>

<style scoped>
#leafletMap
{
    border: 1px solid #ddd;
    border-radius: 4px;
}
</style>
