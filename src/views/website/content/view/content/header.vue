<template>

    <div class="d-flex justify-content-between">

        <div>
            <button
                class="btn btn-sm btn-primary d-flex align-items-center"
                @click="goBack()">
                <i class="bx bx-chevrons-left me-2"></i>
                <span>Back to page</span>
            </button>
        </div>

    </div>

</template>

<script>
export default
{
    methods:
    {
        goBack()
        {
            this.$router.back();
        }
    }
}
</script>

<style>

</style>