<template>

    <div
        class="modal fade"
        id="updateProfile"
        tabindex="-1"
        aria-labelledby="exampleModalLabel"
        aria-hidden="true"
    >

        <div class="modal-dialog modal-lg modal-dialog-centered">

            <div class="modal-content rounded-0 border-0">

                <div class="modal-body">

                    <form @submit.prevent="submit()">

                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="mb-0 text-title">ACCOUNT DETAILS</h3>
                            <div>
                                <button
                                    type="button"
                                    class="btn-close"
                                    data-bs-dismiss="modal"
                                    aria-label="Close">
                                </button>
                            </div>
                        </div>

                        <div class="row mt-3">

                            <div class="col-md-12">
                                <div class="form-group mb-3">
                                    <label class="form-label">* Full Name:</label>
                                    <input
                                        type="text"
                                        class="form-control rounded-0"
                                        placeholder="ex. Juan Dela Cruz"
                                        v-model="form.full_name"
                                        required
                                    />
                                </div>
                            </div>

                        </div>

                        <div class="row">

                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label class="form-label">* E-mail:</label>
                                    <input
                                        type="email"
                                        class="form-control rounded-0"
                                        placeholder="ex. juandelacruz@gmail.com"
                                        v-model="form.email"
                                        required
                                    />
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label class="form-label">* Mobile Number:</label>
                                    <input
                                        type="text"
                                        class="form-control rounded-0"
                                        placeholder="ex. 09xxxxxxxxx"
                                        maxlength="11"
                                        v-model="form.mobile_number"
                                        required
                                    />
                                </div>
                            </div>

                        </div>

                        <hr>

                        <h3 class="mb-0 text-title">SYSTEM ACCOUNT</h3>

                        <div class="row mt-3">

                            <div class="col-md-6">
                                <div class="form-group mb-3">
                                    <label class="form-label">* Username:</label>
                                    <input
                                        type="text"
                                        class="form-control rounded-0"
                                        placeholder="ex. juandelacruz"
                                        v-model="form.username"
                                        required
                                    />
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group mb-2">
                                    <label class="form-label">* Password:</label>

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
                                            style="user-select: none;">
                                            <i class="text-secondary" :class="showPassword ? 'bx bx-hide' : 'bx bx-show'"></i>
                                        </span>

                                        <transition name="fade-slide">
                                            <div v-if="showPassGuide" class="pass-tooltip">
                                                <ul class="list-unstyled mb-1 small">
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
                            </div>


                        </div>

                        <div class="text-end mt-3">
                            <button
                                type="button"
                                class="btn btn-secondary me-3 rounded-0"
                                data-bs-dismiss="modal">
                                Close
                            </button>

                            <button
                                type="submit"
                                class="btn button-color rounded-0"
                                :disabled="passwordWarning">
                                Submit
                            </button>
                        </div>

                    </form>

                </div>

            </div>

        </div>

    </div>

</template>

<script>
import apiClient from "@/services/index";

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
                password: ""
            },
            passwordWarning: false,
            showPassword: false,
            showPassGuide: false,
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

    created()
    {
        this.fetchUserData();
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

                window.location.href = "/my-account";
            }
            catch (error)
            {
                console.error("Error occurred:", error);
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
.button-color
{
    background-color: #007bff;
    color: #ffffff;
}

.button-color:hover
{
    background-color: #3798ff;
    color: #ffffff;
}

.text-title
{
    color: #007bff;
}

.cursor-pointer
{
    cursor: pointer;
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
