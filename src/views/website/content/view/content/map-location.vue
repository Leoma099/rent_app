<template>
    <div class="mb-3">
        <strong>Near at:</strong>

        <div class="d-flex gap-2 mb-2">
            <button
                class="btn"
                :class="activeTab === 'business' ? 'btn-primary' : 'btn-outline-primary'"
                @click="activeTab = 'business'">
                Business Density
            </button>
            <button
                class="btn"
                :class="activeTab === 'landmarks' ? 'btn-primary' : 'btn-outline-primary'"
                @click="activeTab = 'landmarks'">
                Landmarks
            </button>
        </div>

        <div class="mt-3 d-flex gap-2 flex-wrap" v-if="activeTab === 'business'">
            <span 
                v-for="(b, index) in sortedLandmarks.filter(x => 
                    ['restaurant', 'convenience_store', 'supermarket', 'bank', 'atm', 'hotel', 'gym']
                    .includes(String(x.type_id).toLowerCase())
                )"
                :key="index"
                class="badge fs-6 rounded-pill me-2 mb-2"
                :class="{
                    'bg-primary text-white': selectedBusinessTypeLocal === String(b.type_id).toLowerCase(),
                    'bg-secondary': selectedBusinessTypeLocal !== String(b.type_id).toLowerCase()
                }"
                @click="selectBusinessType(b.type_id)"
            >
                <div class="d-flex align-items-center">
                    <div>
                        <img 
                            v-if="b?.icon" 
                            :src="b.icon" 
                            alt="" 
                            class="landmark-icon"
                        />
                    </div>
                    <div>
                        {{ b?.label || 'Unknown' }}
                        <strong>({{ b?.count || 0 }})</strong>
                    </div>
                </div>
            </span>
        </div>


        <div class="mb-3" v-if="activeTab === 'landmarks'">
            <strong>Landmark Tagging:</strong>
            <div class="mt-3">
                <div>
                    <select 
                        v-model="selectedBusinessTypeLocal" 
                        @change="showBusinessMarkers" 
                        class="form-select rounded-0 me-2">
                        <option value="">-- View All --</option>
                        <option
                            v-for="(b, index) in sortedLandmarks"
                            :key="index"
                            :value="String(b.type_id).toLowerCase()">
                            {{ b.label }} ({{ b.count }})
                        </option>
                    </select>
                </div>

                <div class="places-list card rounded-0 shadow-sm mt-3 p-2">
                    <template v-if="!selectedBusinessTypeLocal">
                        <div 
                            v-for="(landmark, index) in sortedLandmarks" 
                            :key="index" 
                            class="mb-3">
                            <div v-if="landmark.count > 0">
                                <h6 class="fw-bold text-primary mb-1">
                                    {{ landmark.label }}:
                                </h6>
                                <ul class="list-group ms-3">
                                    <li 
                                        v-for="(place, i) in landmark.places" 
                                        :key="i" 
                                        class="list-group-item border-0 px-1 py-1">
                                        <p class="mb-0 fw-semibold d-flex align-items-center">
                                            <img 
                                                v-if="place?.icon" 
                                                :src="place.icon" 
                                                alt="" 
                                                class="place-icon me-2" />
                                            <small>{{ place.name }}</small>
                                        </p>
                                        <small>
                                            {{ place.vicinity }}
                                            <span v-if="place.distance"> ({{ place.distance }})</span>
                                        </small>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </template>

                    <ul 
                        v-else 
                        class="list-group" 
                        style="max-height: 450px; overflow-y: auto;">
                        <li 
                            v-for="(place, index) in selectedBusinessPlaces" 
                            :key="index" 
                            class="px-2">
                            <p class="mb-0 fw-semibold d-flex align-items-center">
                                <img 
                                    v-if="place?.icon" 
                                    :src="place.icon" 
                                    alt="" 
                                    class="place-icon me-2" />
                                <small>{{ place.name }}</small>
                            </p>
                            <small>
                                {{ place.vicinity }}
                                <span v-if="place.distance"> ({{ place.distance }})</span>
                            </small>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="mb-3">
        <strong>Map:</strong>
        <div class="mt-3">
            <div ref="mapRef" class="map-container rounded-0 shadow-sm"></div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, nextTick, defineProps } from "vue";

const props = defineProps({
    property: Object,
    businessTypes: Object
});

const mapRef = ref(null);
let map = null;
let mainMarker = null;
let landmarkMarkers = {};
let activeMarkers = [];
let circle1km = null;
let circle10km = null;
const markersReady = ref(false);
const defaultZoom = 14;
const activeTab = ref("business")

const selectedBusinessTypeLocal = ref("");

// Computed for sorted landmarks
const sortedLandmarks = computed(() =>
{
    return [...props.property.landmarksSummary].sort((a, b) => a.label.localeCompare(b.label));
});

// Computed for selected business places
const selectedBusinessPlaces = computed(() =>
{
    if (!selectedBusinessTypeLocal.value)
    {
        return [].concat(...props.property.landmarksSummary.map(l => l.places));
    }

    const selected = props.property.landmarksSummary.find(
        l => String(l.type_id) === String(selectedBusinessTypeLocal.value)
    );

    return selected ? selected.places.map(place => ({
        name: place.name,
        vicinity: place.vicinity,
        distance: place.distance || "",
        icon: selected.icon || place.icon || props.businessTypes[selected.type_id]?.icon || ""
    })) : [];
});

// Initialize map
onMounted(() =>
{
    if (!props.property) return;

    nextTick(initMap);
});

// Watch selection changes
watch(selectedBusinessTypeLocal, () =>
{
    showBusinessMarkers();
});

// Handle badge click
function selectBusinessType(typeId)
{
    const typeString = String(typeId).toLowerCase();
    selectedBusinessTypeLocal.value = selectedBusinessTypeLocal.value === typeString ? "" : typeString;
}

// Initialize map
function initMap()
{
    const lat = parseFloat(props.property.lat);
    const lng = parseFloat(props.property.lng);
    if (isNaN(lat) || isNaN(lng)) return;

    const center = { lat, lng };

    map = new window.google.maps.Map(mapRef.value, {
        center,
        zoom: defaultZoom,
        mapTypeId: "roadmap",
        zoomControl: true,
        streetViewControl: false,
        mapTypeControl: false,
        fullscreenControl: true,
        scrollwheel: true,
        styles: [
            { featureType: "all", elementType: "labels.text.fill", stylers: [{ color: "#333" }] },
            { featureType: "all", elementType: "labels.text.stroke", stylers: [{ color: "#ffffff" }] },
            { featureType: "poi", elementType: "labels.icon", stylers: [{ visibility: "off" }] },
            { featureType: "road", elementType: "geometry", stylers: [{ color: "#e6e6e6" }] },
            { featureType: "water", elementType: "geometry.fill", stylers: [{ color: "#d6e6f2" }] },
            { featureType: "landscape", elementType: "geometry.fill", stylers: [{ color: "#f8f8f8" }] }
        ]
    });

    mainMarker = new window.google.maps.Marker({
        position: center,
        map,
        title: props.property.title || "Property",
        icon: { url: "https://maps.google.com/mapfiles/ms/icons/red-dot.png" },
        zIndex: 9999
    });

    landmarkMarkers = {};
    activeMarkers = [];
    drawSearchCircles(center);

    const fetchPromises = Object.keys(props.businessTypes).map(type =>
        fetchBusinessDensity(center, type)
    );

    Promise.all(fetchPromises).then(() =>
    {
        markersReady.value = true;
        showBusinessMarkers();
    });
}

// Draw circles
function drawSearchCircles(center)
{
    if (circle1km) circle1km.setMap(null);
    if (circle10km) circle10km.setMap(null);

    const latLng = new window.google.maps.LatLng(center.lat, center.lng);

    circle1km = new window.google.maps.Circle({
        strokeColor: "#007bff",
        strokeOpacity: 0.6,
        strokeWeight: 2,
        fillColor: "#007bff",
        fillOpacity: 0.1,
        map,
        center: latLng,
        radius: 1000
    });

    circle10km = new window.google.maps.Circle({
        strokeColor: "#28a745",
        strokeOpacity: 0.5,
        strokeWeight: 2,
        fillColor: "#28a745",
        fillOpacity: 0.05,
        map,
        center: latLng,
        radius: 10000
    });
}

// Fetch markers
function fetchBusinessDensity(center, type)
{
    return new Promise(resolve =>
    {
        const request = { location: center, radius: 1000, type };
        const service = new window.google.maps.places.PlacesService(map);

        service.nearbySearch(request, (results, status) =>
        {
            if (status === window.google.maps.places.PlacesServiceStatus.OK)
            {
                const placesWithDistance = results.map(place =>
                {
                    let distanceStr = "";
                    if (window.google && window.google.maps.geometry && place.geometry)
                    {
                        const distanceMeters = window.google.maps.geometry.spherical.computeDistanceBetween(
                            new window.google.maps.LatLng(center.lat, center.lng),
                            place.geometry.location
                        );
                        distanceStr = distanceMeters < 1000
                            ? Math.round(distanceMeters) + " m"
                            : (distanceMeters / 1000).toFixed(2) + " km";
                    }
                    return { ...place, distance: distanceStr };
                });

                const summary = {
                    type_id: String(type),
                    label: props.businessTypes[type].name,
                    icon: props.businessTypes[type].icon,
                    count: results.length,
                    places: placesWithDistance
                };

                props.property.landmarksSummary.push(summary);

                const markers = results.map(place =>
                {
                    const marker = new window.google.maps.Marker({
                        position: place.geometry.location,
                        map: null,
                        icon: { url: props.businessTypes[type].icon },
                        title: place.name
                    });

                    const infoWindow = new window.google.maps.InfoWindow({
                        content: `<strong>${place.name}</strong><br>${place.vicinity || ""}`
                    });

                    marker.addListener("click", () => infoWindow.open(map, marker));

                    return marker;
                });

                landmarkMarkers[type.toLowerCase()] = markers;
            }
            resolve();
        });
    });
}

// Show markers
function showBusinessMarkers()
{
    if (!markersReady.value) return;

    Object.values(landmarkMarkers).forEach(markers => markers.forEach(marker => marker.setMap(null)));
    activeMarkers = [];

    if (!selectedBusinessTypeLocal.value)
    {
        Object.keys(landmarkMarkers).forEach(type =>
        {
            landmarkMarkers[type].forEach(marker =>
            {
                marker.setMap(map);
                activeMarkers.push(marker);
            });
        });
        map.setZoom(defaultZoom);
        return;
    }

    const typeToShow = selectedBusinessTypeLocal.value.toLowerCase();
    const markers = landmarkMarkers[typeToShow] || [];

    markers.forEach(marker =>
    {
        marker.setMap(map);
        activeMarkers.push(marker);
    });

    const bounds = new window.google.maps.LatLngBounds();
    if (mainMarker?.getPosition) bounds.extend(mainMarker.getPosition());
    activeMarkers.forEach(marker => bounds.extend(marker.getPosition()));

    if (!bounds.isEmpty())
    {
        map.fitBounds(bounds);
        const listener = window.google.maps.event.addListener(map, "idle", function()
        {
            if (map.getZoom() > 19) map.setZoom(19);
            window.google.maps.event.removeListener(listener);
        });
    }
}
</script>

<style scoped>
.map-container
{
    width: 100%;
    height: 600px;
    border-radius: 16px;
    overflow: hidden;
    border: 1px solid #e0e0e0;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.badge
{
    cursor: pointer;
    font-size: 14px;
    transition: all 0.2s;
    padding: 8px 16px;
    border-radius: 25px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

.badge:hover
{
    background-color: #198754;
    color: #fff;
    transform: scale(1.05);
}

.badge.active
{
    background-color: #198754;
    color: #fff;
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
}

.landmark-icon
{
    width: 20px;
    height: 20px;
    object-fit: contain;
}

.places-list
{
    max-height: 450px;
    overflow-y: auto;
    border-radius: 12px;
    padding: 12px;
    background: #fff;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
}

.list-group-item
{
    background: #fff;
    border: none;
    padding: 8px 6px;
    border-bottom: 1px solid #f0f0f0;
    transition: background 0.2s;
}

.list-group-item:hover
{
    background-color: #f8f9fa;
}

.place-icon
{
    width: 20px;
    height: 20px;
    object-fit: contain;
    opacity: 0.85;
}
</style>
