<template>
    <div>
        <h3>Location & Nearby Amenities</h3>

        <!-- DROPDOWN FILTER -->
        <div class="filter-container d-flex align-items-center gap-2 mb-3">
            <select v-model="selectedType" @change="renderMarkers" class="dropdown flex-grow-1">
                <option value="">View All</option>
                <option
                    v-for="c in categories"
                    :key="c.type"
                    :value="c.type"
                >
                    {{ c.label }}
                </option>
            </select>
        </div>

        <!-- CATEGORY BADGES -->
        <div class="badges">
            <span
                v-for="c in categories"
                :key="c.type"
                @click="selectCategory(c.type)"
                class="badge"
                :class="{ active: selectedType === c.type }"
            >
                <img :src="c.icon" class="icon" /> {{ c.label }}
            </span>
        </div>

        <!-- MAP -->
        <div ref="mapRef" class="map-box"></div>
    </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import { loadGoogleMaps } from "@/utils/loadGoogleMap";

const mapRef = ref(null);
let map;
let markers = [];

const API_KEY = "AIzaSyCn9IGzgS41HOIRhMz_-RXlodu0mqsTgyU";

const categories =
[
    { type: "bank", label: "Bank", icon: "https://maps.gstatic.com/mapfiles/ms2/micons/blue.png" },
    { type: "restaurant", label: "Restaurant", icon: "https://maps.gstatic.com/mapfiles/ms2/micons/red.png" },
    { type: "store", label: "Store", icon: "https://maps.gstatic.com/mapfiles/ms2/micons/green.png" },
];

const selectedType = ref("");

const places =
{
    bank:
    [
        { name: "BDO Bank", lat: 15.3278, lng: 120.6089 },
        { name: "BPI Bank", lat: 15.3285, lng: 120.6101 }
    ],
    restaurant:
    [
        { name: "Jollibee", lat: 15.3268, lng: 120.6108 },
        { name: "Mcdo", lat: 15.3272, lng: 120.6115 }
    ],
    store:
    [
        { name: "7-Eleven", lat: 15.3291, lng: 120.6099 }
    ]
};

onMounted(async () =>
{
    try
    {
        const google = await loadGoogleMaps(API_KEY);

        map = new google.maps.Map(mapRef.value,
        {
            center:
            {
                lat: 15.3275,
                lng: 120.6094
            },
            zoom: 15,
            mapTypeId: "roadmap"
        });

        renderMarkers();
    }
    catch (err)
    {
        console.error("Google Maps failed to load:", err);
    }
});

watch(selectedType, () =>
{
    renderMarkers();
});

function renderMarkers()
{
    markers.forEach(m => m.setMap(null));
    markers = [];

    const type = selectedType.value;
    const list = type ? places[type] : Object.values(places).flat();

    list.forEach(p =>
    {
        const icon = categories.find(c => c.type === type)?.icon || null;

        const marker = new window.google.maps.Marker(
        {
            position:
            {
                lat: p.lat,
                lng: p.lng
            },
            map,
            title: p.name,
            icon: icon || undefined,
        });

        markers.push(marker);
    });
}

function selectCategory(type)
{

    selectedType.value = type;
}
</script>

<style scoped>
.map-box
{
    width: 100%;
    height: 420px;
    border-radius: 12px;
    margin-top: 12px;
    border: 1px solid #ddd;
    box-shadow: 0 2px 8px rgba(0,0,0,0.12);
}

.filter-container
{
    display: flex;
    align-items: center;
    gap: 8px;
}

.dropdown
{
    padding: 8px 12px;
    font-size: 14px;
    border-radius: 6px;
    border: 1px solid #ccc;
    outline: none;
    cursor: pointer;
    background-color: #fff;
    transition: border-color 0.2s;
}

.dropdown:hover
{
    border-color: #198754;
}

.btn-clear
{
    padding: 6px 10px;
    font-size: 14px;
    border-radius: 6px;
    border: 1px solid #dc3545;
    background: #fff;
    color: #dc3545;
    cursor: pointer;
    transition: all 0.2s;
}

.btn-clear:hover
{
    background: #dc3545;
    color: #fff;
}

.badges
{
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    margin-bottom: 12px;
    position: relative;  /* add this */
    z-index: 10;         /* make sure it is above the map */
}

.badge
{
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 6px 14px;
    background: #eee;
    border-radius: 20px;
    cursor: pointer;
    font-size: 14px;
    transition: all 0.2s;
}

.badge:hover
{
    background-color: #d6d6d6;
}

.badge.active
{
    background-color: #198754;
    color: #fff;
}

.icon
{
    width: 16px;
    height: 16px;
}
</style>
