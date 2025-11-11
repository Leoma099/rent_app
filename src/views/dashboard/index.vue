<template>
    <div class="animation animation-fade-in">
    </div>
</template>

<script>
export default 
{
    data() 
    {
        return {
            role: parseInt(localStorage.getItem("role")) || 0
        };
    },

    mounted() 
    {
        this.initialized();
    },

    methods: 
    {
        initialized() 
        {
            if (this.role === 1) 
            {
                window.location.href = "/administration/dashboard";
            } 
            else if (this.role === 2) 
            {
                window.location.href = "/landlord/dashboard";
            } 
            else 
            {
                window.location.href = "/commercialhub";
            }
        }
    }
};
</script>

<style scoped>
.animation 
{
    animation-duration: 1s;
    animation-fill-mode: none;
}

.animation-fade-in 
{
    animation-name: fadeIn;
}

@keyframes fadeIn 
{
    from 
    {
        opacity: 0;
    }
    to 
    {
        opacity: 1;
    }
}
</style>