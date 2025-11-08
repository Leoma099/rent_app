const routesData = [];

(function updateModules() {
    const requireModule = require.context(
        '@/views/',
        true,
        /route.js/
    );

    // console.log("Files Found:", requireModule.keys()); // ✅ Check if files are found

    const root = {
        path: '/',
        name: 'Root',
        redirect: () => {
            const token = localStorage.getItem("access_token");
            const role = parseInt(localStorage.getItem("role"));

            if (token) {
                if (role === 1 || role === 2) return '/dashboard';
                if (role === 3) return '/commercialhub';
            }
            return '/commercialhub';
        }
    };


    routesData.push(root);

    requireModule.keys().forEach((fileName) => {
        const moduleDefinition = requireModule(fileName);
        // console.log(`Module Loaded from ${fileName}:`, moduleDefinition); // ✅ Check content

        moduleDefinition.default.forEach((route) => {
            routesData.push(route);
        });
    });

    routesData.push({ path: '/:catchAll(.*)', redirect: '/404-page-not-found' });
}());

if (process.env.BASE_URL) {
    // console.log(routesData);
}

export default routesData;