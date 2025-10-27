export default [
    {
        path: '/forgot-password',

        name: 'Forgot Password',

        meta:
        {
            page: 'forgot-password'
        },

        component: () => import('@/views/pages/email/index.vue'),
    },
];