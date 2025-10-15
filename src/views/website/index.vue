<template>

    <div class="animate animate-fade-in">

        <header-component />

        <main>

            <home-page-component v-if="$route.meta.page === 'commercialhub'" />
            <view-page-component v-if="$route.meta.page === 'view'" />
            <account-page-component v-if="$route.meta.page === 'profile'" />
            <notification-page-component v-if="$route.meta.page === 'notification'" />
            <favorite-page-component v-if="$route.meta.page === 'favorite'" />
            <listing-properties-page-component v-if="$route.meta.page === 'listing-properties'" />

        </main>

        <footer-component />

    </div>

</template>

<script>
import HeaderComponent from "./content/header";
import HomePageComponent from "./content/home";
import ViewPageComponent from "./content/view";
import AccountPageComponent from "./content/account";
import NotificationPageComponent from "./content/notification";
import FavoritePageComponent from "./content/favorite";
import ListingPropertiesPageComponent from "./content/properties";
import FooterComponent from "./content/footer";
export default
{

    components:
    {
        HeaderComponent,
        HomePageComponent,
        ViewPageComponent,
        AccountPageComponent,
        NotificationPageComponent,
        FavoritePageComponent,
        ListingPropertiesPageComponent,
        FooterComponent
    }
}
</script>

<style scoped>
main
{
    min-height: 100vh;
}
</style>