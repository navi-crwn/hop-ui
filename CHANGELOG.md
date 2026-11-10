# Changelog

All notable changes to `hop/ui` are listed here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions are git tags. The apps pin a commit of `main`, so most changes below reach them before they are tagged.

## [Unreleased]

### Changed

- The bundled fallback manifest is the hub's hop-assets v8 manifest (copied unchanged from HEL.ink `public/hop-assets/apps.json`); the asset URL tests expect v8.
- `<x-hop::footer />` accepts an optional `brand` slot, rendered in place of the family row when given, and a deprecated, ignored `languages` prop. `Assets` imports `Vite` instead of using its full class name. These match the hub's copy of this package; nothing else changes without a `brand` slot.
- `NavTest` and `ChromeTest` set their own `hop.*` config instead of relying on the hub app's, and the hub-layout test is dropped (it needed the hub's `User` model and routes). The package tests run inside a host app: the hub's `php8.3 vendor/bin/pest packages/ui/tests`.

## [0.3.0] - 2026-11-10

### Added

- The footer component shows the family row as the first row inside the footer, for everyone and in both looks: the HOP ID mark and "Part of Hop Easy Link" (linking to hel.ink). "Part of" is translated in all nine languages; the name stays in English.
- `<x-hop::ui />`: hel.ink's `hop-ui.js` and `hop-ui.css` (hop-assets v5), the shared dialogs `HopUI.alert`, `HopUI.confirm` and `HopUI.prompt` that replace the browser's own, and the "Hide · Shows again next week" button on `[data-hop-remind]` reminder cards. The bundled fallback manifest is the hub's v5 manifest (v4 plus the two files).
- FileHop (file.hel.ink) in the bundled fallback manifest, so the family menus, switcher and footer list it even when hel.ink cannot be reached.
- The bundled manifest is the hub's hop-assets v3 manifest, unchanged (fonts, tiles with FileHop's, marks and SRI hashes); the docs page loads the fonts from v3.
- A `file` icon for FileHop's menu entry, the same as the hub's copy of this package.
- `<x-hop::family-nav />`, the "HOP family" block for a dashboard sidebar (HOP ID first, then the other public apps with their marks, the current app left out), and `<x-hop::account-menu />`, the top bar menu with name, email, HOP ID, settings and sign out. The family dashboard layout keeps the primary action, language, theme and account menu in the top bar and the app list in the sidebar.
- `Hop\Ui\Locales`, the one list of nine languages: `en`, `zh-CN`, `de`, `id`, `ja`, `pt-BR`, `es`, `fr` and `ru`. `normalize()` maps the older `zh` and `pt` to `zh-CN` and `pt-BR`, and anything else, such as the retired `ar`, to English.
- `<x-hop::language-switcher />`, showing each language by its native name and a short code, and `<x-hop::app-switcher />`, an accessible dropdown of the family apps. Both close on Escape and move with the arrow keys.
- `<x-hop::footer />`, a columnar footer with the app's links, support, policies, the HOP family list, a language row and a link to the app's changelog.
- Screenshots of the components in the README.

### Changed

- The bundled fallback manifest is the hub's hop-assets v6 manifest: LinkHop and BioHop have new pixel marks (8x8 and 9x9) and FileHop keeps its pixel mark with PNG icons. Nothing else changed from v5.
- Arabic is removed from the language set, and right-to-left languages are not supported.
- The family typography is Inter and Instrument Serif (with JetBrains Mono).
- The HOP ID mark is the official jumping rabbit, and the bundled manifest lists PixelHop at `pixel.hel.ink`.
- The README is rewritten to match the code. It no longer documents a `color` prop on `pill`, a `localStorage` theme sync the package never had, or a `^0.1.0` constraint. The product page is corrected the same way.
- Added this changelog.

### Removed

- The footer's language row and its `languages` prop: the language menu in the top bar is the one place to switch language. The copyright line stays, right-aligned on desktop and centred on phones.

## [0.2.1] - 2026-11-02

### Fixed

- Refreshed the bundled asset manifest after `hop-float.css` changed on hel.ink.

## [0.2.0] - 2026-11-02

### Added

- `<x-hop::fonts />`, `<x-hop::float />`, `<x-hop::family />` and `<x-hop::back />`, and `Hop\Ui\Assets`, which reads the family asset manifest from hel.ink (cached for five minutes, with a bundled copy as fallback) and gives each asset an integrity hash.
- A static checks workflow (`composer validate`, `php -l` on PHP 8.3), `SECURITY.md`, issue templates and the canonical HOP family table with a CI check.

## [0.1.0] - 2026-10-28

### Added

- First version of the shared package: `<x-hop::pill />`, `<x-hop::nav-items />` and `<x-hop::badge />`, and `Hop\Ui\Apps`, which reads the app list from `config/hop.php`. This version was not tagged.
