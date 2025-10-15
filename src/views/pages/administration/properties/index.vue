<template>

    <div class="animate animate-fade-in">

        <list-component v-if="$route.meta.page === 'list'" />
        <create-component v-if="$route.meta.page === 'create'" />
        <edit-component v-if="$route.meta.page === 'edit'" />

    </div>

</template>

<script>
import ListComponent from "./content/list";
import EditComponent from "./content/edit";
export default
{
    components:
    {
        ListComponent,
        EditComponent
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