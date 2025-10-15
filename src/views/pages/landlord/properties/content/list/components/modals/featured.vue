<template>
    <div
        class="modal fade"
        id="featuredModal"
        tabindex="-1"
        aria-labelledby="featuredModalLabel"
        aria-hidden="true">

        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-0">

                <div class="modal-body">

                    <div class="d-flex justify-content-between mb-3">
                        <div>
                            <h3 class="mb-0">
                                Are you sure?
                            </h3>
                        </div>
                        <div>
                            <button
                                type="button"
                                class="btn-close"
                                data-bs-dismiss="modal"
                                aria-label="Close">
                            </button>
                        </div>
                    </div>

                    <p class="mb-3">
                        You're about to update to featured the property of <strong>{{ selectedProperty?.title }}</strong>
                    </p>

                    <p>Do you want to continue?</p>

                    <div class="text-end">
                        <button
                            type="button"
                            class="btn btn-sm btn-outline-secondary me-3 rounded-0"
                            data-bs-dismiss="modal">
                            No
                        </button>
                        <button
                            type="button"
                            class="btn btn-sm btn-primary rounded-0"
                            @click="updateStatus()"
                            data-bs-dismiss="modal">
                            Yes
                        </button>

                    </div>


                </div>

            </div>
        </div>
    </div>
</template>

<script>
import apiClient from "@/services";
import { useToast } from "vue-toastification";

export default
{
    props:
    {
        selectedProperty: Object
    },

    data()
    {
        return {
            isUpdating: false,
            toast: useToast()
        };
    },

    methods:
    {
        async updateStatus()
        {
            try
            {
                this.isUpdating = true;

                const newStatus = this.selectedProperty.is_featured === 1 ? 0 : 1;

                const response = await apiClient.put(`/featured-properties/${this.selectedProperty.id}`,
                {
                    is_featured: newStatus
                });

                // ✅ Only success toast now
                this.toast.success("Featured updated successfully!");
                this.$emit("refresh-list");

                console.log(response.data);
            }
            catch (error)
            {
                console.error(error);
                this.toast.error("Update featured unsuccessful! Please try again.");
            }
            finally
            {
                this.isUpdating = false;
            }
        }

    }
};
</script>
