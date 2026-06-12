// ZHG hero title animation, modeled on the reference clip:
// - lines type left-to-right while staying centered at their final width
//   (an invisible sizer reserves the box, live text is pinned to its left edge)
// - only the trailing few characters scramble (a "scramble tail"), the rest settle
// - the sub-row types in slightly behind the title, the emblem fades in mid-sequence
// - the last sub-row line cycles through discrete values before settling
(function () {
    var CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#$%&<>/*';
    var TAIL = 4;        // how many trailing characters scramble while typing
    var CHAR_MS = 32;    // typing speed of the big title (ms per character)
    var SUB_CHAR_MS = 26;

    var BIG_LINES = [
        { text: '© THE ZERO HOUR GROUP', start: 300 },
        { text: 'FINDING SIGNALS', start: 480 },
        { text: 'IN THE NOISE', start: 660 },
    ];
    var SUB_LEFT = [
        { text: 'BY RETAIL', start: 600 },
        { text: 'FOR RETAIL', start: 760 },
    ];
    var SUB_RIGHT_TOP = { text: 'DEFENSE & TECH', start: 820 };
    var EMBLEM_AT = 950; // when the emblem decodes in, between the two columns
    var CYCLE ={ prefix: '→ ', words: ['$ONDS', '$KOPN', '$UMAC', 'SIGNAL'], final: 'DISCOVERY', start: 1150, step: 170 };

    function rnd() { return CHARS[(Math.random() * CHARS.length) | 0]; }

    function makeTyper(el, text, start, charMs) {
        return { el: el, text: text, start: start, charMs: charMs, done: false };
    }

    // line that types left-to-right while staying centered at its final width:
    // an invisible sizer reserves the full text's box, the live text is pinned
    // to its left edge.
    function makeLine(parent, cls, finalText) {
        var line = document.createElement('div');
        if (cls) line.className = cls;
        var wrap = document.createElement('span');
        wrap.className = 'zhg-line-wrap';
        var size = document.createElement('span');
        size.className = 'zhg-line-size';
        size.textContent = finalText;
        var live = document.createElement('span');
        live.className = 'zhg-line-live';
        live.textContent = ' ';
        wrap.appendChild(size);
        wrap.appendChild(live);
        line.appendChild(wrap);
        parent.appendChild(line);
        return live;
    }

    // grow the text; characters older than the tail settle, the tail scrambles
    function renderTyper(tp, t) {
        if (tp.done) return true;
        var n = Math.floor((t - tp.start) / tp.charMs);
        if (n <= 0) { tp.el.textContent = ' '; return false; }
        var settled = Math.max(0, Math.min(tp.text.length, n - TAIL));
        if (settled >= tp.text.length) {
            tp.el.textContent = tp.text;
            tp.done = true;
            return true;
        }
        var out = tp.text.slice(0, settled);
        var visible = Math.min(tp.text.length, n);
        for (var i = settled; i < visible; i++) {
            out += tp.text[i] === ' ' ? ' ' : rnd();
        }
        tp.el.textContent = out || ' ';
        return false;
    }

    // interactive coin: the spin lives in the video's timeline, so velocity is
    // expressed in video-seconds per real second. +1 = natural playback speed.
    // Clicking the left half flicks the coin one way, the right half the other;
    // each click adds an impulse, then friction eases it back to idle speed.
    var COIN = {
        idle: 1,        // resting velocity (normal forward playback)
        impulse: 6,     // velocity kick per click
        damping: 0.9,   // friction: higher = returns to idle faster
        spinSign: 1,    // flip to -1 if footage spins opposite to expectation
    };

    function initCoinPhysics(video) {
        var v = COIN.idle;       // current velocity
        var idleDir = 1;         // direction the coin settles into (+1 = footage forward)
        var scrubbing = false;
        var lastT = 0;

        function step(now) {
            var realDt = (now - lastT) / 1000;
            var dt = Math.min(realDt, 0.05); // motion step, capped for seek sanity
            lastT = now;
            // friction decays on real elapsed time so throttled frames
            // (background tab) don't stretch the spin-down
            var target = idleDir * COIN.idle;
            v = target + (v - target) * Math.exp(-COIN.damping * realDt);
            if (Math.abs(v - target) < 0.05) {
                v = target;
                if (idleDir > 0) {
                    // settled forward: hand control back to native playback
                    scrubbing = false;
                    video.play();
                    return;
                }
                // settled in reverse: native playback can't run backward,
                // so the scrub loop keeps driving the spin indefinitely
            }
            var d = video.duration;
            if (d) {
                var t = video.currentTime + v * dt;
                video.currentTime = ((t % d) + d) % d; // wrap both directions
            }
            requestAnimationFrame(step);
        }

        video.addEventListener('click', function (e) {
            var rect = video.getBoundingClientRect();
            var leftHalf = (e.clientX - rect.left) < rect.width / 2;
            // the clicked side sets the coin's new permanent direction:
            // left = footage forward (clockwise), right = reverse (counter-clockwise)
            idleDir = (leftHalf ? 1 : -1) * COIN.spinSign;
            v += idleDir * COIN.impulse;
            if (!scrubbing) {
                scrubbing = true;
                video.pause();
                lastT = performance.now();
                requestAnimationFrame(step);
            }
        });
    }

    function build(hero) {
        var ov = document.createElement('div');
        ov.className = 'zhg-hero-overlay';
        var inner = document.createElement('div');
        ov.appendChild(inner);

        var typers = [];

        BIG_LINES.forEach(function (l) {
            var live = makeLine(inner, 'zhg-hero-big', l.text);
            typers.push(makeTyper(live, l.text, l.start, CHAR_MS));
        });

        var sub = document.createElement('div');
        sub.className = 'zhg-hero-sub';

        var colL = document.createElement('div');
        colL.className = 'zhg-sub-l';
        SUB_LEFT.forEach(function (l) {
            var live = makeLine(colL, null, l.text);
            typers.push(makeTyper(live, l.text, l.start, SUB_CHAR_MS));
        });

        var img = document.createElement('video');
        img.className = 'zhg-emblem';
        img.src = '/zhg-emblem-coin.mp4';
        img.muted = true;
        img.loop = true;
        img.autoplay = true;
        img.playsInline = true;
        img.setAttribute('aria-label', 'The Zero Hour Group');
        initCoinPhysics(img);

        var colR = document.createElement('div');
        colR.className = 'zhg-sub-r';
        var rTopLive = makeLine(colR, null, SUB_RIGHT_TOP.text);
        typers.push(makeTyper(rTopLive, SUB_RIGHT_TOP.text, SUB_RIGHT_TOP.start, SUB_CHAR_MS));
        var rBottom = makeLine(colR, null, CYCLE.prefix + CYCLE.final);

        sub.appendChild(colL);
        sub.appendChild(img);
        sub.appendChild(colR);
        inner.appendChild(sub);
        hero.appendChild(ov);

        var t0 = performance.now();
        var emblemShown = false;
        var cycleDone = false;

        function renderCycle(t) {
            if (cycleDone) return true;
            if (t < CYCLE.start) return false;
            var idx = Math.floor((t - CYCLE.start) / CYCLE.step);
            if (idx < CYCLE.words.length) {
                rBottom.textContent = CYCLE.prefix + CYCLE.words[idx];
                return false;
            }
            rBottom.textContent = CYCLE.prefix + CYCLE.final;
            cycleDone = true;
            return true;
        }

        function tick(now) {
            var t = now - t0;
            var allDone = true;
            for (var i = 0; i < typers.length; i++) {
                if (!renderTyper(typers[i], t)) allDone = false;
            }
            if (!emblemShown && t >= EMBLEM_AT) {
                emblemShown = true;
                img.classList.add('zhg-emblem-show');
            }
            if (!renderCycle(t)) allDone = false;
            if (!allDone || !emblemShown) requestAnimationFrame(tick);
        }
        requestAnimationFrame(tick);
    }

    setInterval(function () {
        var hero = document.querySelector('.HomeHero');
        if (hero && !hero.__zhgHero && hero.querySelector('video')) {
            hero.__zhgHero = true;
            build(hero);
        }
    }, 300);
})();
