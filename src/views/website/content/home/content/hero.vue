<template>
    <div class="position-relative text-center text-white">
        <img
            class="img-fluid w-100"
            src="../../../../../assets/images/property/residences.jpg"
            alt="Featured Property"
            style="height: 100vh; object-fit: cover; filter: brightness(50%)">

        <div class="position-absolute top-50 start-50 translate-middle text-center">
            <h1 class="display-4 fw-bold">Find the Perfect Space for your Business</h1>
            <p class="lead">Discover affordable and premium rentals near you.</p>

            <div class="mt-3">
                <div class="card card-body card-white border-0">
                    <div class="row g-3">
                        <!-- Property Type -->
                        <div class="col-md-3">
                            <!-- Updated: call redirectToListing instead of emitting 'search' -->
                            <select v-model="filters.property_type" class="form-select" @change="redirectToListing">
                                <option value="">All Property</option>
                                <option value="Office Space">Office Space</option>
                                <option value="Retail Shop">Retail Shop</option>
                                <option value="Restaurant">Restaurant</option>
                                <option value="Warehouse">Warehouse</option>
                                <option value="Industrial">Industrial</option>
                                <option value="Co-working">Co-working</option>
                                <option value="Hotel">Hotel</option>
                                <option value="Clinic">Clinic</option>
                                <option value="House">House</option>
                                <option value="Apartment">Apartment</option>
                                <option value="Townhouse">Townhouse</option>
                                <option value="Studio">Studio</option>
                                <option value="Land">Land</option>
                                <option value="Commercial">Commercial</option>
                                <option value="Parking Space">Parking Space</option>
                            </select>
                        </div>

                        <!-- Search Field -->
                        <div class="col-md-6">
                            <input
                                v-model="filters.search"
                                type="text"
                                class="form-control"
                                placeholder="Enter location or property name">
                        </div>

                        <!-- Search Button -->
                        <div class="col-md-3 d-grid">
                            <!-- Updated: call redirectToListing instead of emitting 'search' -->
                            <button type="button" class="btn btn-primary w-100" @click="redirectToListing">
                                Search
                            </button>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</template>

<script>
export default
{
    props:
    {
        filters: Object
    },

    methods:
    {
        // Added: redirect to listing page with query parameters
        redirectToListing()
        {
            const query = new URLSearchParams(this.filters).toString();
            this.$router.push(`/commercialhub/properties?${query}`);
        }
    }
}
</script>

<style>

</style>