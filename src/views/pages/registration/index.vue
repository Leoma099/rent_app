<template>

    <div v-if="isLoading" class="loading-overlay">
        <div class="spinner"></div>
    </div>

    <div class="login-page d-flex justify-content-center align-items-center vh-100" :style="{ backgroundColor: '#faf9f6' }">
        <div class="card shadow-sm border-0 p-4" style="width: 700px;">
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

                <div class="row mb-3">
                    <div class="col-md-8">
                        <label for="name" class="form-label">Full Name</label>
                        <input
                            type="text"
                            id="name"
                            v-model="form.full_name"
                            class="form-control"
                            placeholder="Enter your full name"
                            required/>
                    </div>
                    <div class="col-md-4">
                        <label for="name" class="form-label">What are you?</label>
                        <select class="form-select" v-model="form.role" required>
                            <option value="" disabled selected>- select role -</option>
                            <option value="2">Landlord</option>
                            <option value="3">Renter</option>
                        </select>
                    </div>
                </div>

                <div class="row mb-3">

                    <div class="col-md-7">
                        <label for="email" class="form-label">Email Address</label>
                        <input
                            type="text"
                            id="email"
                            v-model="form.email"
                            class="form-control"
                            placeholder="Enter your email address"
                            required
                        />
                    </div>

                    <div class="col-md-5">
                        <label for="mobile_number" class="form-label">Mobile Number</label>
                        <input
                            type="text"
                            id="mobile_number"
                            v-model="form.mobile_number"
                            class="form-control"
                            placeholder="Enter your mobile number"
                            required
                        />
                    </div>

                </div>

                <div class="row mb-3">

                    <div class="col-md-6">
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

                    <div class="col-md-6">
                        <label for="password" class="form-label">Password</label>
                        <div class="position-relative">
                            <input
                                :type="showPassword ? 'text' : 'password'"
                                id="password"
                                v-model="form.password"
                                class="form-control pe-5"
                                placeholder="Enter your password"
                                required/>
                            <span
                                class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                                @click="togglePassword"
                                style="user-select: none;">
                                {{ showPassword ? 'Hide' : 'Show' }}
                            </span>
                        </div>
                    </div>

                </div>

                <!-- Login Button -->
                <button
                    type="submit"
                    class="btn btn-primary w-100 mb-3"
                    :disabled="isLoading">
                    <span v-if="!isLoading">Register</span>
                    <span v-else>Registering...</span>
                </button>
            </form>

            <!-- Links -->
            <div class="text-center">
                <p class="mb-1 small">
                    Already had account? <a href="/signin">Login here</a>
                </p>
                <p class="mb-0 small">
                    Visit our website
                    <router-link
                        :to="'/commercialhub'">
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
export default {
    data() {
        return {
            form: {
                full_name: "",
                email: "",
                mobile_number: "",
                username: "",
                password: "",
                role: "",
                status: "0" //Automatic inactive?
            },
            isLoading: false,
            showPassword: false, // ✅ Added for toggling password visibility
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

            try
            {
                const response = await apiClient.post('/register', this.form);
                console.log(response.data);

                setTimeout(() => {
                    this.$router.push('/signin');
                }, 1000);

                this.toast.success("Login successfully!");
            }
            catch (error)
            {
                this.isLoading = false;

                const status = error.response?.status;
                const message = error.response?.data?.error || "Created failed";

                if (status === 401)
                {
                    this.toast.error("Created unsuccessfully.");
                }
                else if (status === 403)
                {
                    this.toast.error("Something wrong.");
                }
                else
                {
                    this.toast.error("Create unsuccessful! Please try again.");
                }

                console.error('Create failed:', message);
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
.animation {
    animation-duration: 1s;
    animation-fill-mode: none;
}
.animation-fade-in {
    animation-name: fadeIn;
}
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}
.container {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}
.box-area {
    width: 930px;
}
.right-box {
    padding: 40px;
}
.button-signin {
    border: 2px solid #ffffff;
    color: #ffffff;
    transition: all 0.2s ease-in-out;
}
.button-signin:hover {
    background: #ffffff;
    color: #007bff;
    font-weight: 600;
}
.login-image {
    width: 400px;
    overflow: hidden;
    text-align: center;
    margin: 0 auto;
    display: flex;
    justify-content: center;
    align-items: center;
}
.login-image img {
    width: 100%;
    object-fit: cover;
}
/* Add styles for the loading spinner */
.loading-overlay {
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

.spinner {
    border: 4px solid #f3f3f3; /* Light grey */
    border-top: 4px solid #3498db; /* Blue */
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>
