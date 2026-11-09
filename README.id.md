# hop/ui

[English](README.md) · [简体中文](README.zh-CN.md) · [Deutsch](README.de.md) · **Bahasa Indonesia** · [日本語](README.ja.md) · [Português (Brasil)](README.pt-BR.md) · [Español](README.es.md) · [Français](README.fr.md) · [Русский](README.ru.md)

Komponen Blade dan data keluarga bersama untuk aplikasi Laravel dalam keluarga HOP ([hel.ink](https://hel.ink)): navigasi keluarga, menu bahasa, aplikasi, dan akun, footer, tipografi dan ubin melayang, serta satu daftar bahasa yang didukung. Setiap aplikasi yang memakainya tampil dan berperilaku sama di bagian-bagian itu.

## Tangkapan layar

Gambar ini diambil dari dasbor dan beranda BioHop, dijalankan secara lokal dengan akun demo, memakai paket ini di `main`.

![Sidebar BioHop dengan daftar keluarga HOP: HOP ID, LinkHop, PixelHop, dan NoteHop, masing-masing dengan tandanya. BioHop sendiri tidak tercantum.](docs/images/family-nav.png)

![Menu bahasa di bilah atas, terbuka: sembilan bahasa dengan nama asli di kiri dan kode singkat di kanan.](docs/images/language-switcher.png)

![Menu akun di bilah atas, terbuka: inisial, nama, dan email pengguna demo, lalu Account (HOP ID), Settings, dan Sign out.](docs/images/account-menu.png)

![Pengalih aplikasi di header situs, terbuka: HOP ID, LinkHop, BioHop, PixelHop, dan NoteHop, dengan BioHop ditandai sebagai aplikasi saat ini.](docs/images/app-switcher.png)

## Persyaratan

- PHP 8.3 dan Laravel 12 (`illuminate/support` ^12.0).
- `config/hop.php` bersama di aplikasi (lihat di bawah).
- Tailwind CSS di aplikasi. `pill`, `badge`, `nav-items`, `family-nav`, dan `footer` ditulis dengan kelas utilitas Tailwind (dan varian `dark:` untuk kelas `dark`), dan `nav-items` serta `family-nav` memakai kelas `nav-item` milik aplikasi, jadi build Tailwind aplikasi harus memindai view paket ini. Ketiga menu (`language-switcher`, `app-switcher`, `account-menu`) membawa CSS dan JavaScript sendiri. `family` dan `back` tidak punya gaya; aplikasi yang menata `hop-family-*` dan `hop-back`.
- Akses jaringan ke `hel.ink` dari browser. Font, ubin melayang, dan tanda aplikasi dimuat dari `https://hel.ink/hop-assets/` dengan hash subresource integrity, jadi Content Security Policy aplikasi harus mengizinkan host itu.

## Instalasi

Paket ini tidak ada di Packagist. Tambahkan repositorinya ke `composer.json` aplikasi:

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

Lalu jalankan:

```bash
composer update hop/ui
```

Tag terbaru, `v0.2.1`, belum berisi semua yang dijelaskan di sini. `family-nav`, `account-menu`, `app-switcher`, `language-switcher`, `footer`, dan daftar `Locales` ditambahkan setelahnya. Sampai tag berikutnya, gunakan `dev-main` di require (aplikasi-aplikasi mengunci satu commit dari `main`).

`Hop\Ui\UiServiceProvider` ditemukan secara otomatis. Kelas ini mendaftarkan view di bawah namespace `hop::` dan menyediakan komponen sebagai `<x-hop::name />`. Untuk menimpa view, publikasikan view tersebut:

```bash
php artisan vendor:publish --tag=hop-ui-views
```

## Yang disediakan aplikasi

Navigasi membaca daftar aplikasi dari `config/hop.php`:

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

Paket ini tidak membawa terjemahan. String yang dilewatkannya ke `__()` (seperti `HOP Family`, `Language`, `Account`, `Sign out`, `Settings`, `Changelog`) diterjemahkan oleh file bahasa milik aplikasi, dan beberapa string tetap dalam bahasa Inggris: `a HOP app` bawaan dari `badge`, `Back` dari `back`, serta judul dan intro bawaan dari `family`.

## Komponen

| Komponen | Props | Yang dirender |
| --- | --- | --- |
| `<x-hop::fonts />` | tidak ada | Di `<head>`: tipografi keluarga (Inter, Instrument Serif, dan JetBrains Mono) dari hel.ink. Gunakan `var(--hop-font-display)`, `var(--hop-font-body)`, `var(--hop-font-serif)`, dan `var(--hop-font-mono)`. |
| `<x-hop::float />` | `mode`: `fixed` (bawaan) atau `section` | Ubin HOP melayang, digambar oleh `hop-float.js` dari hel.ink. `section` mengisi kotak `position: relative`. |
| `<x-hop::ui />` | tidak ada | Sekali di layout, setelah font: `hop-ui.js` dan `hop-ui.css` dari hel.ink. `HopUI.alert`, `HopUI.confirm`, dan `HopUI.prompt` menggantikan dialog bawaan browser (Promise, utamakan keyboard, sembilan bahasa, tombol merah yang menyebut nama yang dihapus); kartu `[data-hop-remind]` mendapat tombol "Sembunyikan · Muncul lagi minggu depan" yang mengirim kuncinya ke `data-hop-remind-url`. |
| `<x-hop::family />` | `current`, `title`, `intro` | Bagian yang mencantumkan setiap aplikasi publik dengan tanda dan taglinenya. Aplikasi saat ini ditandai dan tidak ditautkan. |
| `<x-hop::back />` | `href` (bawaan: beranda aplikasi), `label` | Tautan kembali untuk halaman dalam. |
| `<x-hop::badge />` | slot | Pil kecil yang menaut ke hub. Isinya `a HOP app` kecuali Anda memberinya teks lain. |
| `<x-hop::pill />` | tidak ada | Sederet pil, satu untuk setiap aplikasi dari `config/hop.php` ditambah hub, dengan aplikasi saat ini terisi. |
| `<x-hop::nav-items />` | `except`: slug yang dilewati | Item daftar untuk aplikasi lain, untuk `<ul>` yang sudah ada. |
| `<x-hop::family-nav />` | `app`, `label` | Blok "HOP family" untuk sidebar dasbor: HOP ID lebih dulu, lalu aplikasi publik lainnya dengan tandanya. Aplikasi saat ini tidak ditampilkan. |
| `<x-hop::app-switcher />` | `app` | Dropdown berisi setiap aplikasi publik. Aplikasi saat ini memiliki `aria-current`. |
| `<x-hop::language-switcher />` | tidak ada | Dropdown berisi sembilan bahasa. Memilih salah satunya menambahkan `?lang=<code>` ke URL saat ini. |
| `<x-hop::account-menu />` | `user`, `settings-url`, `account-url`, `logout-url` | Dropdown berisi inisial, nama, dan email pengguna, serta tautan ke HOP ID, pengaturan, dan formulir keluar. Tautan atau formulir dihilangkan bila URL-nya tidak diberikan. |
| `<x-hop::footer />` | `app`, `name`, `repo`, `features-url`, `status-url`, `abuse-url`, `languages` | Footer berkolom: tautan aplikasi, dukungan, kebijakan, daftar keluarga HOP, dan baris bahasa. |

Tata letak dasbor yang dipakai keluarga ini menaruh aksi utama, menu bahasa, tombol tema, dan menu akun di bilah atas, dan `family-nav` di sidebar. Footer menaut ke `/about`, `/changelog`, `/help`, `/faq`, `/contact`, `/terms`, dan `/privacy` di domain aplikasi itu sendiri, jadi aplikasi harus melayani path tersebut.

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

Menu tertutup dengan Escape dan dengan klik di luar menu, dan tombol panah, Home, serta End berpindah di antara tautannya. Gaya dan skripnya dimuat sekali per halaman, berapa pun jumlah menunya, dan memakai nonce CSP dari `Vite::cspNonce()` bila aplikasi menetapkannya.

## Kelas PHP

### `Hop\Ui\Apps`

`Apps::all()` mengembalikan hub dan aplikasi yang aktif dari `config/hop.php` sebagai array dengan `slug`, `name`, `url`, `open`, `icon`, `color`, dan `current`. `open` adalah tujuan tautan: dari hub nilainya `{hub}/apps/{slug}`, dari aplikasi nilainya URL aplikasi ditambah path `start`-nya (bawaan `/auth/sso`). `Apps::icon($name)` mengembalikan path SVG sebuah ikon, dan memakai `globe` sebagai cadangan.

### `Hop\Ui\Assets`

Manifes aset keluarga mencantumkan font, ubin melayang, dan tanda setiap aplikasi, masing-masing dengan hash integritas.

- `Assets::manifest()` membaca `https://hel.ink/hop-assets/apps.json` dengan batas waktu 2 detik dan menyimpannya di cache selama 5 menit (kunci cache `hop-ui:assets`), sehingga versi aset baru sampai ke setiap aplikasi tanpa rilis. Bila hel.ink tidak bisa dijangkau, atau mengirim sesuatu yang tidak bisa dipakai, metode ini memakai salinan bawaan di `resources/hop-assets/apps.json`. Permintaan yang gagal dicatat sebagai peringatan.
- `Assets::family($current)` mengembalikan aplikasi publik dalam urutan keluarga dengan aplikasi saat ini ditandai. `Assets::asset($key)` mengembalikan URL dan hash integritas dari `fonts_css`, `float_css`, atau `float_js`.
- Konfigurasi: `hop-ui.assets.remote` mematikan pembacaan jarak jauh (secara bawaan mati selama unit test berjalan), dan `hop-ui.assets.url` mengubah alamatnya. Tidak ada file konfigurasi untuk dipublikasikan; atur nilai ini di file konfigurasi Anda sendiri bernama `hop-ui.php`.
- `scripts/sync-hop-assets.sh [path to a HEL.ink checkout]` memperbarui salinan bawaan dari sebuah checkout, atau dari hel.ink bila tidak ada path yang diberikan.

### `Hop\Ui\Locales`

Satu daftar bahasa yang dibawa setiap aplikasi HOP: English `en`, 简体中文 `zh-CN`, Deutsch `de`, Bahasa Indonesia `id`, 日本語 `ja`, Português (Brasil) `pt-BR`, Español `es`, Français `fr`, dan Русский `ru`. Bahasa yang ditulis dari kanan ke kiri tidak termasuk.

- `Locales::ALL` memetakan setiap kode ke `name` aslinya dan label `short`. `codes()` dan `names()` memberikan kode dan nama asli, dan `short($code)` memberikan labelnya.
- `Locales::resolve($value)` mengembalikan kode yang didukung atau `null`. Metode ini memetakan `zh` lama ke `zh-CN` dan `pt` ke `pt-BR`, dan tidak membedakan huruf besar dan kecil.
- `Locales::normalize($value)` adalah `resolve()` dengan cadangan: apa pun yang kosong, tidak dikenal, atau sudah dipensiunkan, seperti `ar`, menjadi `en`.

Pengalih bahasa dan baris bahasa di footer dibuat dari daftar ini.

## Pengujian

Tes di `tests/Feature` adalah tes Pest yang berjalan di dalam aplikasi yang memakai paket ini (HEL.ink menyertakan salinannya di `packages/ui`). CI repositori ini sendiri memeriksa bahwa `composer.json` valid, bahwa setiap file PHP lolos lint di PHP 8.3, dan bahwa tabel keluarga di bawah cocok dengan tabel kanonis.

## Keamanan

Laporkan kerentanan seperti dijelaskan di [SECURITY.md](SECURITY.md), bukan di issue publik.

## Catatan perubahan

Lihat [CHANGELOG.md](CHANGELOG.md).

## Hosting sendiri

Anda tidak perlu memasang paket ini secara manual untuk menjalankan HOP. LinkHop dan BioHop mencantumkan repositori publik ini di `composer.json` masing-masing (dikunci ke satu commit dari `main`), jadi `composer install` mengambilnya tanpa token, dan hub ([HEL.ink](https://github.com/navi-crwn/HEL.ink)) membawa salinannya di `packages/ui`. Di domain Anda sendiri, perhatikan dua hal: font, ubin melayang, dan tanda aplikasi tetap dimuat dari `https://hel.ink/hop-assets/` (izinkan host itu di Content Security Policy Anda; tanpa itu halaman kembali ke font sistem dan tidak menampilkan ubin), dan daftar keluarga diambil dari manifes hel.ink kecuali Anda mengatur `hop-ui.assets.url`, atau mematikan pembacaan jarak jauh dengan `hop-ui.assets.remote` untuk memakai salinan bawaan. Panduan keluarga membahas sisanya: [docs/self-hosting.md](https://github.com/navi-crwn/HEL.ink/blob/main/docs/self-hosting.md).

## Keluarga HOP

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

## Lisensi

Paket bersama HOP adalah perangkat lunak open source yang dilisensikan di bawah [lisensi MIT](LICENSE).
