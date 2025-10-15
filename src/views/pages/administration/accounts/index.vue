<template>

    <div class="animation animation-fade-in">

        <list-component v-if="$route.meta.page === 'list'" />
        <create-component v-if="$route.meta.page === 'create'" />
        <edit-component v-if="$route.meta.page === 'edit'" />
        <view-component v-if="$route.meta.page === 'view'" />

    </div>

</template>

<script>
import ListComponent from './content/list';
import CreateComponent from './content/create';
import EditComponent from './content/edit';
import ViewComponent from './content/view';
export default
{
    components:
    {
        ListComponent,
        CreateComponent,
        EditComponent,
        ViewComponent,
    },
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