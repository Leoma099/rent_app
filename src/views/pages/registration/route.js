export default [
    {
        path: '/registration',

        name: 'Registration',

        meta:
        {
            page: 'registration'
        },

        component: () => import('@/views/pages/registration/index.vue'),
    },
];