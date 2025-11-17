<template>
    <div class="position-relative text-center text-white hero-container">
        <img
            class="img-fluid w-100 hero-image"
            src="../../../../../assets/images/property/residences.jpg"
            alt="Featured Property">

        <div class="position-absolute hero-text text-center">
            <h1 class="hero-title fw-bold">Find the Perfect Space for your Business</h1>
            <p class="hero-subtitle">Discover affordable and premium rentals near you.</p>

            <div class="mt-3">
                <div class="card card-body card-white border-0 filter-card shadow-sm">
                    <div class="row g-3 align-items-center">
                        <!-- Property Type -->
                        <div class="col-12 col-md-2">
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

                        <div class="col-12 col-md-2 select-wrapper">
                            <select
                                v-model="filters.barangay"
                                class="form-select" @change="redirectToListing">
                                <option value="">All Barangay</option>
                                <option value="ARANGUREN">ARANGUREN</option>
                                <option value="BUENO">BUENO</option>
                                <option value="CRISTO REY">CRISTO REY</option>
                                <option value="CUBCUB">CUBCUB</option>
                                <option value="CUTCUT I">CUTCUT I</option>
                                <option value="CUTCUT II">CUTCUT II</option>
                                <option value="DOLORES">DOLORES</option>
                                <option value="ESTRADA">ESTRADA</option>
                                <option value="LAWY">LAWY</option>
                                <option value="MANGA">MANGA</option>
                                <option value="MANLAPIG">MANLAPIG</option>
                                <option value="MARUGLU">MARUGLU</option>
                                <option value="O’DONNELL">O’DONNELL</option>
                                <option value="STA. JULIANA">STA. JULIANA</option>
                                <option value="STA. LUCIA">STA. LUCIA</option>
                                <option value="STA. RITA">STA. RITA</option>
                                <option value="STO. DOMINGO I">STO. DOMINGO I</option>
                                <option value="STO. DOMINGO II">STO. DOMINGO II</option>
                                <option value="STO. ROSARIO">STO. ROSARIO</option>
                                <option value="TALAGA">TALAGA</option>
                            </select>
                        </div>

                        <!-- Search Field -->
                        <div class="col-12 col-md-6">
                            <input
                                v-model="filters.search"
                                type="text"
                                class="form-control"
                                placeholder="Enter location or property name">
                        </div>

                        <!-- Search Button -->
                        <div class="col-12 col-md-2 d-grid">
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
        filters:
        {
            type: Object,
            default: () => ({ property_type: "", barangay: "", search: "" })
        }
    },

    methods:
    {
        redirectToListing()
        {
            const query = new URLSearchParams(this.filters).toString();
            this.$router.push(`/commercialhub/properties?${query}`);
        }
    }
}
</script>

<style scoped>
.hero-container
{
    position: relative;
    overflow: hidden;
}

.hero-image
{
    width: 100%;
    height: 50vh;
    object-fit: cover;
    filter: brightness(50%);
    transition: height 0.3s ease;
}

.hero-text
{
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    padding: 0 15px;
    width: 100%;
}

.hero-title
{
    font-size: 2.2rem;
    line-height: 1.2;
}

.hero-subtitle
{
    font-size: 1.2rem;
    line-height: 1.4;
    margin-top: 0.5rem;
}

.filter-card
{
    padding: 1rem;
    border-radius: 0.5rem;
    max-width: 980px;
    margin: 0 auto;
}

/* Responsive adjustments */
@media (max-width: 992px)
{
    .hero-image
    {
        height: 55vh;
    }

    .hero-title
    {
        font-size: 1.9rem;
    }

    .hero-subtitle
    {
        font-size: 1.1rem;
    }
}

@media (max-width: 768px)
{
    .hero-image
    {
        height: 65vh;
    }

    .hero-text
    {
        top: 40%;
        transform: translate(-50%, 0);
    }

    .hero-title
    {
        font-size: 1.6rem;
    }

    .hero-subtitle
    {
        font-size: 1rem;
    }

    .filter-card .row > div
    {
        margin-bottom: 0.5rem;
    }

    .filter-card select,
    .filter-card input,
    .filter-card button
    {
        width: 100%;
    }
}

@media (max-width: 576px)
{
    .hero-image
    {
        height: 70vh;
    }

    .hero-title
    {
        font-size: 1.4rem;
    }

    .hero-subtitle
    {
        font-size: 0.95rem;
    }
}

.select-wrapper
{
    overflow: visible !important;
}
</style>
