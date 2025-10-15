<template>
  
    <div class="mb-3">

        <li>
            <router-link
                exact-active-class="active"
                :to="'/landlord/dashboard'">
                <i class="bx bx-category me-2"></i>Dashboard
            </router-link>
        </li>

        <li>
            <router-link
                exact-active-class="active"
                :to="'/landlord/properties'">
                <i class="bx bx-category me-2"></i>Properties
            </router-link>
        </li>

        <li>
            <router-link
                exact-active-class="active"
                :to="'/landlord/booking-schedule'">
                <i class="bx bx-category me-2"></i>Booking Schedule
            </router-link>
        </li>

        <li>
            <router-link
                exact-active-class="active"
                :to="'/landlord/inquiries'">
                <i class="bx bx-category me-2"></i>Inquiries
            </router-link>
        </li>

        <li>
            <router-link
                exact-active-class="active"
                :to="'/landlord/leases'">
                <i class="bx bx-category me-2"></i>Leases
            </router-link>
        </li>

    </div>

</template>

<script>
export default
{

}
</script>

<style scoped>
ul.dropdown {
  max-height: 0;
  overflow: hidden;
  transition: all 0.3s ease-in-out;
  opacity: 0;
}

ul.dropdown.open {
  max-height: 500px; /* Adjust to fit your content */
  opacity: 1;
}
</style>