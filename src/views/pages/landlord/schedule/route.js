export default [
    {
        path: '/landlord/schedule',
        name: 'Landlord / Schedule',
        component: () => import('@/views/pages/landlord/schedule'),
        meta:
        {
            name: 'Schedule',
            page: 'list',
        },
        children:
            [
                {
                    path: 'create',
                    name: 'Create Landlord / Schedule',
                    component: () => import('@/views/pages/landlord/schedule'),
                    meta:
                    {
                        name: 'Create Schedule',
                        page: 'create',
                        subPage: 'main',
                    },
                },
                {
                    path: ':id',
                    name: 'View Landlord / Schedule',
                    component: () => import('@/views/pages/landlord/schedule'),
                    meta:
                    {
                        name: 'View Schedule',
                        page: 'view',
                    },
                    children:
                        [
                            {
                                path: 'edit',
                                name: 'Edit Landlord / Schedule',
                                component: () => import('@/views/pages/landlord/schedule'),
                                meta:
                                {
                                    name: 'Edit Schedule',

                                    page: 'edit',
                                    subPage: 'main',
                                },
                            },
                        ],
                },
            ],
    },
];