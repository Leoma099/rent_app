<template>
    <footer class="footer text-center text-white py-3">
        <div class="container">
            <h5 class="mb-1 fw-bold">Commercial Hub</h5>
            <small>© {{ currentYear }} Commercial Hub. All rights reserved.</small>
        </div>
    </footer>
</template>

<script>
export default 
{
    data() 
    {
        return {
            currentYear: new Date().getFullYear()
        };
    }
};
</script>

<style scoped>
.footer 
{
    background-color: #000080; /* Bootstrap gray */
}
</style>
