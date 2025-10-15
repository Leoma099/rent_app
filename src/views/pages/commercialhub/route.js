export default [
    {
        path: '/commercialhub',
        name: 'CommercialHub',
        component: () => import('@/views/pages/commercialhub'),
        meta:
        {
            page: "commercialhub"
        },
        children:
        [
            {
                path: 'browser',
                name: 'Browser',
                component: () => import('@/views/pages/commercialhub'),
                meta:
                {
                    name: 'Browser',
                    page: 'browser',
                },
            }
        ]
    },
];