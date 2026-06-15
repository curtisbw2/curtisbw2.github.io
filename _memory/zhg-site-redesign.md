---
name: zhg-site-redesign
description: "Zero Hour Group website redesign — Anduril clone rebranded as ZHG template; architecture, workflows, current state"
metadata: 
  node_type: memory
  type: project
  originSessionId: 992f441f-82c1-41da-b856-4f72f54e8831
---

The user (Zero Hour Group, retail-investor defense/tech media brand) is redesigning thezerohourgroup.com using anduril.com as a visual template, with PDW (pdw.ai) as a secondary reference.

Key facts (as of June 2026):
- Live ZHG site source: `D:\buckyy\zero_hour\site` — read `BRAND_CONTEXT.md` there fresh each time (user edits it). Brand: solid black bg, orange accent #F07020, "institutional-lite" investor tone. ZHG media assets in `site\assets` (logos, emblems, broll videos).
- Working dir: `D:\buckyy\zero_hour\site-beta`. Three local servers via .claude/launch.json: `anduril-mirror` raw clone :8741, `zhg-beta` (the rebranded site, a git repo) :8742, `pdw-mirror` :8743.
- **zhg-beta is PUBLIC**: pushed to github.com/curtisbw2/curtisbw2.github.io, live at curtisbw2.github.io (GitHub Pages, .nojekyll required for _cdn dir). User's real site is repo curtisbw2/Zero-Hour with custom domain thezerohourgroup.com — unrelated, untouched.
- Anduril site architecture: WebGL/JS app; page content in `ssgContent` JSON in each HTML; nav/footer in `ssgSiteSettings`; media via sanity URL builder — `"baseUrl"` in page JSON + 2 literals in app.js, all localized to `/_cdn/cdn.sanity.io`. A service worker (`zhg-sw.js`) maps `?w=` requests to pre-generated WebP variants (`hash-WxH.w{N}.webp`, gen-variants.mjs). Hero/nav/footer/cc-section customizations live in `zhg-hero.js/css`, `zhg-nav.js/css` (injected before </body>).
- **Cache rules**: media swaps need fresh asset ids (hash renames, history: feedf00d→cafebabe→beefcafe for hero). Companion scripts use `?v=YYYYMMDDHHMM` stamps in HTML references — bump on every script change. Pages CDN caches 10 min.
- The app's Footer component never initializes in the mirror — zhg-nav.js reveals `.Footer .wrapper` itself post-boot and injects the compact ZHG footer (logo left, Content+Connect columns right, no legal).
- Homepage flow: full-viewport black hero (scramble/typewriter title "© THE ZERO HOUR GROUP / FINDING SIGNALS / IN THE NOISE", interactive coin video with click-spin physics in zhg-hero.js) → "Our Focus" PDW-style carousel → 7 company cards (user's images, swap-cards.mjs) → footer. Featured Interview section parked (park-announcement.mjs --restore brings it back). Hero background video exists but hidden via CSS (zhg-hero.css) — black bg instead.
- **PDW local study setup (NOT for publishing)**: pdw-mirror runs PDW's real code; `zhg-study.js` (in pdw-mirror/site) restyles their "Core competencies" → black "Our Focus", 4 ZHG slides (Technology of Tomorrow/Defense/AI Robotics/Energy + dash-free copy), user's images in `zhg-img/`, white rail with orange active dot (class-based recolor, never overwrite app inline styles). Fifth slide removed AT DATA LEVEL via drop-fifth-slide.mjs (edits static li + flight data in index.html — DOM hiding/clamping approaches all failed; lesson: their slider transforms each slide individually, no single track). On localhost, zhg-beta's homepage embeds this section via iframe from :8743 (localhost-gated in zhg-hero.js, CSP frame-src includes localhost:8743, falls back to the rebuilt section after 12s if mirror down). The rebuilt zhg-cc section in zhg-hero.js mirrors the same content and ships publicly.
- **Boundary the user accepted**: PDW/Anduril code+photos+copy stay local-only for study; only rebuilt implementations and ZHG content get pushed. Some session edits supporting the embed are deliberately uncommitted in zhg-beta (embed logic is hostname-gated so safe either way).
- Preview quirks: the headless preview browser intermittently fails to boot the Anduril app (stalls at sprite/theatre load, `?w=0` hero request) — restart server/reload until it boots; user's real browser always boots. PDW page screenshots often time out (videos). rAF and even intervals are suspended in occluded preview tabs — don't trust loop-based code verification there.
- Transform scripts all in `anduril-mirror\`: capture.mjs, zhgify.mjs/zhgify2.mjs, swap-cards.mjs, swap-announcement-image.mjs, park-announcement.mjs, gen-variants.mjs, gen-hero.mjs, backfill-manifest.mjs (mobile fix — manifest assets; heavy 3D dirs gitignored), drop-fifth-slide.mjs, capture-pdw.mjs.
- User contact for footer: contact@thezerohourgroup.com, X @Zero_Hour_Group; YouTube/Substack URLs unknown (placeholder # links in footer).
