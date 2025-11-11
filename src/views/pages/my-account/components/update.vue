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
                                            class="form-control rounded-0 pe-5"
                                            placeholder="Enter new password"
                                            v-model="form.password"
                                            @input="validatePassword"
                                        />

                                        <!-- ✅ Show/Hide stays inside input -->
                                        <span
                                            class="position-absolute top-50 end-0 translate-middle-y me-3 text-primary fw-bold cursor-pointer"
                                            @click="togglePassword"
                                            style="user-select: none;">
                                            {{ showPassword ? 'Hide' : 'Show' }}
                                        </span>
                                    </div>

                                    <!-- ⚠ Password warning (below input) -->
                                    <small
                                        v-if="passwordWarning"
                                        class="text-danger d-block mt-1">
                                        ⚠ Password must contain at least 8 characters,
                                        one uppercase letter, one number,
                                        and one special character.
                                    </small>
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
        };
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
</style>
