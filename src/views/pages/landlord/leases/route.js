export default [
    {
        path: '/landlord/leases',
        name: 'Landlord / Leases',
        component: () => import('@/views/pages/landlord/leases'),
        meta:
        {
            name: 'Leases',
            page: 'list',
        },
        children:
            [
                {
                    path: 'create',
                    name: 'Create Landlord / Leases',
                    component: () => import('@/views/pages/landlord/leases'),
                    meta:
                    {
                        name: 'Create Leases',
                        page: 'create',
                        subPage: 'main',
                    },
                },
                {
                    path: ':id',
                    name: 'View Landlord / Leases',
                    component: () => import('@/views/pages/landlord/leases'),
                    meta:
                    {
                        name: 'View Leases',
                        page: 'view',
                    },
                    children:
                        [
                            {
                                path: 'edit',
                                name: 'Edit Landlord / Leases',
                                component: () => import('@/views/pages/landlord/leases'),
                                meta:
                                {
                                    name: 'Edit Leases',

                                    page: 'edit',
                                    subPage: 'main',
                                },
                            },
                        ],
                },
            ],
    },
];