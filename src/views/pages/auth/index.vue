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
                <h6 class="mb-0">Welcome to</h6>
                <h2 class="fw-bold mb-1">Commercial Hub</h2>
            </div>

            <!-- Login Form -->
            <form @submit.prevent="submit()">
                <!-- Username -->
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input
                        type="text"
                        id="username"
                        v-model="form.username"
                        class="form-control"
                        placeholder="Enter your username"
                        required
                    />
                </div>

                <!-- Password -->
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>

                    <!-- ✅ Wrap input + show button in position-relative -->
                    <div class="position-relative">
                        <input
                            :type="showPassword ? 'text' : 'password'"
                            id="password"
                            v-model="form.password"
                            class="form-control pe-5"
                            placeholder="Enter your password"
                            required
                        />

                        <!-- ✅ This is the SHOW/HIDE toggle -->
                        <span
                            class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                            @click="togglePassword"
                            style="user-select: none;"
                        >
                            {{ showPassword ? 'Hide' : 'Show' }}
                        </span>
                    </div>
                </div>

                <!-- Login Button -->
                <button
                    type="submit"
                    class="btn btn-primary w-100 mb-3"
                    :disabled="isLoading"
                >
                    <span v-if="!isLoading">Sign In</span>
                    <span v-else>Signing in...</span>
                </button>
            </form>

            <!-- Links -->
            <div class="text-center">
                <p class="mb-1 small">
                    New member? <a href="/registration">Register here</a>
                </p>
                <p class="mb-1 small">
                    Forgot your password? <a href="/forgot-password">Recover account</a>
                </p>
                <p class="mb-0 small">
                    Visit our website
                    <router-link :to="'/commercialhub'">
                        Commercial Hub
                    </router-link>
                </p>
            </div>
        </div>
    </div>

</template>

<script>
import apiClient from "@/services/index";
import { useToast } from "vue-toastification";

export default
{
    data()
    {
        return {
            form: {
                username: "",
                password: "",
            },
            isLoading: false,
            showPassword: false, // ✅ Added for toggling password visibility
            errors: {} // ✅ Added for error validation tracking
        };
    },

    created()
    {
        this.toast = useToast();
    },

    methods:
    {
        async submit()
        {
            this.isLoading = true;
            this.errors = {};

            try
            {
                const response = await apiClient.post('/login', this.form);

                localStorage.setItem('access_token', response.data.token);
                localStorage.setItem('role', response.data.role);
                localStorage.setItem("user_id", response.data.id);

                // ACCOUNT INFO
                localStorage.setItem("account", response.data.account ? response.data.account.id : "");
                localStorage.setItem('full_name', response.data.full_name);
                localStorage.setItem('id_number', response.data.id_number);
                localStorage.setItem('office_name', response.data.office_name);
                localStorage.setItem('office_address', response.data.office_address);
                localStorage.setItem('position', response.data.position);
                localStorage.setItem('mobile_number', response.data.mobile_number);
                localStorage.setItem('username', response.data.username);
                localStorage.setItem('email', response.data.email);
                localStorage.setItem('address', response.data.address);

                // Redirect based on role
                setTimeout(() =>
                {
                    if (response.data.role === 1 || response.data.role === 2)
                    {
                        this.$router.push('/dashboard');
                    }
                    else if (response.data.role === 3)
                    {
                        this.$router.push('/commercialhub');
                    }
                }, 1000);

                this.toast.success("Login successfully!");
            }
            catch (error)
            {
                this.isLoading = false;
                this.errors = {};

                const status = error.response?.status;
                const message = error.response?.data?.error || "Login failed";

                if (status === 401)
                {
                    this.toast.error("Login unsuccessful! Wrong username or password.");
                }
                else if (status === 403)
                {
                    this.toast.error("Your account is not activated yet.");
                }
                else
                {
                    this.toast.error("Login unsuccessful! Please try again.");
                }

                console.error('Login failed:', message);
            }
            finally
            {
                this.isLoading = false;
            }
        },

        togglePassword()
        {
            this.showPassword = !this.showPassword;
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
