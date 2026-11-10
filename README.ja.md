# hop/ui

[English](README.md) · [简体中文](README.zh-CN.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · **日本語** · [Português (Brasil)](README.pt-BR.md) · [Español](README.es.md) · [Français](README.fr.md) · [Русский](README.ru.md)

HOP ファミリー（[hel.ink](https://hel.ink)）の Laravel アプリで共有する Blade コンポーネントとファミリーデータです。ファミリーナビゲーション、言語・アプリ・アカウントの各メニュー、フッター、タイポグラフィとフローティングタイル、そして対応言語の唯一のリストを含みます。これを使うアプリは、これらの部分で同じ見た目と同じ動作になります。

## スクリーンショット

BioHop のダッシュボードとホームページで撮影したものです。デモアカウントでローカル実行し、このパッケージの `main` を使っています。

![BioHop のサイドバーにある HOP ファミリーのリスト：HOP ID、LinkHop、PixelHop、NoteHop と、それぞれのマーク。BioHop 自身は表示されていません。](docs/images/family-nav.png)

![トップバーの言語メニューを開いた状態：9 つの言語が、左にネイティブ名、右に短いコードで並んでいます。](docs/images/language-switcher.png)

![トップバーのアカウントメニューを開いた状態：デモユーザーのイニシャル、名前、メールアドレス、その下に Account (HOP ID)、Settings、Sign out。](docs/images/account-menu.png)

![サイトヘッダーのアプリスイッチャーを開いた状態：HOP ID、LinkHop、BioHop、PixelHop、NoteHop。BioHop が現在のアプリとして示されています。](docs/images/app-switcher.png)

## 要件

- PHP 8.3 と Laravel 12（`illuminate/support` ^12.0）。
- アプリ内の共有 `config/hop.php`（後述）。
- アプリでの Tailwind CSS。`pill`、`badge`、`nav-items`、`family-nav`、`footer` は Tailwind のユーティリティクラス（および `dark` クラス用の `dark:` バリアント）で書かれており、`nav-items` と `family-nav` はアプリ独自の `nav-item` クラスを使います。そのため、アプリの Tailwind ビルドでこのパッケージのビューをスキャン対象にする必要があります。3 つのメニュー（`language-switcher`、`app-switcher`、`account-menu`）は独自の CSS と JavaScript を持っています。`family` と `back` にはスタイルがなく、`hop-family-*` と `hop-back` のスタイルはアプリが定義します。
- ブラウザから `hel.ink` へのネットワークアクセス。フォント、フローティングタイル、アプリのマークは `https://hel.ink/hop-assets/` からサブリソース完全性ハッシュ付きで読み込まれます。そのため、アプリの Content Security Policy でそのホストを許可する必要があります。

## インストール

このパッケージは Packagist にはありません。アプリの `composer.json` にリポジトリを追加します。

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

次に実行します。

```bash
composer update hop/ui
```

最新のタグ `v0.2.1` には、ここで説明している内容がすべて含まれているわけではありません。`family-nav`、`account-menu`、`app-switcher`、`language-switcher`、`footer` と `Locales` リストはその後に追加されました。次のタグが出るまでは `dev-main` を require してください（各アプリは `main` の特定のコミットに固定しています）。

`Hop\Ui\UiServiceProvider` は自動で検出されます。ビューを `hop::` 名前空間に登録し、コンポーネントを `<x-hop::name />` として使えるようにします。ビューを上書きするには、ビューを公開します。

```bash
php artisan vendor:publish --tag=hop-ui-views
```

## アプリが用意するもの

ナビゲーションはアプリの一覧を `config/hop.php` から読み込みます。

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

このパッケージには翻訳が含まれていません。`__()` を通す文字列（`HOP Family`、`Language`、`Account`、`Sign out`、`Settings`、`Changelog` など）は、アプリ自身の言語ファイルで翻訳されます。いくつかの文字列は英語のままです：`badge` の既定値 `a HOP app`、`back` の `Back`、`family` の既定のタイトルと紹介文。

## コンポーネント

| コンポーネント | プロパティ | 描画する内容 |
| --- | --- | --- |
| `<x-hop::fonts />` | なし | `<head>` 内に置きます。hel.ink からファミリーのタイポグラフィ（Inter、Instrument Serif、JetBrains Mono）を読み込みます。`var(--hop-font-display)`、`var(--hop-font-body)`、`var(--hop-font-serif)`、`var(--hop-font-mono)` を使います。 |
| `<x-hop::float />` | `mode`：`fixed`（既定）または `section` | hel.ink の `hop-float.js` が描くフローティング HOP タイル。`section` は `position: relative` のボックスを埋めます。 |
| `<x-hop::ui />` | なし | レイアウトにフォントの後で一度だけ: hel.ink の `hop-ui.js` と `hop-ui.css`。`HopUI.alert`、`HopUI.confirm`、`HopUI.prompt` がブラウザ標準のダイアログに代わります（Promise、キーボード優先、9 言語、削除対象の名前を示す赤いボタン）。`[data-hop-remind]` のカードには「非表示 · 来週また表示されます」ボタンが付き、キーを `data-hop-remind-url` に送ります。 |
| `<x-hop::family />` | `current`、`title`、`intro` | 公開されているすべてのアプリを、マークとキャッチコピー付きで並べるセクション。現在のアプリには印が付き、リンクはありません。 |
| `<x-hop::back />` | `href`（既定：アプリのホーム）、`label` | 下層ページ用の戻るリンク。 |
| `<x-hop::badge />` | スロット | ハブへリンクする小さなピル。別のテキストを渡さない限り `a HOP app` と表示します。 |
| `<x-hop::pill />` | なし | ピルの列。`config/hop.php` の各アプリとハブに 1 つずつ並び、現在のアプリは塗りつぶされます。 |
| `<x-hop::nav-items />` | `except`：除外するスラッグ | 既存の `<ul>` に入れる、他のアプリのリスト項目。 |
| `<x-hop::family-nav />` | `app`、`label` | ダッシュボードのサイドバー用の「HOP family」ブロック。最初に HOP ID、続いて他の公開アプリをマーク付きで表示します。現在のアプリは含まれません。 |
| `<x-hop::app-switcher />` | `app` | 公開されているすべてのアプリのドロップダウン。現在のアプリには `aria-current` が付きます。 |
| `<x-hop::language-switcher />` | なし | 9 つの言語のドロップダウン。言語を選ぶと、現在の URL に `?lang=<code>` を追加します。 |
| `<x-hop::account-menu />` | `user`、`settings-url`、`account-url`、`logout-url` | 利用者のイニシャル、名前、メールアドレスと、HOP ID・設定へのリンク、サインアウト用フォームを表示するドロップダウン。URL が渡されていないリンクやフォームは表示されません。 |
| `<x-hop::footer />` | `app`、`name`、`repo`、`features-url`、`status-url`、`abuse-url` | 段組みのフッター：アプリのリンク、サポート、ポリシー、HOP ファミリーのリスト。 |

ファミリーで使うダッシュボードのレイアウトでは、主要アクション、言語メニュー、テーマ切り替え、アカウントメニューをトップバーに、`family-nav` をサイドバーに置きます。フッターはアプリ自身のドメインの `/about`、`/changelog`、`/help`、`/faq`、`/contact`、`/terms`、`/privacy` にリンクするため、アプリはこれらのパスを提供する必要があります。

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

メニューは Escape キーまたは外側のクリックで閉じ、矢印キー、Home キー、End キーでリンク間を移動できます。スタイルとスクリプトは、メニューの数にかかわらずページごとに 1 回だけ読み込まれます。アプリが CSP nonce を設定している場合は `Vite::cspNonce()` の値を使います。

## PHP クラス

### `Hop\Ui\Apps`

`Apps::all()` は、ハブと `config/hop.php` で有効になっているアプリを、`slug`、`name`、`url`、`open`、`icon`、`color`、`current` を持つ配列として返します。`open` はリンク先です。ハブからは `{hub}/apps/{slug}`、アプリからはそのアプリの URL に `start` パス（既定は `/auth/sso`）を付けたものになります。`Apps::icon($name)` はアイコンの SVG パスを返し、見つからなければ `globe` を使います。

### `Hop\Ui\Assets`

ファミリーのアセットマニフェストには、フォント、フローティングタイル、各アプリのマークが、それぞれ完全性ハッシュ付きで載っています。

- `Assets::manifest()` は `https://hel.ink/hop-assets/apps.json` を 2 秒のタイムアウトで読み込み、5 分間キャッシュします（キャッシュキー `hop-ui:assets`）。そのため、新しいアセットのバージョンはリリースなしですべてのアプリに届きます。hel.ink に接続できない場合や、使えない内容が返された場合は、`resources/hop-assets/apps.json` に同梱されたコピーを使います。失敗したリクエストは警告としてログに記録されます。
- `Assets::family($current)` は公開アプリをファミリーの順に返し、現在のアプリに印を付けます。`Assets::asset($key)` は `fonts_css`、`float_css`、`float_js` の URL と完全性ハッシュを返します。
- 設定：`hop-ui.assets.remote` でリモート読み込みをオフにでき（ユニットテスト実行中は既定でオフ）、`hop-ui.assets.url` でアドレスを変更できます。公開する設定ファイルはありません。`hop-ui.php` という名前の独自の設定ファイルでこれらを設定してください。
- `scripts/sync-hop-assets.sh [path to a HEL.ink checkout]` は、チェックアウトから同梱コピーを更新します。パスを指定しない場合は hel.ink から更新します。

### `Hop\Ui\Locales`

すべての HOP アプリが提供する唯一の言語リストです：English `en`、简体中文 `zh-CN`、Deutsch `de`、Bahasa Indonesia `id`、日本語 `ja`、Português (Brasil) `pt-BR`、Español `es`、Français `fr`、Русский `ru`。右から左に書く言語は含まれません。

- `Locales::ALL` は、各コードをネイティブの `name` と `short` ラベルに対応付けます。`codes()` と `names()` はコードとネイティブ名を、`short($code)` はラベルを返します。
- `Locales::resolve($value)` は対応しているコードか `null` を返します。古い `zh` を `zh-CN` に、`pt` を `pt-BR` に対応付け、大文字と小文字を区別しません。
- `Locales::normalize($value)` はフォールバック付きの `resolve()` です。空、不明、または廃止された値（`ar` など）は `en` になります。

言語スイッチャーとフッターの言語の行は、このリストから作られます。

## テスト

`tests/Feature` のテストは Pest のテストで、このパッケージを使うアプリの中で実行します（HEL.ink は `packages/ui` にコピーを持っています）。このリポジトリ自身の CI は、`composer.json` が有効であること、すべての PHP ファイルが PHP 8.3 で lint を通ること、下のファミリー表が正規の表と一致することを確認します。

## セキュリティ

脆弱性は公開の issue ではなく、[SECURITY.md](SECURITY.md) の手順に従って報告してください。

## 変更履歴

[CHANGELOG.md](CHANGELOG.md) を参照してください。

## セルフホスティング

HOP を動かすために、このパッケージを手動でインストールする必要はありません。LinkHop と BioHop はこの公開リポジトリを `composer.json` に記載しているため（`main` の特定のコミットに固定）、`composer install` がトークンなしで取得します。ハブ（[HEL.ink](https://github.com/navi-crwn/HEL.ink)）は `packages/ui` にコピーを持っています。独自ドメインでは 2 点に注意してください。フォント、フローティングタイル、アプリのマークは引き続き `https://hel.ink/hop-assets/` から読み込まれます（Content Security Policy でそのホストを許可してください。許可しないと、ページはシステムフォントで表示され、タイルは出ません）。また、ファミリーのリストは hel.ink のマニフェストから取得されます。変えるには `hop-ui.assets.url` を設定するか、`hop-ui.assets.remote` でリモート読み込みをオフにして同梱コピーを使います。その他はファミリーのガイドを参照してください：[docs/self-hosting.md](https://github.com/navi-crwn/HEL.ink/blob/main/docs/self-hosting.md)。

## HOP ファミリー

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

## ライセンス

HOP の共有パッケージは、[MIT ライセンス](LICENSE)で提供されるオープンソースソフトウェアです。
