<template>

<nav class="navbar navbar-expand-lg shadow-sm" style="background-color: #000080;">
        <div class="container">
            <!-- Left Logo -->
            <router-link :to="'/commercialhub'">
                <img src="@/assets/images/capas_logo.png" alt="" width="30">
            </router-link>

            <button
                class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarNav"
                aria-controls="navbarNav"
                aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Right Navigation -->
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav d-flex align-items-center">

                    <!-- Always visible link -->
                    <li class="nav-item">
                        <router-link class="nav-link text-white" :to="'/commercialhub'">
                            <i class="bx bx-home me-1"></i>
                            <span>Home</span>
                        </router-link>
                    </li>

                    <li class="nav-item">
                        <router-link class="nav-link d-flex align-items-center text-white" :to="'/commercialhub/properties'">
                            <i class="bx bx-building-house me-1"></i>
                            <span>Properties</span>
                        </router-link>
                    </li>

                    <li
                        class="nav-item position-relative"
                        v-if="!isLoggedIn">
                    </li>

                    <li class="nav-item position-relative" v-else>
                        <router-link class="nav-link text-white" :to="'/notification'">
                            <i class="bx bx-bell"></i>
                            <span v-if="notificationCount > 0" class="badge">{{ notificationCount }}</span>
                        </router-link>
                    </li>

                    <li v-if="!isLoggedIn" class="nav-item">
                        <div class="d-flex align-items-center">
                            <router-link class="nav-link text-white" :to="'/signin'">Login</router-link>
                            /<router-link class="nav-link text-white" :to="'/registration'">Register</router-link>
                        </div>
                    </li>

                    <li v-else class="nav-item dropdown">
                        <a
                            class="nav-link text-white"
                            href="#"
                            role="button"
                            data-bs-toggle="dropdown"
                            aria-expanded="false">
                            <i class="bx bx-user"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end rounded-0 mt-4" style="height: auto;">
                            <li class="m-0">
                                <router-link class="dropdown-item d-flex align-items-center" :to="`/account/profile`">
                                    <i class="bx bx-user me-2"></i>
                                    <span>My Profile</span>
                                </router-link>
                            </li>
                            <li class="m-0">
                                <router-link class="dropdown-item d-flex align-items-center" :to="`/favorite`">
                                    <i class="bx bx-heart me-2"></i>
                                <span>Saved Properties</span>
                            </router-link>
                            </li>
                            <li class="m-0">
                                <router-link class="dropdown-item d-flex align-items-center" :to="`/message`">
                                    <i class="bx bx-message me-2"></i>
                                    <span>Messages</span>
                                </router-link>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center" href="#" @click.prevent="logout">
                                    <i class="bx bx-log-out me-2"></i>
                                    <span>Logout</span>
                                </a>
                            </li>
                        </ul>
                    </li>

                </ul>
            </div>
        </div>
    </nav>

</template>

<script>
export default {

}
</script>

<style>

</style>