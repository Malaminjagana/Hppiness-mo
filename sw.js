const CACHE_NAME = 'jagana-v3';
self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(['./index.html', './manifest.json', './js/config.js'])));
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => key.startsWith('jagana-') && key !== CACHE_NAME).map(key => caches.delete(key)))));
});
self.addEventListener('fetch', e => {
  e.respondWith(caches.match(e.request).then(response => response || fetch(e.request)).catch(() => caches.match('./index.html')));
});