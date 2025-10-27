export default [
    {
        path: '/commercialhub',

        name: 'CommercialHub',

        component: () => import('@/views/website'),

        meta: { page: "commercialhub", public: true },
        
        children: [
            {
                path: 'properties/:id',

                name: 'CommercialHubView',

                component: () => import('@/views/website'),

                meta: { page: 'view', public: true }
            },
            {
                path: '/account/profile',

                name: 'Profile',

                component: () => import('@/views/website'),

                meta:
                {
                    page: 'profile',
                    public: true
                }
            },
            {
                path: '/notification',

                name: 'Notification',

                component: () => import('@/views/website'),

                meta:
                {
                    page: 'notification',
                    public: true
                }
            },
            {
                path: '/favorite',

                name: 'Favorite',

                component: () => import('@/views/website'),

                meta:
                {
                    page: 'favorite',
                    public: true
                }
            },
            {
                path: '/message',

                name: 'Message',

                component: () => import('@/views/website'),

                meta:
                {
                    page: 'message',
                    public: true
                }
            },
            {
                path: '/commercialhub/properties',

                name: 'Listing Properties',

                component: () => import('@/views/website'),

                meta:
                {
                    page: 'listing-properties',
                    public: true
                }
            },
        ]
    },
];
