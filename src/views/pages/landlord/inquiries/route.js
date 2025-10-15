export default [
    {
        path: '/landlord/inquiries',
        name: 'Landlord / Inquiries',
        component: () => import('@/views/pages/landlord/inquiries'),
        meta:
        {
            name: 'Inquiries',
            page: 'list',
        },
        children:
            [
                {
                    path: 'create',
                    name: 'Create Landlord / Inquiries',
                    component: () => import('@/views/pages/landlord/inquiries'),
                    meta:
                    {
                        name: 'Create Inquiries',
                        page: 'create',
                        subPage: 'main',
                    },
                },
                {
                    path: ':id',
                    name: 'View Landlord / Inquiries',
                    component: () => import('@/views/pages/landlord/inquiries'),
                    meta:
                    {
                        name: 'View Inquiries',
                        page: 'view',
                    },
                    children:
                        [
                            {
                                path: 'edit',
                                name: 'Edit Landlord / Inquiries',
                                component: () => import('@/views/pages/landlord/inquiries'),
                                meta:
                                {
                                    name: 'Edit Inquiries',

                                    page: 'edit',
                                    subPage: 'main',
                                },
                            },
                        ],
                },
            ],
    },
];