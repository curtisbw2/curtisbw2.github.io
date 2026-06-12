// ZHG responsive-image service worker.
// The app requests images Sanity-style (?w=640&auto=format...), but a static
// host ignores query strings and would serve the full-size original. This
// worker maps each sized request onto a pre-generated WebP variant
// (hash-WxH.w{N}.webp), falling back to the original if no variant exists.
var LADDER = [320, 640, 960, 1280, 1600, 1920];
var IMG_PREFIX = '/_cdn/cdn.sanity.io/images/';

self.addEventListener('install', function () { self.skipWaiting(); });
self.addEventListener('activate', function (e) { e.waitUntil(self.clients.claim()); });

self.addEventListener('fetch', function (e) {
    var url = new URL(e.request.url);
    if (url.origin !== self.location.origin) return;
    if (!url.pathname.startsWith(IMG_PREFIX)) return;
    var w = parseInt(url.searchParams.get('w') || '0', 10);
    if (!w) return; // unsized request: let it pass through to the original

    var step = null;
    for (var i = 0; i < LADDER.length; i++) {
        if (LADDER[i] >= w) { step = LADDER[i]; break; }
    }
    var original = url.pathname; // query stripped
    if (!step) { e.respondWith(fetch(original)); return; }

    var variant = original.replace(/\.\w+$/, '.w' + step + '.webp');
    e.respondWith(
        fetch(variant).then(function (r) {
            return r.ok ? r : fetch(original);
        }).catch(function () { return fetch(original); })
    );
});
