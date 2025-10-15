export default [
    {
        path: '/landlord/dashboard',

        name: 'Landlord / Dashboard',

        component: () => import('@/views/pages/landlord/dashboard'),

        meta:
        {
            name: 'Dashboard'
        }
    },
];