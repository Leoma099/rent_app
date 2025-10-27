export default [
    {
        path: '/reset-password',

        name: 'Reset Password',

        meta:
        {
            page: 'reset-password'
        },

        component: () => import('@/views/pages/password/index.vue'),
    },
];