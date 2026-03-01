const CACHE_NAME = 'fitcoach-v17';
const urlsToCache = [
    './index.html',
    './manifest.json',
    './css/variables.css',
    './css/base.css',
    './css/components.css',
    './css/layout.css',
    './css/pages.css',
    './js/store.js',
    './js/router.js',
    './js/ui.js',
    './js/ai-engine.js',
    './js/app.js'
];

// Install Event - cache core files
self.addEventListener('install', event => {
    self.skipWaiting(); // Force the waiting service worker to become the active service worker.
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => {
                return cache.addAll(urlsToCache);
            })
    );
});

// Fetch Event - Network First Strategy (ensure latest UI shows up instantly)
self.addEventListener('fetch', event => {
    event.respondWith(
        fetch(event.request)
            .then(response => {
                // If network fetch successful, clone response and update cache
                const resClone = response.clone();
                caches.open(CACHE_NAME).then(cache => {
                    cache.put(event.request, resClone);
                });
                return response;
            })
            .catch(() => {
                // If network fails (offline), return cached version
                return caches.match(event.request);
            })
    );
});

// Activate Event - clean up old caches
self.addEventListener('activate', event => {
    event.waitUntil(clients.claim()); // Take control of all open pages immediately
    const cacheWhitelist = [CACHE_NAME];
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    if (cacheWhitelist.indexOf(cacheName) === -1) {
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
});
