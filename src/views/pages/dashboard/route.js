export default [
    {
        path: '/dashboard',

        name: 'Dashboard',

        component: () => import('@/views/pages/dashboard'),

        meta:
        {
            name: 'Dashboard'
        }
    },
];