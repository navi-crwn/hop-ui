# hop/ui

[English](README.md) · **简体中文** · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [日本語](README.ja.md) · [Português (Brasil)](README.pt-BR.md) · [Español](README.es.md) · [Français](README.fr.md) · [Русский](README.ru.md)

HOP 家族（[hel.ink](https://hel.ink)）各 Laravel 应用共用的 Blade 组件和家族数据：家族导航、语言菜单、应用菜单和账户菜单、页脚、字体排版和浮动方块，以及唯一的一份受支持语言列表。使用它的每个应用在这些地方的外观和行为都相同。

## 截图

截图来自 BioHop 的仪表板和首页，在本地用演示账户运行，使用本包的 `main`。

![BioHop 侧边栏中的 HOP 家族列表：HOP ID、LinkHop、PixelHop 和 NoteHop，各自带有标志。BioHop 本身不在列表中。](docs/images/family-nav.png)

![顶栏中已展开的语言菜单：九种语言，左侧是本地名称，右侧是简短代码。](docs/images/language-switcher.png)

![顶栏中已展开的账户菜单：演示用户的首字母、姓名和邮箱，下面是 Account (HOP ID)、Settings 和 Sign out。](docs/images/account-menu.png)

![站点页眉中已展开的应用切换器：HOP ID、LinkHop、BioHop、PixelHop 和 NoteHop，BioHop 被标记为当前应用。](docs/images/app-switcher.png)

## 要求

- PHP 8.3 和 Laravel 12（`illuminate/support` ^12.0）。
- 应用中有一个共享的 `config/hop.php`（见下文）。
- 应用中使用 Tailwind CSS。`pill`、`badge`、`nav-items`、`family-nav` 和 `footer` 用 Tailwind 工具类编写（并为 `dark` 类使用 `dark:` 变体），`nav-items` 和 `family-nav` 还使用应用自己的 `nav-item` 类，因此应用的 Tailwind 构建必须扫描本包的视图。三个菜单（`language-switcher`、`app-switcher`、`account-menu`）自带 CSS 和 JavaScript。`family` 和 `back` 没有样式；`hop-family-*` 和 `hop-back` 的样式由应用提供。
- 浏览器能通过网络访问 `hel.ink`。字体、浮动方块和应用标志从 `https://hel.ink/hop-assets/` 加载，并带有子资源完整性哈希，因此应用的 Content Security Policy 必须允许该主机。

## 安装

本包不在 Packagist 上。请把仓库添加到应用的 `composer.json`：

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

然后运行：

```bash
composer update hop/ui
```

最新的标签 `v0.2.1` 并不包含这里描述的全部内容。`family-nav`、`account-menu`、`app-switcher`、`language-switcher`、`footer` 和 `Locales` 列表是在它之后加入的。在下一个标签发布之前，请 require `dev-main`（各应用固定在 `main` 的某个提交上）。

`Hop\Ui\UiServiceProvider` 会被自动发现。它在 `hop::` 命名空间下注册视图，并以 `<x-hop::name />` 的形式提供组件。要覆盖视图，请发布它们：

```bash
php artisan vendor:publish --tag=hop-ui-views
```

## 应用需要提供的内容

导航从 `config/hop.php` 读取应用列表：

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

本包不附带翻译。它通过 `__()` 传递的字符串（例如 `HOP Family`、`Language`、`Account`、`Sign out`、`Settings`、`Changelog`）由应用自己的语言文件翻译。另有几个字符串是纯英文：`badge` 的默认文字 `a HOP app`、`back` 的 `Back`，以及 `family` 的默认标题和简介。

## 组件

| 组件 | 属性 | 渲染内容 |
| --- | --- | --- |
| `<x-hop::fonts />` | 无 | 放在 `<head>` 中：从 hel.ink 加载家族字体（Inter、Instrument Serif 和 JetBrains Mono）。使用 `var(--hop-font-display)`、`var(--hop-font-body)`、`var(--hop-font-serif)` 和 `var(--hop-font-mono)`。 |
| `<x-hop::float />` | `mode`：`fixed`（默认）或 `section` | 浮动的 HOP 方块，由 hel.ink 的 `hop-float.js` 绘制。`section` 会填满一个 `position: relative` 的容器。 |
| `<x-hop::ui />` | 无 | 在布局中放一次，位于字体之后：hel.ink 的 `hop-ui.js` 与 `hop-ui.css`。`HopUI.alert`、`HopUI.confirm`、`HopUI.prompt` 取代浏览器自带的对话框（Promise、键盘优先、九种语言、红色按钮会写明要删除的对象）；`[data-hop-remind]` 卡片会得到“隐藏 · 下周再次显示”按钮，把键发送到 `data-hop-remind-url`。 |
| `<x-hop::family />` | `current`、`title`、`intro` | 一个区块，列出每个公开应用及其标志和标语。当前应用会被标记，且不带链接。 |
| `<x-hop::back />` | `href`（默认：应用首页）、`label` | 内页使用的返回链接。 |
| `<x-hop::badge />` | 插槽 | 一个链接到 hub 的小胶囊。除非你提供其他文字，否则显示 `a HOP app`。 |
| `<x-hop::pill />` | 无 | 一排胶囊，`config/hop.php` 中的每个应用一个，外加 hub，当前应用为填充样式。 |
| `<x-hop::nav-items />` | `except`：要排除的 slug | 其他应用的列表项，放入已有的 `<ul>` 中。 |
| `<x-hop::family-nav />` | `app`、`label` | 仪表板侧边栏中的 “HOP family” 区块：先是 HOP ID，然后是其他公开应用及其标志。当前应用不显示。 |
| `<x-hop::app-switcher />` | `app` | 包含每个公开应用的下拉菜单。当前应用带有 `aria-current`。 |
| `<x-hop::language-switcher />` | 无 | 包含九种语言的下拉菜单。选择一种语言会在当前 URL 上添加 `?lang=<code>`。 |
| `<x-hop::account-menu />` | `user`、`settings-url`、`account-url`、`logout-url` | 显示用户首字母、姓名和邮箱的下拉菜单，并带有 HOP ID 链接、设置链接和退出登录表单。未提供对应 URL 时，该链接或表单会被省略。 |
| `<x-hop::footer />` | `app`、`name`、`repo`、`features-url`、`status-url`、`abuse-url` | 分栏页脚：应用的链接、支持、政策和 HOP 家族列表。 |

家族使用的仪表板布局把主要操作、语言菜单、主题切换和账户菜单放在顶栏，把 `family-nav` 放在侧边栏。页脚链接到应用自己域名下的 `/about`、`/changelog`、`/help`、`/faq`、`/contact`、`/terms` 和 `/privacy`，因此应用必须提供这些路径。

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

按 Escape 或点击菜单外部时菜单会关闭，方向键、Home 键和 End 键可在其链接之间移动。无论页面上有多少个菜单，它们的样式和脚本每页只引入一次；如果应用设置了 CSP nonce，会使用 `Vite::cspNonce()` 提供的值。

## PHP 类

### `Hop\Ui\Apps`

`Apps::all()` 以数组形式返回 hub 和 `config/hop.php` 中已启用的应用，数组包含 `slug`、`name`、`url`、`open`、`icon`、`color` 和 `current`。`open` 是链接应指向的地址：在 hub 中为 `{hub}/apps/{slug}`，在应用中为应用的 URL 加上其 `start` 路径（默认 `/auth/sso`）。`Apps::icon($name)` 返回图标的 SVG 路径，找不到时回退到 `globe`。

### `Hop\Ui\Assets`

家族资源清单列出字体、浮动方块和每个应用的标志，每一项都带有完整性哈希。

- `Assets::manifest()` 以 2 秒超时读取 `https://hel.ink/hop-assets/apps.json`，并缓存 5 分钟（缓存键 `hop-ui:assets`），因此新的资源版本无需发布新版本就能到达每个应用。如果无法访问 hel.ink，或返回的内容不可用，则使用 `resources/hop-assets/apps.json` 中附带的副本。请求失败会记录为警告。
- `Assets::family($current)` 按家族顺序返回公开应用，并标记当前应用。`Assets::asset($key)` 返回 `fonts_css`、`float_css` 或 `float_js` 的 URL 和完整性哈希。
- 配置：`hop-ui.assets.remote` 用于关闭远程读取（运行单元测试时默认关闭），`hop-ui.assets.url` 用于更改地址。本包没有可发布的配置文件；请在你自己的名为 `hop-ui.php` 的配置文件中设置这些项。
- `scripts/sync-hop-assets.sh [path to a HEL.ink checkout]` 从一个检出副本刷新附带的副本；未给出路径时从 hel.ink 刷新。

### `Hop\Ui\Locales`

每个 HOP 应用都提供的唯一一份语言列表：English `en`、简体中文 `zh-CN`、Deutsch `de`、Bahasa Indonesia `id`、日本語 `ja`、Português (Brasil) `pt-BR`、Español `es`、Français `fr` 和 Русский `ru`。从右到左书写的语言不在其中。

- `Locales::ALL` 把每个代码映射到其本地名称 `name` 和一个 `short` 标签。`codes()` 和 `names()` 返回代码和本地名称，`short($code)` 返回标签。
- `Locales::resolve($value)` 返回一个受支持的代码或 `null`。它把旧的 `zh` 映射为 `zh-CN`，把 `pt` 映射为 `pt-BR`，且不区分大小写。
- `Locales::normalize($value)` 是带回退的 `resolve()`：任何为空、未知或已停用的值（例如 `ar`）都会变成 `en`。

语言切换器和页脚中的语言行都根据此列表生成。

## 测试

`tests/Feature` 中的测试是 Pest 测试，在使用本包的应用中运行（HEL.ink 在 `packages/ui` 中包含一份副本）。本仓库自己的 CI 会检查 `composer.json` 是否有效、每个 PHP 文件能否在 PHP 8.3 下通过 lint，以及下面的家族表格是否与标准表格一致。

## 安全

请按照 [SECURITY.md](SECURITY.md) 中的说明报告漏洞，不要在公开 issue 中报告。

## 更新日志

参见 [CHANGELOG.md](CHANGELOG.md)。

## 自行托管

运行 HOP 不需要手动安装本包。LinkHop 和 BioHop 在各自的 `composer.json` 中列出了这个公开仓库（固定在 `main` 的某个提交上），因此 `composer install` 无需令牌即可获取它；hub（[HEL.ink](https://github.com/navi-crwn/HEL.ink)）在 `packages/ui` 中带有一份副本。在你自己的域名上，请注意两点：字体、浮动方块和应用标志仍从 `https://hel.ink/hop-assets/` 加载（请在 Content Security Policy 中允许该主机；否则页面会回退到系统字体，也不会显示方块）；家族列表来自 hel.ink 的清单，除非你设置 `hop-ui.assets.url`，或用 `hop-ui.assets.remote` 关闭远程读取以使用附带的副本。其余内容见家族指南：[docs/self-hosting.md](https://github.com/navi-crwn/HEL.ink/blob/main/docs/self-hosting.md)。

## HOP 家族

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

## 许可证

HOP 共享包是开源软件，采用 [MIT 许可证](LICENSE)授权。
