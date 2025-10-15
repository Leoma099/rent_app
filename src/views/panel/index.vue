<template>
  <!-- Not logged in -->
  <div v-if="!accessToken">
    <signin-component />
  </div>

  <!-- Logged in: role 1 = admin, 2 = landlord -->
  <div v-else-if="role === 1 || role === 2">
    <sidebar-component />
    <div class="main-wrapper">
      <header-component />
      <div class="main">
        <router-view /> <!-- dashboard content here -->
      </div>
    </div>
  </div>

  <!-- Logged in: role 3 = tenant -->
  <div v-else-if="role === 3">
    <router-view /> <!-- tenant sees website only -->
  </div>
</template>

<script>
import SidebarComponent from "@/views/layouts/sidebar";
import HeaderComponent from "@/views/layouts/header";
import SigninComponent from "@/views/pages/auth";

export default {
  components: {
    SidebarComponent,
    HeaderComponent,
    SigninComponent,
  },
  data() {
    return {
      accessToken: localStorage.getItem("access_token"),
      role: parseInt(localStorage.getItem("role")) || null,
    };
  },
};
</script>
