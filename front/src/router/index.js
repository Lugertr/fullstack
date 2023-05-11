import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import store from "../store/index.js";

const routes = [
  {
    path: "/home",
    name: "home",
    component: HomeView,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/login',
    component: () => import('../components/log/AuthorizationComp.vue'),
    meta: {
      requiresAuth: false
    }
  },
  {
    path: '/register',
    component: () => import('../components/log/RegistrationComp.vue'),
    meta: {
      requiresAuth: false
    }
  },
  {
    path: '/register',
    component: () => import('../components/log/RegistrationComp.vue'),
    meta: {
      requiresAuth: false
    }
  },
  { path: '/:catchAll(.*)', redirect: '/home' }
];


const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach(async (to, from, next) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
  console.log(requiresAuth)
  if (requiresAuth !== false) {
    if (!store.state.token) {
      next('/login');
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;
