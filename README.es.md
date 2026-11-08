# hop/ui

[English](README.md) · [简体中文](README.zh-CN.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [日本語](README.ja.md) · [Português (Brasil)](README.pt-BR.md) · **Español** · [Français](README.fr.md) · [Русский](README.ru.md)

Los componentes Blade y los datos de la familia que comparten las apps Laravel de la familia HOP ([hel.ink](https://hel.ink)): la navegación de la familia, los menús de idioma, de apps y de cuenta, el pie de página, la tipografía y los mosaicos flotantes, y la lista única de idiomas compatibles. Todas las apps que lo usan se ven y se comportan igual en esos puntos.

## Capturas de pantalla

Proceden del panel y de la página de inicio de BioHop, ejecutados en local con una cuenta de demostración, con este paquete en `main`.

![La barra lateral de BioHop con la lista de la familia HOP: HOP ID, LinkHop, PixelHop y NoteHop, cada una con su marca. BioHop no aparece en la lista.](docs/images/family-nav.png)

![El menú de idioma en la barra superior, abierto: nueve idiomas con el nombre nativo a la izquierda y un código corto a la derecha.](docs/images/language-switcher.png)

![El menú de cuenta en la barra superior, abierto: la inicial, el nombre y el correo del usuario de demostración, y después Account (HOP ID), Settings y Sign out.](docs/images/account-menu.png)

![El selector de apps en la cabecera del sitio, abierto: HOP ID, LinkHop, BioHop, PixelHop y NoteHop, con BioHop marcada como la app actual.](docs/images/app-switcher.png)

## Requisitos

- PHP 8.3 y Laravel 12 (`illuminate/support` ^12.0).
- Un `config/hop.php` compartido en la app (ver abajo).
- Tailwind CSS en la app. `pill`, `badge`, `nav-items`, `family-nav` y `footer` están escritos con clases utilitarias de Tailwind (y variantes `dark:` para la clase `dark`), y `nav-items` y `family-nav` usan la clase `nav-item` propia de la app, así que el build de Tailwind de la app tiene que escanear las vistas de este paquete. Los tres menús (`language-switcher`, `app-switcher`, `account-menu`) traen su propio CSS y JavaScript. `family` y `back` no tienen estilos; la app da estilo a `hop-family-*` y `hop-back`.
- Acceso de red a `hel.ink` desde el navegador. Las fuentes, los mosaicos flotantes y las marcas de las apps se cargan desde `https://hel.ink/hop-assets/`, con hashes de subresource integrity, así que la Content Security Policy de la app debe permitir ese host.

## Instalación

El paquete no está en Packagist. Añade el repositorio al `composer.json` de la app:

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

Después ejecuta:

```bash
composer update hop/ui
```

La última etiqueta, `v0.2.1`, no contiene todo lo que se describe aquí. `family-nav`, `account-menu`, `app-switcher`, `language-switcher`, `footer` y la lista `Locales` se añadieron después. Hasta la próxima etiqueta, requiere `dev-main` (las apps fijan un commit de `main`).

`Hop\Ui\UiServiceProvider` se descubre automáticamente. Registra las vistas en el espacio de nombres `hop::` y pone los componentes a disposición como `<x-hop::name />`. Para sobrescribir las vistas, publícalas:

```bash
php artisan vendor:publish --tag=hop-ui-views
```

## Lo que aporta la app

La navegación lee la lista de apps de `config/hop.php`:

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

El paquete no incluye traducciones. Las cadenas que pasa por `__()` (como `HOP Family`, `Language`, `Account`, `Sign out`, `Settings`, `Changelog`) las traducen los archivos de idioma de la propia app, y algunas cadenas están en inglés sin más: el `a HOP app` por defecto de `badge`, el `Back` de `back`, y el título y la introducción por defecto de `family`.

## Componentes

| Componente | Props | Qué renderiza |
| --- | --- | --- |
| `<x-hop::fonts />` | ninguna | En `<head>`: la tipografía de la familia (Inter, Instrument Serif y JetBrains Mono) desde hel.ink. Usa `var(--hop-font-display)`, `var(--hop-font-body)`, `var(--hop-font-serif)` y `var(--hop-font-mono)`. |
| `<x-hop::float />` | `mode`: `fixed` (por defecto) o `section` | Los mosaicos flotantes de HOP, dibujados por `hop-float.js` de hel.ink. `section` llena una caja con `position: relative`. |
| `<x-hop::family />` | `current`, `title`, `intro` | Una sección que lista cada app pública con su marca y su lema. La app actual aparece marcada y sin enlace. |
| `<x-hop::back />` | `href` (por defecto: la página de inicio de la app), `label` | Un enlace para volver en las páginas internas. |
| `<x-hop::badge />` | slot | Una pequeña píldora que enlaza al hub. Muestra `a HOP app` salvo que le des otro texto. |
| `<x-hop::pill />` | ninguna | Una fila de píldoras, una por cada app de `config/hop.php` más el hub, con la app actual rellena. |
| `<x-hop::nav-items />` | `except`: slugs que se omiten | Elementos de lista para las otras apps, para un `<ul>` existente. |
| `<x-hop::family-nav />` | `app`, `label` | El bloque "HOP family" para la barra lateral de un panel: primero HOP ID y luego las demás apps públicas con sus marcas. La app actual se omite. |
| `<x-hop::app-switcher />` | `app` | Un desplegable con todas las apps públicas. La actual tiene `aria-current`. |
| `<x-hop::language-switcher />` | ninguna | Un desplegable con los nueve idiomas. Al elegir uno se añade `?lang=<code>` a la URL actual. |
| `<x-hop::account-menu />` | `user`, `settings-url`, `account-url`, `logout-url` | Un desplegable con la inicial, el nombre y el correo de la persona, y enlaces a HOP ID, a los ajustes y a un formulario para cerrar sesión. Un enlace o el formulario se omite cuando no se da su URL. |
| `<x-hop::footer />` | `app`, `name`, `repo`, `features-url`, `status-url`, `abuse-url`, `languages` | El pie de página en columnas: los enlaces de la app, soporte, políticas, la lista de la familia HOP y una fila de idiomas. |

El diseño de panel que usa la familia pone la acción principal, el menú de idioma, el selector de tema y el menú de cuenta en la barra superior, y `family-nav` en la barra lateral. El pie de página enlaza a `/about`, `/changelog`, `/help`, `/faq`, `/contact`, `/terms` y `/privacy` en el propio dominio de la app, así que la app tiene que servir esas rutas.

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

Los menús se cierran con Escape y con un clic fuera, y las flechas, Inicio y Fin recorren sus enlaces. Sus estilos y su script se incluyen una vez por página, sin importar cuántos menús haya, y usan el nonce de CSP de `Vite::cspNonce()` cuando la app define uno.

## Clases PHP

### `Hop\Ui\Apps`

`Apps::all()` devuelve el hub y las apps activas de `config/hop.php` como arrays con `slug`, `name`, `url`, `open`, `icon`, `color` y `current`. `open` es el destino de un enlace: desde el hub es `{hub}/apps/{slug}`, desde una app es la URL de la app más su ruta `start` (`/auth/sso` por defecto). `Apps::icon($name)` devuelve la ruta SVG de un icono y, si no existe, usa `globe`.

### `Hop\Ui\Assets`

El manifiesto de recursos de la familia lista las fuentes, los mosaicos flotantes y las marcas de cada app, cada uno con un hash de integridad.

- `Assets::manifest()` lee `https://hel.ink/hop-assets/apps.json` con un tiempo de espera de 2 segundos y lo guarda en caché durante 5 minutos (clave de caché `hop-ui:assets`), así una nueva versión de los recursos llega a todas las apps sin publicar una versión. Si no se puede acceder a hel.ink, o envía algo inservible, usa la copia incluida en `resources/hop-assets/apps.json`. Una petición fallida se registra como advertencia.
- `Assets::family($current)` devuelve las apps públicas en el orden de la familia, con la actual marcada. `Assets::asset($key)` devuelve la URL y el hash de integridad de `fonts_css`, `float_css` o `float_js`.
- Configuración: `hop-ui.assets.remote` desactiva la lectura remota (está desactivada por defecto mientras se ejecutan las pruebas unitarias), y `hop-ui.assets.url` cambia la dirección. No hay archivo de configuración que publicar; define estos valores en un archivo de configuración propio llamado `hop-ui.php`.
- `scripts/sync-hop-assets.sh [path to a HEL.ink checkout]` actualiza la copia incluida desde un checkout, o desde hel.ink si no se indica ninguna ruta.

### `Hop\Ui\Locales`

La lista única de idiomas que incluye cada app HOP: English `en`, 简体中文 `zh-CN`, Deutsch `de`, Bahasa Indonesia `id`, 日本語 `ja`, Português (Brasil) `pt-BR`, Español `es`, Français `fr` y Русский `ru`. Los idiomas que se escriben de derecha a izquierda no forman parte del conjunto.

- `Locales::ALL` asocia cada código con su `name` nativo y una etiqueta `short`. `codes()` y `names()` devuelven los códigos y los nombres nativos, y `short($code)`, la etiqueta.
- `Locales::resolve($value)` devuelve un código compatible o `null`. Convierte el antiguo `zh` en `zh-CN` y `pt` en `pt-BR`, y no distingue mayúsculas de minúsculas.
- `Locales::normalize($value)` es `resolve()` con un valor de respaldo: cualquier valor vacío, desconocido o retirado, como `ar`, pasa a ser `en`.

El selector de idioma y la fila de idiomas del pie de página se generan a partir de esta lista.

## Pruebas

Las pruebas de `tests/Feature` son pruebas de Pest que se ejecutan dentro de una app que usa el paquete (HEL.ink incluye una copia en `packages/ui`). La CI de este repositorio comprueba que `composer.json` es válido, que cada archivo PHP pasa el lint con PHP 8.3 y que la tabla de la familia de abajo coincide con la canónica.

## Seguridad

Informa de las vulnerabilidades como se describe en [SECURITY.md](SECURITY.md), no en issues públicas.

## Registro de cambios

Consulta [CHANGELOG.md](CHANGELOG.md).

## Autoalojamiento

No necesitas instalar este paquete a mano para ejecutar HOP. LinkHop y BioHop incluyen este repositorio público en su `composer.json` (fijado a un commit de `main`), así que `composer install` lo descarga sin token, y el hub ([HEL.ink](https://github.com/navi-crwn/HEL.ink)) lleva una copia en `packages/ui`. En tu propio dominio, ten en cuenta dos cosas: las fuentes, los mosaicos flotantes y las marcas de las apps se siguen cargando desde `https://hel.ink/hop-assets/` (permite ese host en tu Content Security Policy; sin él, las páginas usan las fuentes del sistema y no muestran mosaicos), y la lista de la familia viene del manifiesto de hel.ink, salvo que definas `hop-ui.assets.url` o desactives la lectura remota con `hop-ui.assets.remote` para usar la copia incluida. La guía de la familia cubre el resto: [docs/self-hosting.md](https://github.com/navi-crwn/HEL.ink/blob/main/docs/self-hosting.md).

## Familia HOP

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

## Licencia

Los paquetes compartidos de HOP son software de código abierto con [licencia MIT](LICENSE).
