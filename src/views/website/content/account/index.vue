<template>
    <div class="container my-5">
        <div class="col-md-8 mx-auto">
            <h1 class="mb-0">Profile Information</h1>
            <router-link :to="'/'">
                Go back
            </router-link>

            <div class="card card-body rounded-0 shadow-sm mt-4">
                <p><strong>Profile Information</strong></p>

                <div class="row">
                    <div class="col-md-12">
                        <label class="form-label">First Name:</label>
                        <input
                            type="text"
                            class="form-control rounded-0"
                            v-model="form.full_name">
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-md-8">
                        <label class="form-label">Email Address:</label>
                        <input
                            type="text"
                            class="form-control rounded-0"
                            v-model="form.email">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Mobile Number:</label>
                        <input
                            type="text"
                            class="form-control rounded-0"
                            v-model="form.mobile_number">
                    </div>
                </div>

                <hr>

                <div class="row">
                    <div class="col-md-6">
                        <label class="form-label">Username:</label>
                        <input
                            type="text"
                            class="form-control rounded-0"
                            v-model="form.username">
                    </div>
                    <div class="col-md-6 position-relative">
                        <label for="password" class="form-label">Password</label>
                        <div class="position-relative">
                            <input
                                :type="showPassword ? 'text' : 'password'"
                                id="password"
                                v-model="form.password"
                                class="form-control rounded-0 pe-5"
                                placeholder="ex. Password123!"
                                @focus="showPassGuide = true"
                                @blur="showPassGuide = false"
                            />
                            <span
                                class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                                @click="togglePassword"
                                style="user-select: none;"
                            >
                                <i class="text-secondary" :class="showPassword ? 'bx bx-hide' : 'bx bx-show'"></i>
                            </span>
                        </div>

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
                </div>

                <div class="text-end mt-3">
                    <button
                        type="submit"
                        class="btn btn-sm btn-primary rounded-0"
                        @click.prevent="submit"
                        :disabled="isLoading">
                            <span v-if="isLoading">Submitting...</span>
                            <span v-else>Submit</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import apiClient from '@/services';
import { useToast } from "vue-toastification";
export default
{
    data()
    {
        return{
            form:
            {
                full_name: "",
                email: "",
                mobile_number: "",
                username: "",
                password: ""
            },
            passwordWarning: false,
            showPassGuide: false,
            showPassword: false,
            isLoading: false,
        }
    },

    created()
    {
        this.fetchUserData();
        this.toast = useToast();
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
        fetchUserData()
        {
            const user =
            {
                full_name: localStorage.getItem("full_name"),
                email: localStorage.getItem("email"),
                mobile_number: localStorage.getItem("mobile_number"),
                username: localStorage.getItem("username")
            };

            if (user.full_name)
            {
                this.form = { ...this.form, ...user };
            }
        },

        async submit()
        {
            this.isLoading = true;
            try
            {
                const response = await apiClient.put("/accountUpdate",
                {
                    full_name: this.form.full_name,
                    email: this.form.email,
                    mobile_number: this.form.mobile_number,
                    username: this.form.username,
                    password: this.form.password
                });

                console.log("Successfully updated:", response.data);

                localStorage.setItem("full_name", this.form.full_name);
                localStorage.setItem("email", this.form.email);
                localStorage.setItem("mobile_number", this.form.mobile_number);
                localStorage.setItem("username", this.form.username);
                this.toast.success("Update successfully!");
                this.$router.push("/commercialhub");
            }
            catch (error)
            {
                console.error("Error occurred:", error);
                this.toast.error("Update unsuccessfully!");
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
}
</script>

<style scoped>
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
</style>