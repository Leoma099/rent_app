<template>
    <section class="map-section mt-4">
        <!-- Nearby Area Summary -->
        <div class="landmark-summary mb-3">
            <strong>Nearby area:</strong>
            <span 
                v-for="(b, index) in property.landmarksSummary" 
                :key="index" 
                class="landmark-item">
                <img 
                    v-if="b?.icon" 
                    :src="b.icon" 
                    alt="" 
                    class="landmark-icon" />
                {{ b?.label || 'Unknown' }}
                <strong>({{ b?.count || 0 }})</strong>
            </span>
        </div>

        <!-- Map -->
        <div id="googleMap" class="map-container rounded shadow-sm"></div>

        <!-- Nearby Places -->
        <div class="places-list card border-0 shadow-sm mt-3">
            <ul class="list-group list-group-flush">
                <li 
                    v-for="(place, index) in selectedBusinessPlaces" 
                    :key="index"
                    class="list-group-item py-2">
                    <p class="mb-0 fw-semibold d-flex align-items-center">
                        <img 
                            v-if="place?.icon" 
                            :src="place.icon" 
                            alt="" 
                            class="place-icon me-2" />
                        <small>{{ place.name }}</small>
                    </p>
                    <small class="text-muted">
                        {{ place.vicinity }}
                        <span v-if="place.distance"> ({{ place.distance }})</span>
                    </small>
                </li>
            </ul>
        </div>
    </section>
</template>

<script>
export default
{
    name: "MapLocation",

    props:
    {
        property: Object,
        businessTypes: Object
    },

    data()
    {
        return {
            map: null,
            placesService: null,
            mainMarker: null,
            landmarkMarkers: {},
            activeMarkers: [],
            selectedBusinessTypeLocal: "",
            circle1km: null,
            circle10km: null,
            markersReady: false
        };
    },

    computed:
    {
        selectedBusinessPlaces()
        {
            if (!this.selectedBusinessTypeLocal)
            {
                return [].concat(
                    ...Object.values(this.property.landmarksSummary)
                        .map(l => l.places)
                );
            }

            const selected = this.property.landmarksSummary.find(
                (l) => l.type_id === this.selectedBusinessTypeLocal
            );

            return selected
                ? selected.places.map(place =>
                {
                    return {
                        name: place.name,
                        vicinity: place.vicinity,
                        distance: place.distance || ""
                    };
                })
                : [];
        }
    },

    watch:
    {
        property:
        {
            immediate: true,
            handler()
            {
                if (this.property)
                {
                    this.$nextTick(this.initMap);
                }
            }
        }
    },

    methods:
    {
        initMap()
        {
            if (!this.property) return;

            const lat = parseFloat(this.property.lat);
            const lng = parseFloat(this.property.lng);

            if (isNaN(lat) || isNaN(lng)) return;

            const center = { lat, lng };

            // Minimalist map style
            const mapStyle = [
                {
                    featureType: "all",
                    elementType: "labels.text.fill",
                    stylers: [{ color: "#333" }]
                },
                {
                    featureType: "all",
                    elementType: "labels.text.stroke",
                    stylers: [{ color: "#ffffff" }]
                },
                {
                    featureType: "poi",
                    elementType: "labels.icon",
                    stylers: [{ visibility: "off" }]
                },
                {
                    featureType: "road",
                    elementType: "geometry",
                    stylers: [{ color: "#e6e6e6" }]
                },
                {
                    featureType: "water",
                    elementType: "geometry.fill",
                    stylers: [{ color: "#d6e6f2" }]
                },
                {
                    featureType: "landscape",
                    elementType: "geometry.fill",
                    stylers: [{ color: "#f8f8f8" }]
                }
            ];

            this.map = new window.google.maps.Map(document.getElementById("googleMap"), {
                center,
                zoom: 14, // ✅ good for city/town level
                styles: mapStyle,
                scrollwheel: false,
                zoomControl: true,
                streetViewControl: false,
                mapTypeControl: false,
                fullscreenControl: false
            });


            this.mainMarker = new window.google.maps.Marker(
            {
                position: center,
                map: this.map,
                title: this.property.title || "Property",
                icon: { url: "http://maps.google.com/mapfiles/ms/icons/red-dot.png" },
                zIndex: 9999
            });

            this.placesService = new window.google.maps.places.PlacesService(this.map);

            this.landmarkMarkers = {};
            this.property.landmarksSummary = [];
            this.activeMarkers = [];

            this.drawSearchCircles(center);

            const fetchPromises = Object.keys(this.businessTypes).map(type =>
            {
                return this.fetchBusinessDensity(center, type);
            });

            Promise.all(fetchPromises).then(() =>
            {
                this.markersReady = true;
                this.showBusinessMarkers();
            });
        },

        drawSearchCircles(center)
        {
            if (this.circle1km) this.circle1km.setMap(null);
            if (this.circle10km) this.circle10km.setMap(null);

            const latLng = new window.google.maps.LatLng(center.lat, center.lng);

            this.circle1km = new window.google.maps.Circle(
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

            this.circle10km = new window.google.maps.Circle(
            {
                strokeColor: "#28a745",
                strokeOpacity: 0.5,
                strokeWeight: 2,
                fillColor: "#28a745",
                fillOpacity: 0.05,
                map: this.map,
                center: latLng,
                radius: 10000
            });
        },

        fetchBusinessDensity(center, type)
        {
            return new Promise(resolve =>
            {
                const request = { location: center, radius: 1000, type };

                this.placesService.nearbySearch(request, (results, status) =>
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

                        const summary =
                        {
                            type_id: type,
                            label: this.businessTypes[type].name,
                            icon: this.businessTypes[type].icon,
                            count: results.length,
                            places: placesWithDistance
                        };

                        this.property.landmarksSummary.push(summary);

                        const markers = results.map(place =>
                        {
                            const marker = new window.google.maps.Marker({
                                position: place.geometry.location,
                                map: null,
                                icon: { url: this.businessTypes[type].icon },
                                title: place.name
                            });

                            const infoWindow = new window.google.maps.InfoWindow(
                            {
                                content: "<strong>" + place.name + "</strong><br>" + (place.vicinity || "")
                            });

                            marker.addListener("click", () =>
                            {
                                infoWindow.open(this.map, marker);
                            });

                            return marker;
                        });

                        this.landmarkMarkers[type] = markers;
                    }

                    resolve();
                });
            });
        },

        showBusinessMarkers()
        {
            if (!this.markersReady) return;

            Object.values(this.landmarkMarkers).forEach(markers =>
            {
                markers.forEach(marker => marker.setMap(null));
            });

            this.activeMarkers = [];

            let typesToShow = [];

            if (this.selectedBusinessTypeLocal)
            {
                const selectedTypeObj = this.property.landmarksSummary.find(
                    l => l.type_id === this.selectedBusinessTypeLocal
                );

                if (selectedTypeObj)
                {
                    typesToShow.push(selectedTypeObj.type_id);
                }
            }
            else
            {
                typesToShow = Object.keys(this.landmarkMarkers);
            }

            typesToShow.forEach(type =>
            {
                const markers = this.landmarkMarkers[type] || [];

                markers.forEach(marker =>
                {
                    marker.setMap(this.map);
                    this.activeMarkers.push(marker);
                });
            });

            const bounds = new window.google.maps.LatLngBounds();

            if (this.mainMarker?.getPosition)
            {
                bounds.extend(this.mainMarker.getPosition());
            }

            this.activeMarkers.forEach(marker => bounds.extend(marker.getPosition()));

            try
            {
                this.map.fitBounds(bounds);
            }
            catch (e)
            {
                this.map.setCenter(this.mainMarker.getPosition());
                this.map.setZoom(14);
            }
        }
    }
};
</script>

<style scoped>
.map-section 
{
    font-family: "Inter", sans-serif;
    color: #333;
}

.landmark-summary 
{
    font-size: 0.95rem;
}

.landmark-item 
{
    display: inline-flex;
    align-items: center;
    background: #f8f9fa;
    border-radius: 20px;
    padding: 4px 10px;
    margin: 0 5px 5px 0;
    transition: background 0.2s;
}

.landmark-item:hover 
{
    background: #e9ecef;
}

.landmark-icon 
{
    width: 18px;
    height: 18px;
    margin-right: 6px;
    vertical-align: middle;
}

.map-container 
{
    width: 100%;
    height: 350px;
    border-radius: 12px;
    overflow: hidden;
}

.places-list 
{
    max-height: 300px;
    overflow-y: auto;
    border-radius: 10px;
}

.list-group-item 
{
    background: #fff;
    border: none;
    border-bottom: 1px solid #f0f0f0;
}

.list-group-item:last-child 
{
    border-bottom: none;
}

.place-icon 
{
    width: 18px;
    height: 18px;
    object-fit: contain;
    opacity: 0.7;
}

::-webkit-scrollbar 
{
    width: 6px;
}

::-webkit-scrollbar-thumb 
{
    background: #ccc;
    border-radius: 10px;
}

@media (max-width: 768px) 
{
    .map-container 
    {
        height: 300px;
    }

    .places-list 
    {
        max-height: 250px;
    }
}
</style>
