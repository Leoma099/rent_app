<template>

    <button
        class="btn btn-primary btn-small"
        @click="goBack">
        Back to previous
    </button>

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