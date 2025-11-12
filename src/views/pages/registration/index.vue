<template>
    <div v-if="isLoading" class="loading-overlay">
        <div class="spinner"></div>
    </div>

    <div class="login-page d-flex justify-content-center align-items-center vh-100" :style="{ backgroundColor: '#faf9f6' }">
        <div class="card shadow-sm border-0 p-4" style="width: 700px;">
            <div class="text-center mb-3">
                <img src="@/assets/images/capas_logo.png" alt="Logo" width="80" />
            </div>

            <div class="text-center mb-3">
                <h6 class="mb-0">Welcome to</h6>
                <h2 class="fw-bold mb-1">Commercial Hub</h2>
            </div>

            <form @submit.prevent="submit()">
                <div class="row mb-3">
                    <div class="col-md-8">
                        <label for="name" class="form-label">Full Name</label>
                        <input
                            type="text"
                            id="name"
                            v-model="form.full_name"
                            class="form-control"
                            placeholder="ex. Juan Dela Cruz"
                        />
                        <small v-if="errors.full_name" class="text-danger">{{ errors.full_name }}</small>
                    </div>

                    <div class="col-md-4">
                        <label for="role" class="form-label">What are you?</label>
                        <select class="form-select" v-model="form.role">
                            <option value="" disabled>- select role -</option>
                            <option value="2">Landlord</option>
                            <option value="3">Renter</option>
                        </select>
                        <small v-if="errors.role" class="text-danger">{{ errors.role }}</small>
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
                            placeholder="ex. juandelacruz@gmail.com"
                        />
                        <small v-if="errors.email" class="text-danger">{{ errors.email }}</small>
                    </div>

                    <div class="col-md-5">
                        <label for="mobile_number" class="form-label">Mobile Number</label>
                        <input
                            type="text"
                            id="mobile_number"
                            v-model="form.mobile_number"
                            class="form-control"
                            placeholder="ex. 09XXXXXXXXX"
                            maxlength="11"
                            @input="validateMobileNumber"
                        />
                        <small v-if="errors.mobile_number" class="text-danger">{{ errors.mobile_number }}</small>
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
                            placeholder="ex. juandelacruz"
                        />
                        <small v-if="errors.username" class="text-danger">{{ errors.username }}</small>
                    </div>

                    <div class="col-md-6 position-relative">
                        <label for="password" class="form-label">Password</label>
                        <div class="position-relative">
                            <input
                                :type="showPassword ? 'text' : 'password'"
                                id="password"
                                v-model="form.password"
                                class="form-control pe-5"
                                placeholder="ex. Password123!"
                                @focus="showPassGuide = true"
                                @blur="showPassGuide = false"
                            />
                            <span
                                class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                                @click="togglePassword"
                                style="user-select: none;"
                            >
                                {{ showPassword ? 'Hide' : 'Show' }}
                            </span>
                        </div>

                        <transition name="fade-slide">
                            <div v-if="showPassGuide" class="pass-tooltip">
                                <ul class="list-unstyled mb-0 small">
                                    <li :class="{'ok': passwordChecks.minLength}">
                                        {{ passwordChecks.minLength ? '✓' : '•' }} At least 8 characters
                                    </li>
                                    <li :class="{'ok': passwordChecks.uppercase}">
                                        {{ passwordChecks.uppercase ? '✓' : '•' }} 1 uppercase letter
                                    </li>
                                    <li :class="{'ok': passwordChecks.lowercase}">
                                        {{ passwordChecks.lowercase ? '✓' : '•' }} 1 lowercase letter
                                    </li>
                                    <li :class="{'ok': passwordChecks.number}">
                                        {{ passwordChecks.number ? '✓' : '•' }} 1 number
                                    </li>
                                    <li :class="{'ok': passwordChecks.symbol}">
                                        {{ passwordChecks.symbol ? '✓' : '•' }} 1 special character (@$!%*?&)
                                    </li>
                                </ul>
                            </div>
                        </transition>

                        <small v-if="errors.password" class="text-danger">{{ errors.password }}</small>
                    </div>

                </div>

                <button
                    type="submit"
                    class="btn btn-primary w-100 mb-3"
                    :disabled="isLoading"
                >
                    <span v-if="!isLoading">Register</span>
                    <span v-else>Registering...</span>
                </button>
            </form>

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
            form:
            {
                full_name: "",
                email: "",
                mobile_number: "",
                username: "",
                password: "",
                role: "",
                status: "0"
            },
            isLoading: false,
            showPassGuide: false,
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
            this.errors = {};

            if (!this.form.full_name)
            {
                this.errors.full_name = "Full name is required";
            }
            if (!this.form.email)
            {
                this.errors.email = "Email is required";
            }
            if (!this.form.mobile_number)
            {
                this.errors.mobile_number = "Mobile number is required";
            }
            else if (!/^09\d{9}$/.test(this.form.mobile_number))
            {
                this.errors.mobile_number = "Invalid mobile number.";
            }
            if (!this.form.username)
            {
                this.errors.username = "Username is required";
            }
            if (!this.form.password)
            {
                this.errors.password = "Password is required";
            }
            if (!this.form.role)
            {
                this.errors.role = "Please select a role";
            }

            if (Object.keys(this.errors).length)
            {
                return;
            }

            this.isLoading = true;

            try
            {
                const response = await apiClient.post('/admin/register', this.form);
                console.log(response.data);

                this.$router.push('/signin');

                this.toast.success("Registration successful!");
            }
            catch (error)
            {
                this.isLoading = false;
                this.errors.password = "Registration failed, please check your input";
                this.form.password = ""; // Clear password
                const message = error.response?.data?.error || "Registration failed";
                this.toast.error(message);
                console.error('Registration failed:', message);
            }
            finally
            {
                this.isLoading = false;
            }
        },

        validateMobileNumber()
        {
            // Remove non-numeric characters
            this.form.mobile_number = this.form.mobile_number.replace(/[^0-9]/g, '');

            // Limit to 11 digits
            if (this.form.mobile_number.length > 11) {
                this.form.mobile_number = this.form.mobile_number.slice(0, 11);
            }

            // Check Philippine mobile number format
            // if (this.form.mobile_number && !/^09\d{9}$/.test(this.form.mobile_number)) {
            //     this.errors.mobile_number = "Invalid mobile number. Must start with 09 and be 11 digits.";
            // } else {
            //     this.errors.mobile_number = null;
            // }
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

.pass-tooltip
{
    position: absolute;
    max-width: 100%;
    background: #fff;
    border: 1px solid #e0e0e0;
    padding: 10px;
    border-radius: 6px;
    margin-top: 6px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.08);
    z-index: 20;
}

.pass-tooltip li
{
    color: #dc3545;
    font-weight: 500;
}

.pass-tooltip li.ok
{
    color: #198754;
    font-weight: bold;
}

.fade-slide-enter-active,
.fade-slide-leave-active
{
    transition: all 0.25s ease;
}

.fade-slide-enter-from,
.fade-slide-leave-to
{
    opacity: 0;
    transform: translateY(-6px);
}
</style>