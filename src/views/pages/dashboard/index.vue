<template>
    <div class="animation animation-fade-in">
        <h1 class="mb-0">DASHBOARD</h1>
    </div>
</template>

<script>
export default {
    data() {
        return {
            // Get role from localStorage as an integer (parse it)
            role: parseInt(localStorage.getItem("role")) || 0, // Default to 0 (guest) if role not found
        };
    },

    mounted() {
        this.initialized();
    },

    methods: {
        initialized() {
            if (this.role === 1) {  // Now correctly compares numbers
                window.location.href = "/administration/dashboard";
            } else if (this.role === 2) {
                window.location.href = "/landlord/dashboard";
            } else if (this.role === 3) {
                window.location.href = "/commercialhub";
            }
        }
    }
};
</script>

<style scoped>
.animation {
    animation-duration: 1s;
    animation-fill-mode: none;
}
.animation-fade-in {
    animation-name: fadeIn;
}

@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}
</style>
