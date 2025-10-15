export default [
    {
        path: '/administration/dashboard',

        name: 'Administration / Dashboard',

        component: () => import('@/views/pages/administration/dashboard'),

        meta:
        {
            name: 'Dashboard'
        }
    },
];