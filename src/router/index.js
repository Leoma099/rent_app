import { createWebHistory, createRouter } from "vue-router";

import routes from './routes';

export const router = createRouter({
    history: createWebHistory(),
    root: '/',
    routes,
});

router.beforeEach((to, from, next) => {
    const hasAccessToken = !!localStorage.getItem("access_token");
    const role = parseInt(localStorage.getItem("role")); 

    const publicPages = ["signin", "commercialhub", "registration", "view"];

    const isPublic = to.matched.some(record => {
        return record.meta && publicPages.includes(record.meta.page);
    });

    const authRequired = !isPublic;

    if (authRequired && !hasAccessToken) {
        return next({ name: "signin" });
    }

    if (hasAccessToken) {
        const isAuthPage = to.matched.some(record => {
            return record.meta && (record.meta.page === "signin" || record.meta.page === "registration");
        });

        if (isAuthPage) {
            if (role === 1 || role === 2) {
                return next({ name: "dashboard" });
            }
            if (role === 3) {
                return next({ name: "commercialhub" });
            }
        }
    }

    if (to.path === "/") {
        if (hasAccessToken) {
            if (role === 1 || role === 2) return next({ name: "dashboard" });
            if (role === 3) return next({ name: "commercialhub" });
        } else {
            return next({ name: "commercialhub" });
        }
    }

    return next();
});



