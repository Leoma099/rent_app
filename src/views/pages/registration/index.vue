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
                            required
                        />
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
                        <ul class="list-unstyled mt-2 mb-0 small">
                            <li :class="{'text-success fw-bold': passwordChecks.minLength, 'text-danger': !passwordChecks.minLength}">
                                {{ passwordChecks.minLength ? '✓' : '•' }} At least 8 characters
                            </li>
                            <li :class="{'text-success fw-bold': passwordChecks.uppercase, 'text-danger': !passwordChecks.uppercase}">
                                {{ passwordChecks.uppercase ? '✓' : '•' }} 1 uppercase letter
                            </li>
                            <li :class="{'text-success fw-bold': passwordChecks.lowercase, 'text-danger': !passwordChecks.lowercase}">
                                {{ passwordChecks.lowercase ? '✓' : '•' }} 1 lowercase letter
                            </li>
                            <li :class="{'text-success fw-bold': passwordChecks.number, 'text-danger': !passwordChecks.number}">
                                {{ passwordChecks.number ? '✓' : '•' }} 1 number
                            </li>
                            <li :class="{'text-success fw-bold': passwordChecks.symbol, 'text-danger': !passwordChecks.symbol}">
                                {{ passwordChecks.symbol ? '✓' : '•' }} 1 special character (@$!%*?&)
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Register Button -->
                <button
                    type="submit"
                    class="btn btn-primary w-100 mb-3"
                    :disabled="isLoading"
                >
                    <span v-if="!isLoading">Register</span>
                    <span v-else>Registering...</span>
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

export default
{
    data()
    {
        return {
            form: {
                full_name: "",
                email: "",
                mobile_number: "",
                username: "",
                password: "",
                role: "",
                status: "0"
            },
            isLoading: false,
            showPassword: false,
            errors: {}
        };
    },

    computed:
    {
        passwordChecks()
        {
            const password = this.form.password;
            return {
                minLength: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                lowercase: /[a-z]/.test(password),
                number: /[0-9]/.test(password),
                symbol: /[@$!%*?&]/.test(password)
            };
        }

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
                const response = await apiClient.post('/register', this.form);
                console.log(response.data);

                setTimeout(() =>
                {
                    this.$router.push('/signin');
                }, 1000);

                this.toast.success("Login successfully!");
            }
            catch (error)
            {
                this.isLoading = false;
                this.errors = {};

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
