import { createRouter, createWebHistory } from "vue-router";
import store from "../store/index.js";

const routes = [
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
    path: '/clients',
    component: () => import('../components/client/ClientTable.vue'),
    meta: {
      requiresAuth: false
    }
  },
  {
    path: '/apps',
    component: () => import('../components/log/AuthorizationComp.vue'),
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/app-types',
    component: () => import('../components/log/AuthorizationComp.vue'),
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/services',
    component: () => import('../components/log/AuthorizationComp.vue'),
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/service-types',
    component: () => import('../components/log/AuthorizationComp.vue'),
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/users',
    component: () => import('../components/log/AuthorizationComp.vue'),
    meta: {
      requiresAuth: true
    }
  },
  { path: '/:catchAll(.*)', redirect: '/clients' }
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
