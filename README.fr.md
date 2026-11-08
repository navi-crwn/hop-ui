# hop/ui

[English](README.md) · [简体中文](README.zh-CN.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [日本語](README.ja.md) · [Português (Brasil)](README.pt-BR.md) · [Español](README.es.md) · **Français** · [Русский](README.ru.md)

Les composants Blade et les données de famille partagés par les applications Laravel de la famille HOP ([hel.ink](https://hel.ink)) : la navigation de la famille, les menus de langue, d'applications et de compte, le pied de page, la typographie et les tuiles flottantes, et la liste unique des langues prises en charge. Toutes les applications qui l'utilisent ont le même aspect et le même comportement à ces endroits.

## Captures d'écran

Elles proviennent du tableau de bord et de la page d'accueil de BioHop, lancés en local avec un compte de démonstration, avec ce paquet sur `main`.

![La barre latérale de BioHop avec la liste de la famille HOP : HOP ID, LinkHop, PixelHop et NoteHop, chacune avec sa marque. BioHop lui-même n'y figure pas.](docs/images/family-nav.png)

![Le menu de langue dans la barre supérieure, ouvert : neuf langues, avec le nom natif à gauche et un code court à droite.](docs/images/language-switcher.png)

![Le menu de compte dans la barre supérieure, ouvert : l'initiale, le nom et l'e-mail de l'utilisateur de démonstration, puis Account (HOP ID), Settings et Sign out.](docs/images/account-menu.png)

![Le sélecteur d'applications dans l'en-tête du site, ouvert : HOP ID, LinkHop, BioHop, PixelHop et NoteHop, avec BioHop marquée comme application actuelle.](docs/images/app-switcher.png)

## Prérequis

- PHP 8.3 et Laravel 12 (`illuminate/support` ^12.0).
- Un fichier `config/hop.php` partagé dans l'application (voir plus bas).
- Tailwind CSS dans l'application. `pill`, `badge`, `nav-items`, `family-nav` et `footer` sont écrits avec des classes utilitaires Tailwind (et des variantes `dark:` pour la classe `dark`), et `nav-items` et `family-nav` utilisent la classe `nav-item` propre à l'application : le build Tailwind de l'application doit donc analyser les vues de ce paquet. Les trois menus (`language-switcher`, `app-switcher`, `account-menu`) apportent leur propre CSS et JavaScript. `family` et `back` n'ont pas de styles ; l'application stylise `hop-family-*` et `hop-back`.
- Un accès réseau à `hel.ink` depuis le navigateur. Les polices, les tuiles flottantes et les marques des applications sont chargées depuis `https://hel.ink/hop-assets/`, avec des empreintes subresource integrity : la Content Security Policy de l'application doit donc autoriser cet hôte.

## Installation

Le paquet n'est pas sur Packagist. Ajoutez le dépôt au `composer.json` de l'application :

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

Puis lancez :

```bash
composer update hop/ui
```

Le dernier tag, `v0.2.1`, ne contient pas tout ce qui est décrit ici. `family-nav`, `account-menu`, `app-switcher`, `language-switcher`, `footer` et la liste `Locales` ont été ajoutés après lui. Jusqu'au prochain tag, demandez `dev-main` (les applications épinglent un commit de `main`).

`Hop\Ui\UiServiceProvider` est découvert automatiquement. Il enregistre les vues sous l'espace de noms `hop::` et rend les composants disponibles sous la forme `<x-hop::name />`. Pour remplacer les vues, publiez-les :

```bash
php artisan vendor:publish --tag=hop-ui-views
```

## Ce que fournit l'application

La navigation lit la liste des applications dans `config/hop.php` :

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

Le paquet ne fournit aucune traduction. Les chaînes qu'il passe par `__()` (comme `HOP Family`, `Language`, `Account`, `Sign out`, `Settings`, `Changelog`) sont traduites par les fichiers de langue de l'application, et quelques chaînes restent en anglais : le `a HOP app` par défaut de `badge`, le `Back` de `back`, ainsi que le titre et l'introduction par défaut de `family`.

## Composants

| Composant | Props | Ce qu'il affiche |
| --- | --- | --- |
| `<x-hop::fonts />` | aucune | Dans `<head>` : la typographie de la famille (Inter, Instrument Serif et JetBrains Mono) depuis hel.ink. Utilisez `var(--hop-font-display)`, `var(--hop-font-body)`, `var(--hop-font-serif)` et `var(--hop-font-mono)`. |
| `<x-hop::float />` | `mode` : `fixed` (par défaut) ou `section` | Les tuiles HOP flottantes, dessinées par `hop-float.js` de hel.ink. `section` remplit une boîte en `position: relative`. |
| `<x-hop::ui />` | aucun | Une fois dans la mise en page, après les polices : `hop-ui.js` et `hop-ui.css` de hel.ink. `HopUI.alert`, `HopUI.confirm` et `HopUI.prompt` remplacent les dialogues du navigateur (Promesses, clavier d'abord, neuf langues, un bouton rouge qui nomme ce qui est supprimé) ; les cartes `[data-hop-remind]` reçoivent un bouton « Masquer · Réapparaît la semaine prochaine » qui envoie la clé à `data-hop-remind-url`. |
| `<x-hop::family />` | `current`, `title`, `intro` | Une section qui liste chaque application publique avec sa marque et son slogan. L'application actuelle est marquée et sans lien. |
| `<x-hop::back />` | `href` (par défaut : l'accueil de l'application), `label` | Un lien de retour pour les pages internes. |
| `<x-hop::badge />` | slot | Une petite pastille qui renvoie vers le hub. Elle affiche `a HOP app`, sauf si vous lui donnez un autre texte. |
| `<x-hop::pill />` | aucune | Une rangée de pastilles, une par application de `config/hop.php` plus le hub, avec l'application actuelle remplie. |
| `<x-hop::nav-items />` | `except` : slugs à exclure | Des éléments de liste pour les autres applications, à placer dans un `<ul>` existant. |
| `<x-hop::family-nav />` | `app`, `label` | Le bloc « HOP family » pour la barre latérale d'un tableau de bord : HOP ID d'abord, puis les autres applications publiques avec leurs marques. L'application actuelle est exclue. |
| `<x-hop::app-switcher />` | `app` | Un menu déroulant avec toutes les applications publiques. L'application actuelle porte `aria-current`. |
| `<x-hop::language-switcher />` | aucune | Un menu déroulant avec les neuf langues. En choisir une ajoute `?lang=<code>` à l'URL actuelle. |
| `<x-hop::account-menu />` | `user`, `settings-url`, `account-url`, `logout-url` | Un menu déroulant avec l'initiale, le nom et l'e-mail de la personne, et des liens vers HOP ID, les paramètres et un formulaire de déconnexion. Un lien ou le formulaire est omis quand son URL n'est pas fournie. |
| `<x-hop::footer />` | `app`, `name`, `repo`, `features-url`, `status-url`, `abuse-url`, `languages` | Le pied de page en colonnes : les liens de l'application, l'assistance, les politiques, la liste de la famille HOP et une ligne de langues. |

La mise en page de tableau de bord de la famille place l'action principale, le menu de langue, le bouton de thème et le menu de compte dans la barre supérieure, et `family-nav` dans la barre latérale. Le pied de page renvoie vers `/about`, `/changelog`, `/help`, `/faq`, `/contact`, `/terms` et `/privacy` sur le domaine de l'application : l'application doit donc servir ces chemins.

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

Les menus se ferment avec Échap et sur un clic à l'extérieur, et les flèches, Début et Fin parcourent leurs liens. Leurs styles et leur script sont inclus une seule fois par page, quel que soit le nombre de menus, et utilisent le nonce CSP de `Vite::cspNonce()` quand l'application en définit un.

## Classes PHP

### `Hop\Ui\Apps`

`Apps::all()` renvoie le hub et les applications activées de `config/hop.php` sous forme de tableaux avec `slug`, `name`, `url`, `open`, `icon`, `color` et `current`. `open` est la cible d'un lien : depuis le hub, c'est `{hub}/apps/{slug}` ; depuis une application, c'est l'URL de l'application suivie de son chemin `start` (`/auth/sso` par défaut). `Apps::icon($name)` renvoie le chemin SVG d'une icône, et se rabat sur `globe`.

### `Hop\Ui\Assets`

Le manifeste des ressources de la famille liste les polices, les tuiles flottantes et les marques de chaque application, chacune avec une empreinte d'intégrité.

- `Assets::manifest()` lit `https://hel.ink/hop-assets/apps.json` avec un délai de 2 secondes et le met en cache pendant 5 minutes (clé de cache `hop-ui:assets`) : une nouvelle version des ressources atteint ainsi chaque application sans nouvelle release. Si hel.ink est injoignable, ou envoie quelque chose d'inutilisable, la méthode utilise la copie fournie dans `resources/hop-assets/apps.json`. Une requête en échec est journalisée comme avertissement.
- `Assets::family($current)` renvoie les applications publiques dans l'ordre de la famille, avec l'application actuelle marquée. `Assets::asset($key)` renvoie l'URL et l'empreinte d'intégrité de `fonts_css`, `float_css` ou `float_js`.
- Configuration : `hop-ui.assets.remote` désactive la lecture distante (elle est désactivée par défaut pendant les tests unitaires), et `hop-ui.assets.url` change l'adresse. Il n'y a pas de fichier de configuration à publier ; définissez ces valeurs dans votre propre fichier de configuration nommé `hop-ui.php`.
- `scripts/sync-hop-assets.sh [path to a HEL.ink checkout]` met à jour la copie fournie depuis un checkout, ou depuis hel.ink si aucun chemin n'est donné.

### `Hop\Ui\Locales`

La liste unique des langues fournies par chaque application HOP : English `en`, 简体中文 `zh-CN`, Deutsch `de`, Bahasa Indonesia `id`, 日本語 `ja`, Português (Brasil) `pt-BR`, Español `es`, Français `fr` et Русский `ru`. Les langues qui s'écrivent de droite à gauche ne font pas partie de l'ensemble.

- `Locales::ALL` associe chaque code à son `name` natif et à une étiquette `short`. `codes()` et `names()` donnent les codes et les noms natifs, et `short($code)` l'étiquette.
- `Locales::resolve($value)` renvoie un code pris en charge ou `null`. La méthode convertit l'ancien `zh` en `zh-CN` et `pt` en `pt-BR`, sans tenir compte de la casse.
- `Locales::normalize($value)` est `resolve()` avec une valeur de repli : toute valeur vide, inconnue ou retirée, comme `ar`, devient `en`.

Le sélecteur de langue et la ligne de langues du pied de page sont générés à partir de cette liste.

## Tests

Les tests de `tests/Feature` sont des tests Pest qui s'exécutent dans une application utilisant le paquet (HEL.ink en inclut une copie dans `packages/ui`). La CI de ce dépôt vérifie que `composer.json` est valide, que chaque fichier PHP passe le lint sous PHP 8.3 et que le tableau de la famille ci-dessous correspond au tableau de référence.

## Sécurité

Signalez les vulnérabilités comme décrit dans [SECURITY.md](SECURITY.md), pas dans des issues publiques.

## Journal des modifications

Voir [CHANGELOG.md](CHANGELOG.md).

## Auto-hébergement

Vous n'installez pas ce paquet à la main pour faire tourner HOP. LinkHop et BioHop référencent ce dépôt public dans leur `composer.json` (épinglé sur un commit de `main`), donc `composer install` le récupère sans jeton, et le hub ([HEL.ink](https://github.com/navi-crwn/HEL.ink)) en contient une copie dans `packages/ui`. Sur votre propre domaine, gardez deux points en tête : les polices, les tuiles flottantes et les marques des applications se chargent toujours depuis `https://hel.ink/hop-assets/` (autorisez cet hôte dans votre Content Security Policy ; sans cela, les pages se rabattent sur les polices système et n'affichent aucune tuile), et la liste de la famille vient du manifeste de hel.ink, sauf si vous définissez `hop-ui.assets.url` ou désactivez la lecture distante avec `hop-ui.assets.remote` pour utiliser la copie fournie. Le guide de la famille couvre le reste : [docs/self-hosting.md](https://github.com/navi-crwn/HEL.ink/blob/main/docs/self-hosting.md).

## Famille HOP

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

## Licence

Les paquets partagés de HOP sont des logiciels open source distribués sous [licence MIT](LICENSE).
