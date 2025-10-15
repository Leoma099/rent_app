<template>

    <div class="animate animate-fade-in">

        <list-component v-if="$route.meta.page === 'list'" />
        <create-component v-if="$route.meta.page === 'create'" />

    </div>

</template>

<script>
import ListComponent from "./content/list";
import CreateComponent from "./content/create";
export default
{
    components:
    {
        ListComponent,
        CreateComponent
    }
}
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

@keyframes fadeIn{
    from{
        opacity: 0;
    }
    to{
        opacity: 1;
    }
}
</style>