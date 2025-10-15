export default [
    {
        path: '/administration/accounts',
        name: 'Administration / Account',
        component: () => import('@/views/pages/administration/accounts'),
        meta:
        {
            name: 'Account',
            page: 'list',
        },
        children:
            [
                {
                    path: 'create',
                    name: 'Create Administration / Account',
                    component: () => import('@/views/pages/administration/accounts'),
                    meta:
                    {
                        name: 'Create Account',
                        page: 'create',
                        subPage: 'main',
                    },
                },
                {
                    path: ':id',
                    name: 'View Administration / Account',
                    component: () => import('@/views/pages/administration/accounts'),
                    meta:
                    {
                        name: 'View Account',
                        page: 'view',
                    },
                    children:
                        [
                            {
                                path: 'edit',
                                name: 'Edit Administration / Account',
                                component: () => import('@/views/pages/administration/accounts'),
                                meta:
                                {
                                    name: 'Edit Account',

                                    page: 'edit',
                                    subPage: 'main',
                                },
                            },
                        ],
                },
            ],
    },
];