# hop/ui

[English](README.md) · [简体中文](README.zh-CN.md) · **Deutsch** · [Bahasa Indonesia](README.id.md) · [日本語](README.ja.md) · [Português (Brasil)](README.pt-BR.md) · [Español](README.es.md) · [Français](README.fr.md) · [Русский](README.ru.md)

Die gemeinsamen Blade-Komponenten und Familiendaten für die Laravel-Apps der HOP-Familie ([hel.ink](https://hel.ink)): die Familiennavigation, die Menüs für Sprache, Apps und Konto, die Fußzeile, die Typografie und die schwebenden Kacheln sowie die eine Liste der unterstützten Sprachen. Jede App, die das Paket nutzt, sieht an diesen Stellen gleich aus und verhält sich gleich.

## Screenshots

Sie stammen aus dem BioHop-Dashboard und der BioHop-Startseite, lokal mit einem Demo-Konto ausgeführt, mit diesem Paket auf `main`.

![Die BioHop-Seitenleiste mit der Liste der HOP-Familie: HOP ID, LinkHop, PixelHop und NoteHop, jeweils mit ihrem Zeichen. BioHop selbst steht nicht in der Liste.](docs/images/family-nav.png)

![Das Sprachmenü in der oberen Leiste, geöffnet: neun Sprachen, links der native Name, rechts ein kurzer Code.](docs/images/language-switcher.png)

![Das Kontomenü in der oberen Leiste, geöffnet: Initiale, Name und E-Mail des Demo-Nutzers, danach Account (HOP ID), Settings und Sign out.](docs/images/account-menu.png)

![Der App-Umschalter im Seitenkopf, geöffnet: HOP ID, LinkHop, BioHop, PixelHop und NoteHop, wobei BioHop als aktuelle App markiert ist.](docs/images/app-switcher.png)

## Voraussetzungen

- PHP 8.3 und Laravel 12 (`illuminate/support` ^12.0).
- Eine gemeinsame `config/hop.php` in der App (siehe unten).
- Tailwind CSS in der App. `pill`, `badge`, `nav-items`, `family-nav` und `footer` sind mit Tailwind-Utility-Klassen geschrieben (und mit `dark:`-Varianten für die Klasse `dark`), und `nav-items` und `family-nav` nutzen die eigene Klasse `nav-item` der App. Deshalb muss der Tailwind-Build der App die Views dieses Pakets scannen. Die drei Menüs (`language-switcher`, `app-switcher`, `account-menu`) bringen ihr eigenes CSS und JavaScript mit. `family` und `back` haben keine Styles; die App gestaltet `hop-family-*` und `hop-back`.
- Netzwerkzugriff auf `hel.ink` im Browser. Schriften, schwebende Kacheln und die App-Zeichen werden von `https://hel.ink/hop-assets/` geladen, mit Subresource-Integrity-Hashes. Die Content Security Policy der App muss diesen Host also erlauben.

## Installation

Das Paket ist nicht auf Packagist. Füge das Repository zur `composer.json` der App hinzu:

```json
"repositories": [
    {
        "type": "vcs",
        "url": "https://github.com/navi-crwn/hop-ui.git"
    }
],
"require": {
    "hop/ui": "^0.2.1"
}
```

Führe dann aus:

```bash
composer update hop/ui
```

Das neueste Tag, `v0.2.1`, enthält nicht alles, was hier beschrieben ist. `family-nav`, `account-menu`, `app-switcher`, `language-switcher`, `footer` und die Liste `Locales` kamen erst danach hinzu. Bis zum nächsten Tag verlangst du `dev-main` (die Apps pinnen einen Commit von `main`).

`Hop\Ui\UiServiceProvider` wird automatisch erkannt. Er registriert die Views unter dem Namespace `hop::` und stellt die Komponenten als `<x-hop::name />` bereit. Um die Views zu überschreiben, veröffentliche sie:

```bash
php artisan vendor:publish --tag=hop-ui-views
```

## Was die App bereitstellt

Die Navigation liest die App-Liste aus `config/hop.php`:

```php
return [
    'current' => 'biohop',                 // this app's slug; 'hub' in the hub
    'hub_url' => 'https://hub.hel.ink',
    'apps' => [
        'linkhop' => [
            'name' => 'LinkHop',
            'url' => 'https://link.hel.ink',
            'icon' => 'link',              // hop, link, bio, image, note or globe
            'color' => 'indigo',
            'start' => '/auth/sso',        // optional; opens the app through its SSO start
            'enabled' => true,             // optional; false hides the app
        ],
    ],
];
```

Das Paket liefert keine Übersetzungen mit. Die Strings, die es durch `__()` gibt (etwa `HOP Family`, `Language`, `Account`, `Sign out`, `Settings`, `Changelog`), übersetzen die eigenen Sprachdateien der App. Einige Strings sind einfaches Englisch: das Standard-`a HOP app` von `badge`, das `Back` von `back` sowie der Standardtitel und die Einleitung von `family`.

## Komponenten

| Komponente | Props | Was sie rendert |
| --- | --- | --- |
| `<x-hop::fonts />` | keine | In `<head>`: die Typografie der Familie (Inter, Instrument Serif und JetBrains Mono) von hel.ink. Nutze `var(--hop-font-display)`, `var(--hop-font-body)`, `var(--hop-font-serif)` und `var(--hop-font-mono)`. |
| `<x-hop::float />` | `mode`: `fixed` (Standard) oder `section` | Die schwebenden HOP-Kacheln, gezeichnet von `hop-float.js` auf hel.ink. `section` füllt eine Box mit `position: relative`. |
| `<x-hop::ui />` | keine | Einmal im Layout, nach den Schriften: `hop-ui.js` und `hop-ui.css` von hel.ink. `HopUI.alert`, `HopUI.confirm` und `HopUI.prompt` ersetzen die Dialoge des Browsers (Promises, Tastatur zuerst, neun Sprachen, ein roter Button, der nennt, was gelöscht wird); `[data-hop-remind]`-Karten bekommen einen Button „Ausblenden · Erscheint nächste Woche wieder“, der den Schlüssel an `data-hop-remind-url` sendet. |
| `<x-hop::family />` | `current`, `title`, `intro` | Ein Abschnitt, der jede öffentliche App mit ihrem Zeichen und ihrem Slogan auflistet. Die aktuelle App ist markiert und nicht verlinkt. |
| `<x-hop::back />` | `href` (Standard: die Startseite der App), `label` | Ein Zurück-Link für Unterseiten. |
| `<x-hop::badge />` | Slot | Eine kleine Pille, die auf den Hub verlinkt. Sie zeigt `a HOP app`, außer du gibst ihr einen anderen Text. |
| `<x-hop::pill />` | keine | Eine Reihe von Pillen, eine pro App aus `config/hop.php` plus der Hub, mit der aktuellen App gefüllt. |
| `<x-hop::nav-items />` | `except`: Slugs, die ausgelassen werden | Listeneinträge für die anderen Apps, für ein vorhandenes `<ul>`. |
| `<x-hop::family-nav />` | `app`, `label` | Der Block „HOP family“ für die Seitenleiste eines Dashboards: zuerst HOP ID, dann die anderen öffentlichen Apps mit ihren Zeichen. Die aktuelle App fehlt. |
| `<x-hop::app-switcher />` | `app` | Ein Dropdown mit jeder öffentlichen App. Die aktuelle hat `aria-current`. |
| `<x-hop::language-switcher />` | keine | Ein Dropdown mit den neun Sprachen. Die Auswahl hängt `?lang=<code>` an die aktuelle URL an. |
| `<x-hop::account-menu />` | `user`, `settings-url`, `account-url`, `logout-url` | Ein Dropdown mit Initiale, Name und E-Mail der Person sowie Links zu HOP ID, zu den Einstellungen und einem Abmeldeformular. Ein Link oder das Formular fehlt, wenn seine URL nicht angegeben ist. |
| `<x-hop::footer />` | `app`, `name`, `repo`, `features-url`, `status-url`, `abuse-url`, `languages` | Die Fußzeile in Spalten: die Links der App, Support, Richtlinien, die Liste der HOP-Familie und eine Sprachzeile. |

Das Dashboard-Layout der Familie setzt die Hauptaktion, das Sprachmenü, den Theme-Schalter und das Kontomenü in die obere Leiste und `family-nav` in die Seitenleiste. Die Fußzeile verlinkt auf `/about`, `/changelog`, `/help`, `/faq`, `/contact`, `/terms` und `/privacy` auf der eigenen Domain der App. Die App muss diese Pfade also bereitstellen.

```blade
<head>
    <x-hop::fonts />
</head>
<aside>
    <x-hop::family-nav app="biohop" />
</aside>
<header>
    <x-hop::language-switcher />
    <x-hop::account-menu :user="$user" :settings-url="route('settings')" :account-url="$hubSettingsUrl" :logout-url="route('logout')" />
</header>
```

Die Menüs schließen sich mit Escape und bei einem Klick außerhalb, und die Pfeiltasten, Pos1 und Ende bewegen sich durch ihre Links. Ihre Styles und ihr Skript werden einmal pro Seite eingebunden, egal wie viele Menüs es gibt, und nutzen die CSP-Nonce aus `Vite::cspNonce()`, wenn die App eine setzt.

## PHP-Klassen

### `Hop\Ui\Apps`

`Apps::all()` gibt den Hub und die aktivierten Apps aus `config/hop.php` als Arrays mit `slug`, `name`, `url`, `open`, `icon`, `color` und `current` zurück. `open` ist das Ziel eines Links: vom Hub aus ist es `{hub}/apps/{slug}`, von einer App aus die URL der App plus ihr `start`-Pfad (standardmäßig `/auth/sso`). `Apps::icon($name)` gibt den SVG-Pfad eines Icons zurück und fällt auf `globe` zurück.

### `Hop\Ui\Assets`

Das Asset-Manifest der Familie listet die Schriften, die schwebenden Kacheln und die Zeichen jeder App, jeweils mit einem Integritäts-Hash.

- `Assets::manifest()` liest `https://hel.ink/hop-assets/apps.json` mit einem Timeout von 2 Sekunden und cacht das Ergebnis für 5 Minuten (Cache-Key `hop-ui:assets`). So erreicht eine neue Asset-Version jede App ohne Release. Ist hel.ink nicht erreichbar oder sendet es etwas Unbrauchbares, nutzt die Methode die mitgelieferte Kopie in `resources/hop-assets/apps.json`. Eine fehlgeschlagene Anfrage wird als Warnung geloggt.
- `Assets::family($current)` gibt die öffentlichen Apps in der Reihenfolge der Familie zurück, mit der aktuellen App markiert. `Assets::asset($key)` gibt URL und Integritäts-Hash von `fonts_css`, `float_css` oder `float_js` zurück.
- Konfiguration: `hop-ui.assets.remote` schaltet das entfernte Lesen ab (während Unit-Tests ist es standardmäßig aus), und `hop-ui.assets.url` ändert die Adresse. Es gibt keine Konfigurationsdatei zum Veröffentlichen; setze diese Werte in einer eigenen Konfigurationsdatei namens `hop-ui.php`.
- `scripts/sync-hop-assets.sh [path to a HEL.ink checkout]` aktualisiert die mitgelieferte Kopie aus einem Checkout, oder von hel.ink, wenn kein Pfad angegeben ist.

### `Hop\Ui\Locales`

Die eine Liste der Sprachen, die jede HOP-App mitliefert: English `en`, 简体中文 `zh-CN`, Deutsch `de`, Bahasa Indonesia `id`, 日本語 `ja`, Português (Brasil) `pt-BR`, Español `es`, Français `fr` und Русский `ru`. Sprachen, die von rechts nach links geschrieben werden, gehören nicht dazu.

- `Locales::ALL` ordnet jedem Code seinen nativen `name` und ein `short`-Label zu. `codes()` und `names()` liefern die Codes und die nativen Namen, `short($code)` das Label.
- `Locales::resolve($value)` gibt einen unterstützten Code oder `null` zurück. Die Methode bildet das ältere `zh` auf `zh-CN` und `pt` auf `pt-BR` ab und ignoriert Groß- und Kleinschreibung.
- `Locales::normalize($value)` ist `resolve()` mit Fallback: Alles Leere, Unbekannte oder Ausgemusterte, etwa `ar`, wird zu `en`.

Der Sprachumschalter und die Sprachzeile der Fußzeile werden aus dieser Liste erzeugt.

## Tests

Die Tests in `tests/Feature` sind Pest-Tests, die in einer App laufen, die das Paket nutzt (HEL.ink enthält eine Kopie in `packages/ui`). Die eigene CI dieses Repositorys prüft, dass `composer.json` gültig ist, dass jede PHP-Datei unter PHP 8.3 den Lint besteht und dass die Familientabelle unten der kanonischen Tabelle entspricht.

## Sicherheit

Melde Schwachstellen wie in [SECURITY.md](SECURITY.md) beschrieben, nicht in öffentlichen Issues.

## Änderungsprotokoll

Siehe [CHANGELOG.md](CHANGELOG.md).

## Selbst hosten

Um HOP zu betreiben, installierst du dieses Paket nicht von Hand. LinkHop und BioHop führen dieses öffentliche Repository in ihrer `composer.json` (gepinnt auf einen Commit von `main`), daher holt `composer install` es ohne Token, und der Hub ([HEL.ink](https://github.com/navi-crwn/HEL.ink)) enthält eine Kopie in `packages/ui`. Auf deiner eigenen Domain beachte zwei Dinge: Die Schriften, schwebenden Kacheln und App-Zeichen laden weiterhin von `https://hel.ink/hop-assets/` (erlaube diesen Host in deiner Content Security Policy; ohne ihn fallen die Seiten auf Systemschriften zurück und zeigen keine Kacheln), und die Familienliste kommt aus dem Manifest von hel.ink, außer du setzt `hop-ui.assets.url` oder schaltest das entfernte Lesen mit `hop-ui.assets.remote` ab, um die mitgelieferte Kopie zu nutzen. Den Rest behandelt die Anleitung der Familie: [docs/self-hosting.md](https://github.com/navi-crwn/HEL.ink/blob/main/docs/self-hosting.md).

## HOP-Familie

<!-- hop-family:start -->
<!-- Generated from HEL.ink resources/hop-assets/apps.source.json; edit there, then run scripts/hop_assets.py build. -->
| App | Address | Repository | What it does |
| --- | --- | --- | --- |
| **HOP ID** | [hel.ink](https://hel.ink) · accounts at `hub.hel.ink` | [navi-crwn/HEL.ink](https://github.com/navi-crwn/HEL.ink) | One account for every HOP app. |
| **LinkHop** | [link.hel.ink](https://link.hel.ink) · `hel.ink/l/…` | [navi-crwn/LinkHop](https://github.com/navi-crwn/LinkHop) | Short links, QR codes and click analytics. |
| **BioHop** | [bio.hel.ink](https://bio.hel.ink) · `hel.ink/b/…` | [navi-crwn/BioHop](https://github.com/navi-crwn/BioHop) | One link-in-bio page for everything you do. |
| **PixelHop** | [pixel.hel.ink](https://pixel.hel.ink) · `p.hel.ink/…` | [navi-crwn/PixelHop](https://github.com/navi-crwn/PixelHop) | Image hosting with albums and direct links. |
| **NoteHop** | [note.hel.ink](https://note.hel.ink) · `n.hel.ink/…` | [navi-crwn/NoteHop](https://github.com/navi-crwn/NoteHop) | Encrypted notes you share with a link. |
| **FileHop** | [file.hel.ink](https://file.hel.ink) | [navi-crwn/FileHop](https://github.com/navi-crwn/FileHop) | Convert files in your browser; nothing is uploaded. |
| **Imperium** | not public-facing: optional, for admins | [navi-crwn/Imperium](https://github.com/navi-crwn/Imperium) | The HOP control panel. |
<!-- hop-family:end -->

## Lizenz

Die gemeinsamen HOP-Pakete sind Open-Source-Software unter der [MIT-Lizenz](LICENSE).
