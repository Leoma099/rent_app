export default [
    {
        path: '/landlord/properties',
        name: 'Landlord / Properties',
        component: () => import('@/views/pages/landlord/properties'),
        meta:
        {
            name: 'Properties',
            page: 'list',
        },
        children:
            [
                {
                    path: 'create',
                    name: 'Create Landlord / Properties',
                    component: () => import('@/views/pages/landlord/properties'),
                    meta:
                    {
                        name: 'Create Properties',
                        page: 'create',
                        subPage: 'main',
                    },
                },
                {
                    path: ':id',
                    name: 'View Landlord / Properties',
                    component: () => import('@/views/pages/landlord/properties'),
                    meta:
                    {
                        name: 'View Properties',
                        page: 'view',
                    },
                    children:
                        [
                            {
                                path: 'edit',
                                name: 'Edit Landlord / Properties',
                                component: () => import('@/views/pages/landlord/properties'),
                                meta:
                                {
                                    name: 'Edit Properties',

                                    page: 'edit',
                                    subPage: 'main',
                                },
                            },
                        ],
                },
            ],
    },
];