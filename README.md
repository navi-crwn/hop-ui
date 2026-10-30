# hop/ui

Shared Blade UI components, navigation switchers, and icon assets for the **HOP** family of applications behind [hel.ink](https://hel.ink).

`hop/ui` provides standardized navigation, application switchers, and reusable UI components across all Laravel applications in the HOP ecosystem (`Hub`, `LinkHop`, `BioHop`).

---

## Features

- **Cross-App Navigation**: `<x-hop::nav-items />` component automatically renders links to sister applications configured in `config/hop.php`.
- **Reusable Blade Components**:
  - `<x-hop::pill />`: Status indicator pills with standardized semantic colors.
  - `<x-hop::badge />`: Compact role and count badges.
- **Application Registry Helper**: `Hop\Ui\Apps::all()` provides unified app metadata (slug, title, URL, icon SVG, theme color, current app indicator).
- **Theme Synchronization**: Designed to integrate seamlessly with the shared `localStorage.getItem('helink-theme')` ecosystem standard.

---

## Installation

Within a HOP ecosystem app, add the repository reference in `composer.json`:

```json
"repositories": [
    {
        "type": "vcs",
        "url": "https://github.com/navi-crwn/hop-ui.git"
    }
],
"require": {
    "hop/ui": "^0.1.0"
}
```

Then run:

```bash
composer update hop/ui
```

The `Hop\Ui\UiServiceProvider` will auto-register components under the `hop::` Blade namespace.

---

## Usage

### Cross-App Sidebar Navigation

In your application's layout file (e.g. `resources/views/layouts/app.blade.php`):

```blade
<nav class="sidebar-apps">
    <x-hop::nav-items />
</nav>
```

### Pills and Badges

```blade
<x-hop::pill color="emerald">Active</x-hop::pill>
<x-hop::pill color="amber">Suspended</x-hop::pill>

<x-hop::badge>2FA</x-hop::badge>
```

---

## HOP Family Ecosystem

<!-- hop-family:start -->
<!-- Generated from HEL.ink resources/hop-assets/apps.source.json; edit there, then run scripts/hop_assets.py build. -->
| App | Address | Repository | What it does |
| --- | --- | --- | --- |
| **HOP ID** | [hel.ink](https://hel.ink) · accounts at `hub.hel.ink` | [navi-crwn/HEL.ink](https://github.com/navi-crwn/HEL.ink) | One account for every HOP app. |
| **LinkHop** | [link.hel.ink](https://link.hel.ink) · `hel.ink/l/…` | [navi-crwn/LinkHop](https://github.com/navi-crwn/LinkHop) | Short links, QR codes and click analytics. |
| **BioHop** | [bio.hel.ink](https://bio.hel.ink) · `hel.ink/b/…` | [navi-crwn/BioHop](https://github.com/navi-crwn/BioHop) | One link-in-bio page for everything you do. |
| **PixelHop** | [p.hel.ink](https://p.hel.ink) | [navi-crwn/PixelHop](https://github.com/navi-crwn/PixelHop) | Image hosting with albums and direct links. |
| **NoteHop** | [note.hel.ink](https://note.hel.ink) · `n.hel.ink/…` | [navi-crwn/NoteHop](https://github.com/navi-crwn/NoteHop) | Encrypted notes you share with a link. |
| **Imperium** | private (owner only) | private | The HOP control panel. |
<!-- hop-family:end -->

---

## License

The HOP shared packages are open-source software licensed under the [MIT license](LICENSE).
