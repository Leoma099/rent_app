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
                <h2 class="fw-bold mb-0">Reset Password</h2>
            </div>

            <!-- Login Form -->
            <form @submit.prevent="submit()">
                <!-- Username -->
                <div class="position-relative mb-3">
                    <input
                        :type="showPassword ? 'text' : 'password'"
                        id="password"
                        v-model="form.password"
                        class="form-control pe-5"
                        placeholder="Enter your password"
                        required
                    />

                    <span
                        class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                        @click="togglePassword"
                        style="user-select: none;"
                    >
                        {{ showPassword ? 'Hide' : 'Show' }}
                    </span>
                </div>

                <!-- ✅ Simplified password validation -->
                <ul class="list-unstyled mt-2 small">
                    <li :class="{'text-success fw-bold': passwordChecks.minLength, 'text-danger': !passwordChecks.minLength}">
                        {{ passwordChecks.minLength ? '✓' : '•' }} At least 8 characters
                    </li>
                    <li :class="{'text-success fw-bold': passwordChecks.uppercase, 'text-danger': !passwordChecks.uppercase}">
                        {{ passwordChecks.uppercase ? '✓' : '•' }} 1 uppercase letter
                    </li>
                    <li :class="{'text-success fw-bold': passwordChecks.numberOrSymbol, 'text-danger': !passwordChecks.numberOrSymbol}">
                        {{ passwordChecks.numberOrSymbol ? '✓' : '•' }} Contains a number or symbol
                    </li>
                </ul>

                <div class="position-relative my-3">
                    <input
                        :type="showPassword ? 'text' : 'password'"
                        id="password"
                        v-model="form.password_confirmation"
                        class="form-control pe-5"
                        placeholder="Enter your confirm password"
                        required
                    />

                    <span
                        class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                        @click="toggleConfirmPassword"
                        style="user-select: none;"
                    >
                        {{ showConfirmPassword ? 'Hide' : 'Show' }}
                    </span>
                </div>

                <!-- Login Button -->
                <button
                    type="submit"
                    class="btn btn-primary w-100 mb-3"
                    :disabled="isLoading"
                >
                    <span v-if="!isLoading">Reset password</span>
                    <span v-else>Reset password...</span>
                </button>
            </form>

            <!-- Links -->
            <div class="text-center">
                <a href="/signin">Back to sign in</a>
            </div>
        </div>
    </div>

</template>

<script>
import apiClient from "@/services/index";
import { useToast } from "vue-toastification";
import { useRoute } from "vue-router";
export default
{
    data()
    {
        return {
            form:
            {
                email: "",
                token: "",
                password: "",
                password_confirmation: "",
            },
            isLoading: false,
            showPassword: false,
            showConfirmPassword: false,
        };
    },

    created()
    {
        this.toast = useToast();

        const route = useRoute();
        this.form.email = route.query.email || "";
        this.form.token = route.query.token || "";
    },

    computed:
    {
        passwordChecks()
        {
            const password = this.form.password;
            return {
                minLength: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                numberOrSymbol: /[0-9@$!%*?&]/.test(password)
            };
        }
    },

    methods:
    {
        async submit()
        {
            this.isLoading = true;
            this.errors = {};

            try
            {
                const response = await apiClient.post("/reset-password", this.form);
                this.toast.success(response.data.message);
                this.$router.push("/signin");
            }
            catch (error)
            {
                this.toast.error(error.response?.data?.message || "Reset failed");
            }
            finally
            {
                this.isLoading = false;
            }
        },

        togglePassword()
        {
            this.showPassword = !this.showPassword;
        },

        toggleConfirmPassword()
        {
            this.showConfirmPassword = !this.showConfirmPassword;
        }
    }
};
</script>

<style scoped>
.animation
{
    animation-duration: 1s;
    animation-fill-mode: none;
}

.animation-fade-in
{
    animation-name: fadeIn;
}

@keyframes fadeIn
{
    from
    {
        opacity: 0;
    }
    to
    {
        opacity: 1;
    }
}

.container
{
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

.box-area
{
    width: 930px;
}

.right-box
{
    padding: 40px;
}

.button-signin
{
    border: 2px solid #ffffff;
    color: #ffffff;
    transition: all 0.2s ease-in-out;
}

.button-signin:hover
{
    background: #ffffff;
    color: #007bff;
    font-weight: 600;
}

.login-image
{
    width: 400px;
    overflow: hidden;
    text-align: center;
    margin: 0 auto;
    display: flex;
    justify-content: center;
    align-items: center;
}

.login-image img
{
    width: 100%;
    object-fit: cover;
}

/* Add styles for the loading spinner */
.loading-overlay
{
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 255, 255, 0.7);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.spinner
{
    border: 4px solid #f3f3f3; /* Light grey */
    border-top: 4px solid #3498db; /* Blue */
    border-radius: 50%;
    width: 40px;
    height: 40px;
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
</style>
