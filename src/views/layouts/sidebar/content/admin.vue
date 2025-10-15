<template>
  
    <div class="mb-3">

        <li>
            <router-link
                exact-active-class="active"
                :to="'/administration/dashboard'">
                <i class="bx bx-category me-2"></i>Dashboard
            </router-link>
        </li>

        <li>
            <router-link
                exact-active-class="active"
                :to="'/administration/properties'">
                <i class="bx bx-category me-2"></i>Properties
            </router-link>
        </li>

        <li>
            <router-link
                exact-active-class="active"
                :to="'/administration/accounts'">
                <i class="bx bx-category me-2"></i>User Accounts
            </router-link>
        </li>

    </div>

</template>

<script>
export default
{
    data()
    {
        return{
            isDropdownOpen1: false,
            isDropdownOpen2: false,
            isDropdownOpen3: false,
        }
    },

    methods:
    {
        toggleDropdown1()
        {
            this.isDropdownOpen1 = !this.isDropdownOpen1;
            this.$refs.caret1.classList.toggle('bx-caret-down');
            this.$refs.caret1.classList.toggle('bx-caret-right');
        },

        toggleDropdown2()
        {
            this.isDropdownOpen2 = !this.isDropdownOpen2;
            this.$refs.caret2.classList.toggle('bx-caret-down');
            this.$refs.caret2.classList.toggle('bx-caret-right');
        },

        toggleDropdown3()
        {
            this.isDropdownOpen3 = !this.isDropdownOpen3;
            this.$refs.caret3.classList.toggle('bx-caret-down');
            this.$refs.caret3.classList.toggle('bx-caret-right');
        }
    }
}
</script>

<style scoped>
ul.dropdown {
  max-height: 0;
  overflow: hidden;
  transition: all 0.3s ease-in-out;
  opacity: 0;
}

ul.dropdown.open {
  max-height: 500px; /* Adjust to fit your content */
  opacity: 1;
}
</style>