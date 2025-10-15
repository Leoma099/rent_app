export default [
  {
    path: "/dashboard",
    name: "dashboard",
    component: () => import("@/views/panel/index.vue"),
    meta: { page: "dashboard" }
  }
];
