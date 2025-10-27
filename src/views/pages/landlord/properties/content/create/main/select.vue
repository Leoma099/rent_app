<template>

    <div class="dropdown position-relative">

        <button
            class="btn btn-outline-primary w-100 text-start"
            type="button"
            @click="toggleDropdown"
        >
            {{ selectedDisplay }}
            <i class="bi bi-chevron-down float-end"></i>
        </button>

        <div
            v-if="isOpen"
            class="dropdown-menu show w-100 p-2 mt-1 shadow-sm"
        >
            <div
                v-for="option in options"
                :key="option"
                class="form-check"
            >
                <input
                    type="checkbox"
                    class="form-check-input"
                    :id="option"
                    :value="option"
                    v-model="selected"
                    @change="limitSelection"
                >
                <label class="form-check-label" :for="option">
                    {{ option }}
                </label>
            </div>
        </div>

    </div>

</template>

<script>
export default
{
    data()
    {
        return {
            isOpen: false,
            selected: [],
            options:
            [
                "Land",
                "Commercial",
                "Office Space",
                "Retail Shop",
                "Restaurant",
                "Warehouse"
            ]
        }
    },

    computed:
    {
        selectedDisplay()
        {
            return this.selected.length
                ? this.selected.join(", ")
                : "Select business type (max 3)"
        }
    },

    mounted()
    {
        document.addEventListener("click", this.handleClickOutside)
    },

    beforeUnmount()
    {
        document.removeEventListener("click", this.handleClickOutside)
    },

    methods:
    {
        toggleDropdown(event)
        {
            event.stopPropagation()
            this.isOpen = !this.isOpen
        },

        handleClickOutside(event)
        {
            const dropdown = this.$el
            if (!dropdown.contains(event.target))
            {
                this.isOpen = false
            }
        },

        limitSelection()
        {
            if (this.selected.length > 3)
            {
                this.selected.pop()
                alert("You can only select up to 3 business types.")
            }
        }
    }
}
</script>

<style scoped>
.dropdown-menu
{
    max-height: 200px;
    overflow-y: auto;
    border: 1px solid #ccc;
    border-radius: 6px;
    background: white;
    z-index: 1050;
}

button:focus
{
    box-shadow: none !important;
}

.form-check-label
{
    cursor: pointer;
}
</style>
