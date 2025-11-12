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
                <h2 class="fw-bold mb-0">Reset Password</h2>
            </div>

            <form @submit.prevent="submit()">

                <!-- Password input with strength meter -->
                <label for="password" class="form-label">New Password</label>
                <div class="position-relative mb-2">
                    <input
                        :type="showPassword ? 'text' : 'password'"
                        id="password"
                        v-model="form.password"
                        class="form-control pe-5"
                        placeholder="Enter new password"
                        @focus="showPassGuide = true"
                        @blur="hideTooltip"
                        required
                    />

                    <span class="toggle-pass" @click="togglePassword">
                        <i class="text-secondary" :class="showPassword ? 'bx bx-hide' : 'bx bx-show'"></i>
                    </span>

                    <transition name="fade-slide">
                        <div v-if="showPassGuide" class="pass-tooltip">
                            <ul class="list-unstyled mb-2 small">
                                <p class="mb-2">Password must contain the following:</p>
                                <li :class="{'ok': passwordChecks.minLength}">
                                    {{ passwordChecks.minLength ? '✓' : '•' }} At least 8 characters
                                </li>
                                <li :class="{'ok': passwordChecks.uppercase}">
                                    {{ passwordChecks.uppercase ? '✓' : '•' }} 1 uppercase letter
                                </li>
                                <li :class="{'ok': passwordChecks.lowercase}">
                                    {{ passwordChecks.lowercase ? '✓' : '•' }} 1 lowercase letter
                                </li>
                                <li :class="{'ok': passwordChecks.number || passwordChecks.symbol}">
                                    {{ (passwordChecks.number || passwordChecks.symbol) ? '✓' : '•' }} 1 number or symbol
                                </li>
                            </ul>
                        </div>
                    </transition>
                </div>


                <!-- Confirm Password -->
                <label for="confirm_password" class="form-label">Confirm Password</label>
                <div class="position-relative mb-3">
                    <input
                        :type="showConfirmPassword ? 'text' : 'password'"
                        id="password_confirmation"
                        v-model="form.password_confirmation"
                        class="form-control pe-5"
                        placeholder="Confirm password"
                        required
                    />
                    <span class="toggle-pass" @click="toggleConfirmPassword">
                        {{ showConfirmPassword ? 'Hide' : 'Show' }}
                    </span>
                </div>

                <button type="submit" class="btn btn-primary w-100 mb-3" :disabled="isLoading">
                    <span v-if="!isLoading">Reset Password</span>
                    <span v-else>Resetting...</span>
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
import { useRoute } from "vue-router";

export default {
    data()
    {
        return {
            form:
            {
                email: "",
                token: "",
                password: "",
                password_confirmation: ""
            },
            isLoading: false,
            showPassword: false,
            showConfirmPassword: false,
            showPassGuide: false
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
                lowercase: /[a-z]/.test(password),
                number: /[0-9]/.test(password),
                symbol: /[@$!%*?&]/.test(password)
            };
        },

        strengthPercent()
        {
            let strength = 0;
            if(this.passwordChecks.minLength) strength += 25;
            if(this.passwordChecks.uppercase) strength += 25;
            if(this.passwordChecks.lowercase) strength += 25;
            if(this.passwordChecks.number || this.passwordChecks.symbol) strength += 25;
            return strength;
        },

        passwordStrengthClass()
        {
            if(this.strengthPercent <= 25)
            {
                return 'bg-danger';
            }
            else if(this.strengthPercent <= 50)
            {
                return 'bg-warning';
            }
            else if(this.strengthPercent <= 75)
            {
                return 'bg-primary';
            }
            else
            {
                return 'bg-success';
            }
        },

        passwordStrengthText()
        {
            if(this.strengthPercent <= 25)
            {
                return 'Weak';
            }
            else if(this.strengthPercent <= 50)
            {
                return 'Fair';
            }
            else if(this.strengthPercent <= 75)
            {
                return 'Good';
            }
            else
            {
                return 'Strong';
            }
        }
    },

    methods:
    {
        togglePassword()
        {
            this.showPassword = !this.showPassword;
        },

        toggleConfirmPassword()
        {
            this.showConfirmPassword = !this.showConfirmPassword;
        },

        hideTooltip()
        {
            setTimeout(() =>
            {
                this.showPassGuide = false;
            }, 120);
        },

        async submit()
        {
            this.isLoading = true;
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

.pass-tooltip
{
    position: absolute;
    width: 100%;
    max-width: 100%;
    background: #fff;
    border: 1px solid #e0e0e0;
    padding: 10px;
    border-radius: 6px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.08);
    z-index: 10;
    margin-top: 6px;
}

.pass-tooltip li
{
    color: #dc3545;
}

.pass-tooltip li.ok
{
    color: #198754;
    font-weight: bold;
}

.strength-bar
{
    height: 5px;
    border-radius: 4px;
    background-color: #e0e0e0;
    margin-bottom: 2px;
}

.strength-bar.weak
{
    background-color: #dc3545;
    width: 25%;
}

.strength-bar.fair
{
    background-color: #ffc107;
    width: 50%;
}

.strength-bar.good
{
    background-color: #0d6efd;
    width: 75%;
}

.strength-bar.strong
{
    background-color: #198754;
    width: 100%;
}

.toggle-pass
{
    position: absolute;
    top: 50%;
    right: 10px;
    transform: translateY(-50%);
    font-weight: 600;
    color: #0d6efd;
    cursor: pointer;
    user-select: none;
}

.progress
{
    height: 6px;
    border-radius: 4px;
}

.progress-bar
{
    transition: width 0.3s ease;
}

</style>
