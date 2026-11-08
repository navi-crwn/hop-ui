# Changelog

All notable changes to `hop/ui` are listed here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions are git tags. The apps pin a commit of `main`, so most changes below reach them before they are tagged.

## [Unreleased]

### Added

- FileHop (file.hel.ink) in the bundled fallback manifest, so the family menus, switcher and footer list it even when hel.ink cannot be reached. Its mark is `v2/apps/filehop/mark.svg`, a file added to hop-assets after v1 was frozen.
- `<x-hop::family-nav />`, the "HOP family" block for a dashboard sidebar (HOP ID first, then the other public apps with their marks, the current app left out), and `<x-hop::account-menu />`, the top bar menu with name, email, HOP ID, settings and sign out. The family dashboard layout keeps the primary action, language, theme and account menu in the top bar and the app list in the sidebar.
- `Hop\Ui\Locales`, the one list of nine languages: `en`, `zh-CN`, `de`, `id`, `ja`, `pt-BR`, `es`, `fr` and `ru`. `normalize()` maps the older `zh` and `pt` to `zh-CN` and `pt-BR`, and anything else, such as the retired `ar`, to English.
- `<x-hop::language-switcher />`, showing each language by its native name and a short code, and `<x-hop::app-switcher />`, an accessible dropdown of the family apps. Both close on Escape and move with the arrow keys.
- `<x-hop::footer />`, a columnar footer with the app's links, support, policies, the HOP family list, a language row and a link to the app's changelog.
- Screenshots of the components in the README.

### Changed

- Arabic is removed from the language set, and right-to-left languages are not supported.
- The family typography is Inter and Instrument Serif (with JetBrains Mono).
- The HOP ID mark is the official jumping rabbit, and the bundled manifest lists PixelHop at `pixel.hel.ink`.
- The README is rewritten to match the code. It no longer documents a `color` prop on `pill`, a `localStorage` theme sync the package never had, or a `^0.1.0` constraint. The product page is corrected the same way.
- Added this changelog.

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
