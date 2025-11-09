<template>

    <div v-if="isLoading" class="loading-overlay">
        <div class="spinner"></div>
    </div>

    <div class="login-page d-flex justify-content-center align-items-center vh-100" :style="{ backgroundColor: '#faf9f6' }">
        <div class="card shadow-sm border-0 p-4" style="width: 380px;">
            <!-- Logo -->
            <div class="text-center mb-3">
                <img src="@/assets/images/capas_logo.png" alt="Logo" width="80" />
            </div>

            <!-- Title & Header -->
            <div class="text-center mb-3">
                <h2 class="fw-bold mb-0">Forgot Password</h2>
                <p class="mb-0 text-secondary">Reset password link will be sent to your email</p>
            </div>

            <!-- Forgot Password Form -->
            <form @submit.prevent="submitEmail">
                <div class="mb-3">
                    <input
                        type="email"
                        v-model="email"
                        class="form-control form-control-lg"
                        placeholder="Enter your email address"
                        required
                    />
                </div>

                <button
                    type="submit"
                    class="btn btn-primary w-100 mb-3"
                    :disabled="isLoading"
                >
                    <span v-if="!isLoading">Send Email</span>
                    <span v-else>Sending...</span>
                </button>
            </form>

            <!-- Links -->
            <div class="text-center">
                <a href="/signin" class="text-decoration-none">Back to sign in</a>
            </div>

            <!-- Feedback -->
            <p v-if="message" class="text-center text-success mt-2">{{ message }}</p>
            <p v-if="error" class="text-center text-danger mt-2">{{ error }}</p>
        </div>
    </div>

</template>

<script>
import apiClient from "@/services/index"; // Axios instance
import { useToast } from "vue-toastification";

export default
{
    data()
    {
        return{
            email: "",
            isLoading: false,
            message: "",
            error: ""
        };
    },

    created()
    {
        this.toast = useToast();
    },

    methods:
    {
        async submitEmail()
        {
            this.isLoading = true;
            this.message = "";
            this.error = "";

            try
            {
                const response = await apiClient.post('/forgot-password', 
                { 
                    email: this.email 
                });

                this.message = response.data.message;
                this.toast.success(this.message);
                this.email = "";
            }
            catch (err)
            {
                this.error = err.response?.data?.message || "Failed to send email";
                this.toast.error(this.error);
            }
            finally
            {
                this.isLoading = false;
            }
        }
    }
};
</script>

<style scoped>
.loading-overlay
{
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255,255,255,0.8);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.spinner
{
    border: 4px solid #f3f3f3;
    border-top: 4px solid #3498db;
    border-radius: 50%;
    width: 45px;
    height: 45px;
    animation: spin 1s linear infinite;
}

@keyframes spin
{
    0%
    {
        transform: rotate(0deg);
    }
    100%
    {
        transform: rotate(360deg);
    }
}

.login-page input:disabled
{
    background-color: #e9ecef;
    cursor: not-allowed;
}
</style>