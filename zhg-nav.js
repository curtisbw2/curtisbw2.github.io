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

    // lean ZHG footer: two link columns between the wordmark and the
    // copyright/contact row. No legal links, no newsletter, no clutter.
    function enhanceFooter() {
        var wrap = document.querySelector('.Footer .wrapper');
        if (!wrap) return;
        // the app is supposed to reveal the wrapper on first scroll, but its
        // footer init dies silently in the mirror — reveal it ourselves once
        // the app has booted (the header existing is the boot signal)
        if (getComputedStyle(wrap).display === 'none') {
            if (!document.querySelector('.HeaderDesktop, .HeaderMobile')) return;
            wrap.style.display = 'flex';
        }
        if (wrap.querySelector('.zhg-footer-cols')) return;
        var bottom = wrap.querySelector('.bottom');
        if (!bottom) return;
        var cols = document.createElement('div');
        cols.className = 'zhg-footer-cols';
        cols.innerHTML =
            '<div class="zhg-footer-col">' +
            '<h6>Content</h6>' +
            '<a href="/sea/seapower/">Interviews</a>' +
            '<a href="/land/counter-intrusion/">Coverage</a>' +
            '<a href="/air/tactical-reconnaissance-and-strike/">Explainers</a>' +
            '<a href="/lattice/command-and-control/">How We Work</a>' +
            '</div>' +
            '<div class="zhg-footer-col">' +
            '<h6>Connect</h6>' +
            '<a href="https://x.com/Zero_Hour_Group" target="_blank" rel="noopener">X / Twitter</a>' +
            '<a href="#">YouTube</a>' +
            '<a href="#">Substack</a>' +
            '<a href="mailto:contact@thezerohourgroup.com">contact@thezerohourgroup.com</a>' +
            '</div>' +
            '<div class="zhg-footer-col zhg-footer-tag">' +
            '<h6>The Zero Hour Group</h6>' +
            '<p>Defense &amp; tech investor discovery.<br>By retail, for retail.</p>' +
            '</div>';
        wrap.insertBefore(cols, bottom);
    }

    window.addEventListener('scroll', update, { passive: true });
    setInterval(function () { update(); enhanceFooter(); }, 250); // covers Lenis scroll + SPA navigation
    update();
})();
