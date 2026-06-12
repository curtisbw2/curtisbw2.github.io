// ZHG nav transparency: transparent only at the very top of the page (PDW
// behavior). Hovering the nav (dropdowns need a background) or any scroll
// removes the transparency. Re-applies across SPA route changes.
(function () {
    var hover = false;

    function headers() {
        return document.querySelectorAll('.HeaderDesktop, .HeaderMobile');
    }

    function update() {
        var top = (window.scrollY || document.documentElement.scrollTop || 0) < 8 && !hover;
        headers().forEach(function (h) {
            h.classList.toggle('zhg-nav-top', top);
            if (!h.__zhgBound) {
                h.__zhgBound = true;
                h.addEventListener('pointerenter', function () { hover = true; update(); });
                h.addEventListener('pointerleave', function () { hover = false; update(); });
            }
        });
    }

    window.addEventListener('scroll', update, { passive: true });
    setInterval(update, 250); // covers Lenis-driven scroll and SPA navigation
    update();
})();
