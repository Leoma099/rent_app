export default [
    {
        path: '/administration/inquiries',
        name: 'Administration / Inquiry',
        component: () => import('@/views/pages/administration/inquiries'),
        meta:
        {
            name: 'Inquiry',
            page: 'list',
        },
        children:
            [
                {
                    path: 'create',
                    name: 'Create Administration / Inquiry',
                    component: () => import('@/views/pages/administration/inquiries'),
                    meta:
                    {
                        name: 'Create Inquiry',
                        page: 'create',
                        subPage: 'main',
                    },
                },
                {
                    path: ':id',
                    name: 'View Administration / Inquiry',
                    component: () => import('@/views/pages/administration/inquiries'),
                    meta:
                    {
                        name: 'View Inquiry',
                        page: 'view',
                    },
                    children:
                        [
                            {
                                path: 'edit',
                                name: 'Edit Administration / Inquiry',
                                component: () => import('@/views/pages/administration/inquiries'),
                                meta:
                                {
                                    name: 'Edit Inquiry',

                                    page: 'edit',
                                    subPage: 'main',
                                },
                            },
                        ],
                },
            ],
    },
];