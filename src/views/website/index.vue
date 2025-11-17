<template>
  <div class="page-wrapper animate animate-fade-in">

    <header-component />

    <main>
      <home-page-component v-if="$route.meta.page === 'commercialhub'" />
      <view-page-component v-if="$route.meta.page === 'view'" />
      <account-page-component v-if="$route.meta.page === 'profile'" />
      <notification-page-component v-if="$route.meta.page === 'notification'" />
      <favorite-page-component v-if="$route.meta.page === 'favorite'" />
      <message-page-component v-if="$route.meta.page === 'message'" />
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
import MessagePageComponent from "./content/message";
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
        MessagePageComponent,
        ListingPropertiesPageComponent,
        FooterComponent,
    },
};
</script>

<style scoped>
/* Make the page a vertical flex container */
.page-wrapper
{
    display: flex;
    flex-direction: column;
    min-height: 100vh; /* ensure full viewport height */
}

/* Main content takes remaining space */
main
{
    flex: 1;            /* grows to fill space between header and footer */
    overflow-y: auto;   /* scroll if content is taller than viewport */
}
</style>
