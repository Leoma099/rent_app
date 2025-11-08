<template>
    <div v-if="isLoading" class="loading-overlay">
        <div class="spinner"></div>
    </div>

    <div class="login-page d-flex justify-content-center align-items-center vh-100" :style="{ backgroundColor: '#faf9f6' }">
        <div class="card shadow-sm border-0 p-4" style="width: 380px;">
            <div class="text-center mb-3">
                <img src="@/assets/images/capas_logo.png" alt="Logo" width="80" />
            </div>

            <div class="text-center mb-3">
                <h6 class="mb-0">Welcome to</h6>
                <h2 class="fw-bold mb-1">Commercial Hub</h2>
            </div>

            <form @submit.prevent="submit()">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input
                        type="text"
                        id="username"
                        v-model="form.username"
                        class="form-control"
                        placeholder="Enter your username"
                    />
                    <small v-if="errors.username" class="text-danger">{{ errors.username }}</small>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <div class="position-relative">
                        <input
                            :type="showPassword ? 'text' : 'password'"
                            id="password"
                            v-model="form.password"
                            class="form-control pe-5"
                            placeholder="Enter your password"
                        />
                        <span
                            class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                            @click="togglePassword"
                            style="user-select: none;"
                        >
                            {{ showPassword ? 'Hide' : 'Show' }}
                        </span>
                    </div>
                    <small v-if="errors.password" class="text-danger">{{ errors.password }}</small>
                </div>

                <button
                    type="submit"
                    class="btn btn-primary w-100 mb-3"
                    :disabled="isLoading"
                >
                    <span v-if="!isLoading">Sign In</span>
                    <span v-else>Signing in...</span>
                </button>
            </form>

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
            form:
            {
                username: "",
                password: "",
            },
            isLoading: false,
            showPassword: false,
            errors: {}
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
            this.errors = {};

            if (!this.form.username)
            {
                this.errors.username = "Username is required";
            }

            if (!this.form.password)
            {
                this.errors.password = "Password is required";
            }

            if (Object.keys(this.errors).length)
            {
                return;
            }

            this.isLoading = true;

            try
            {
                const response = await apiClient.post('/login', this.form);

                localStorage.setItem('access_token', response.data.token);
                localStorage.setItem('role', response.data.role);
                localStorage.setItem("user_id", response.data.id);
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
                const status = error.response?.status;
                const message = error.response?.data?.error || "Login failed";

                if (status === 401)
                {
                    this.errors.password = "Incorrect password";
                    this.form.password = "";
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
    border: 4px solid #f3f3f3;
    border-top: 4px solid #3498db;
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

.text-danger
{
    font-size: 0.8rem;
}
</style>