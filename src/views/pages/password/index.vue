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

                <!-- Password -->
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
                        {{ showPassword ? 'Hide' : 'Show' }}
                    </span>

                    <!-- Tooltip -->
                    <transition name="fade-slide">
                        <div v-if="showPassGuide" class="pass-tooltip">
                            <ul class="list-unstyled mb-0 small">
                                <li :class="{ ok: passwordChecks.minLength }"> {{ passwordChecks.minLength ? '✓' : '•' }} At least 8 characters</li>
                                <li :class="{ ok: passwordChecks.uppercase }"> {{ passwordChecks.uppercase ? '✓' : '•' }} 1 uppercase letter</li>
                                <li :class="{ ok: passwordChecks.lowercase }"> {{ passwordChecks.lowercase ? '✓' : '•' }} 1 lowercase letter</li>
                                <li :class="{ ok: passwordChecks.number }"> {{ passwordChecks.number ? '✓' : '•' }} 1 number</li>
                                <li :class="{ ok: passwordChecks.symbol }"> {{ passwordChecks.symbol ? '✓' : '•' }} 1 special character (@$!%*?&)</li>
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

                <button
                    type="submit"
                    class="btn btn-primary w-100 mb-3"
                    :disabled="isLoading"
                >
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
            showPassGuide: false,
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
            const p = this.form.password;
            return {
                minLength: p.length >= 8,
                uppercase: /[A-Z]/.test(p),
                lowercase: /[a-z]/.test(p),
                number: /[0-9]/.test(p),
                symbol: /[@$!%*?&]/.test(p)
            };
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
            setTimeout(() => this.showPassGuide = false, 120);
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

.pass-tooltip {
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

.pass-tooltip li {
    color: #dc3545;
}

.pass-tooltip li.ok {
    color: #198754;
    font-weight: bold;
}

.fade-slide-enter-active,
.fade-slide-leave-active {
    transition: all 0.22s cubic-bezier(.45,.03,.5,.9);
}

.fade-slide-enter-from,
.fade-slide-leave-to {
    opacity: 0;
    transform: translateY(-6px);
}

.toggle-pass {
    position: absolute;
    top: 50%;
    right: 10px;
    transform: translateY(-50%);
    font-weight: 600;
    color: #0d6efd;
    cursor: pointer;
    user-select: none;
}
</style>