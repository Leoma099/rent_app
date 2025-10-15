export default [
    {
        path: '/landlord/booking-schedule',
        name: 'Landlord / Booking Schedule',
        component: () => import('@/views/pages/landlord/booking-schedule'),
        meta:
        {
            name: 'Booking Schedule',
            page: 'list',
        },
        children:
            [
                {
                    path: 'create',
                    name: 'Create Landlord / Booking Schedule',
                    component: () => import('@/views/pages/landlord/booking-schedule'),
                    meta:
                    {
                        name: 'Create Booking Schedule',
                        page: 'create',
                        subPage: 'main',
                    },
                },
                {
                    path: ':id',
                    name: 'View Landlord / Booking Schedule',
                    component: () => import('@/views/pages/landlord/booking-schedule'),
                    meta:
                    {
                        name: 'View Booking Schedule',
                        page: 'view',
                    },
                    children:
                        [
                            {
                                path: 'edit',
                                name: 'Edit Landlord / Booking Schedule',
                                component: () => import('@/views/pages/landlord/booking-schedule'),
                                meta:
                                {
                                    name: 'Edit Booking Schedule',

                                    page: 'edit',
                                    subPage: 'main',
                                },
                            },
                        ],
                },
            ],
    },
];