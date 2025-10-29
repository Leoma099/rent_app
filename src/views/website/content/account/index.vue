<template>
    <div class="container my-5">
        <div class="col-md-6 mx-auto">
            <div class="card card-body rounded-0 shadow-sm">
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
                    <div class="col-md-6">
                        <div class="form-group mb-2">
                            <label class="form-label">* Password:</label>

                            <div class="position-relative">
                                <input
                                    :type="showPassword ? 'text' : 'password'"
                                    class="form-control rounded-0 pe-5"
                                    placeholder="Enter new password"
                                    v-model="form.password"
                                    @input="validatePassword"
                                />
                                <span
                                    class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                                    @click="togglePassword"
                                    style="user-select: none;">
                                    {{ showPassword ? 'Hide' : 'Show' }}
                                </span>
                            </div>

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

        validatePassword()
        {
            const password = this.form.password;
            const passwordRegex =
                /^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
            this.passwordWarning = password && !passwordRegex.test(password);
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
                setTimeout(() =>
                {
                    this.isLoading = false;
                }, 1000);
            }
        },

        togglePassword()
        {
            this.showPassword = !this.showPassword;
        }
    }
}
</script>

<style scoped>

</style>