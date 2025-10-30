export default [
    {
        path: '/administration/properties',
        name: 'Administration / Properties',
        component: () => import('@/views/pages/administration/properties'),
        meta:
        {
            name: 'Properties',
            page: 'list',
        },
        children:
            [
                {
                    path: 'create',
                    name: 'Create Administration / Properties',
                    component: () => import('@/views/pages/administration/properties'),
                    meta:
                    {
                        name: 'Create Properties',
                        page: 'create',
                        subPage: 'main',
                    },
                },
                {
                    path: ':id',
                    name: 'View Administration / Properties',
                    component: () => import('@/views/pages/administration/properties'),
                    meta:
                    {
                        name: 'View Properties',
                        page: 'view',
                        subPage: 'main',
                    },
                    // children:
                    // [
                    //     {
                    //         path: 'edit',
                    //         name: 'Edit Administration / Properties',
                    //         component: () => import('@/views/pages/administration/properties'),
                    //         meta:
                    //         {
                    //             name: 'Edit Properties',

                    //             page: 'edit',
                    //             subPage: 'main',
                    //         },
                    //     },
                    // ],
                },
            ],
    },
];