# hop/ui

[English](README.md) · [简体中文](README.zh-CN.md) · [Deutsch](README.de.md) · [Bahasa Indonesia](README.id.md) · [日本語](README.ja.md) · **Português (Brasil)** · [Español](README.es.md) · [Français](README.fr.md) · [Русский](README.ru.md)

Os componentes Blade e os dados da família compartilhados pelos apps Laravel da família HOP ([hel.ink](https://hel.ink)): a navegação da família, os menus de idioma, de apps e de conta, o rodapé, a tipografia e os blocos flutuantes, e a lista única de idiomas suportados. Todo app que usa o pacote tem a mesma aparência e o mesmo comportamento nesses pontos.

## Capturas de tela

Elas vêm do painel e da página inicial do BioHop, executados localmente com uma conta de demonstração, usando este pacote em `main`.

![A barra lateral do BioHop com a lista da família HOP: HOP ID, LinkHop, PixelHop e NoteHop, cada um com sua marca. O próprio BioHop não aparece na lista.](docs/images/family-nav.png)

![O menu de idioma na barra superior, aberto: nove idiomas com o nome nativo à esquerda e um código curto à direita.](docs/images/language-switcher.png)

![O menu de conta na barra superior, aberto: a inicial, o nome e o e-mail do usuário de demonstração, seguidos de Account (HOP ID), Settings e Sign out.](docs/images/account-menu.png)

![O seletor de apps no cabeçalho do site, aberto: HOP ID, LinkHop, BioHop, PixelHop e NoteHop, com o BioHop marcado como o app atual.](docs/images/app-switcher.png)

## Requisitos

- PHP 8.3 e Laravel 12 (`illuminate/support` ^12.0).
- Um `config/hop.php` compartilhado no app (veja abaixo).
- Tailwind CSS no app. `pill`, `badge`, `nav-items`, `family-nav` e `footer` são escritos com classes utilitárias do Tailwind (e variantes `dark:` para a classe `dark`), e `nav-items` e `family-nav` usam a classe `nav-item` do próprio app, então o build do Tailwind do app precisa escanear as views deste pacote. Os três menus (`language-switcher`, `app-switcher`, `account-menu`) trazem seu próprio CSS e JavaScript. `family` e `back` não têm estilos; o app estiliza `hop-family-*` e `hop-back`.
- Acesso de rede a `hel.ink` no navegador. Fontes, blocos flutuantes e as marcas dos apps são carregados de `https://hel.ink/hop-assets/`, com hashes de subresource integrity, então a Content Security Policy do app precisa permitir esse host.

## Instalação

O pacote não está no Packagist. Adicione o repositório ao `composer.json` do app:

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

Depois execute:

```bash
composer update hop/ui
```

A tag mais recente, `v0.2.1`, não contém tudo o que está descrito aqui. `family-nav`, `account-menu`, `app-switcher`, `language-switcher`, `footer` e a lista `Locales` foram adicionados depois dela. Até a próxima tag, exija `dev-main` (os apps fixam um commit de `main`).

`Hop\Ui\UiServiceProvider` é descoberto automaticamente. Ele registra as views no namespace `hop::` e disponibiliza os componentes como `<x-hop::name />`. Para sobrescrever as views, publique-as:

```bash
php artisan vendor:publish --tag=hop-ui-views
```

## O que o app fornece

A navegação lê a lista de apps de `config/hop.php`:

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

O pacote não traz traduções. As strings que ele passa por `__()` (como `HOP Family`, `Language`, `Account`, `Sign out`, `Settings`, `Changelog`) são traduzidas pelos arquivos de idioma do próprio app, e algumas strings ficam em inglês simples: o `a HOP app` padrão de `badge`, o `Back` de `back`, e o título e a introdução padrão de `family`.

## Componentes

| Componente | Props | O que renderiza |
| --- | --- | --- |
| `<x-hop::fonts />` | nenhuma | No `<head>`: a tipografia da família (Inter, Instrument Serif e JetBrains Mono) a partir de hel.ink. Use `var(--hop-font-display)`, `var(--hop-font-body)`, `var(--hop-font-serif)` e `var(--hop-font-mono)`. |
| `<x-hop::float />` | `mode`: `fixed` (padrão) ou `section` | Os blocos flutuantes do HOP, desenhados pelo `hop-float.js` de hel.ink. `section` preenche uma caixa com `position: relative`. |
| `<x-hop::ui />` | nenhum | Uma vez no layout, depois das fontes: `hop-ui.js` e `hop-ui.css` do hel.ink. `HopUI.alert`, `HopUI.confirm` e `HopUI.prompt` substituem os diálogos do navegador (Promises, teclado primeiro, nove idiomas, um botão vermelho que nomeia o que é excluído); cartões `[data-hop-remind]` ganham um botão "Ocultar · Aparece de novo na próxima semana" que envia a chave para `data-hop-remind-url`. |
| `<x-hop::family />` | `current`, `title`, `intro` | Uma seção que lista cada app público com sua marca e seu slogan. O app atual fica marcado e sem link. |
| `<x-hop::back />` | `href` (padrão: a página inicial do app), `label` | Um link de voltar para páginas internas. |
| `<x-hop::badge />` | slot | Uma pequena pílula com link para o hub. Ela mostra `a HOP app`, a menos que você passe outro texto. |
| `<x-hop::pill />` | nenhuma | Uma fileira de pílulas, uma por app de `config/hop.php` mais o hub, com o app atual preenchido. |
| `<x-hop::nav-items />` | `except`: slugs a deixar de fora | Itens de lista para os outros apps, para um `<ul>` existente. |
| `<x-hop::family-nav />` | `app`, `label` | O bloco "HOP family" para a barra lateral de um painel: primeiro o HOP ID, depois os outros apps públicos com suas marcas. O app atual fica de fora. |
| `<x-hop::app-switcher />` | `app` | Um menu suspenso com todos os apps públicos. O atual tem `aria-current`. |
| `<x-hop::language-switcher />` | nenhuma | Um menu suspenso com os nove idiomas. Escolher um adiciona `?lang=<code>` à URL atual. |
| `<x-hop::account-menu />` | `user`, `settings-url`, `account-url`, `logout-url` | Um menu suspenso com a inicial, o nome e o e-mail da pessoa, e links para o HOP ID, para as configurações e para um formulário de saída. Um link ou o formulário fica de fora quando a URL dele não é informada. |
| `<x-hop::footer />` | `app`, `name`, `repo`, `features-url`, `status-url`, `abuse-url` | O rodapé em colunas: os links do app, suporte, políticas, e a lista da família HOP. |

O layout de painel usado pela família coloca a ação principal, o menu de idioma, o botão de tema e o menu de conta na barra superior, e `family-nav` na barra lateral. O rodapé aponta para `/about`, `/changelog`, `/help`, `/faq`, `/contact`, `/terms` e `/privacy` no próprio domínio do app, então o app precisa servir esses caminhos.

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

Os menus fecham com Escape e com um clique fora deles, e as teclas de seta, Home e End percorrem os links. Os estilos e o script entram uma vez por página, não importa quantos menus existam, e usam o nonce de CSP de `Vite::cspNonce()` quando o app define um.

## Classes PHP

### `Hop\Ui\Apps`

`Apps::all()` retorna o hub e os apps ativos de `config/hop.php` como arrays com `slug`, `name`, `url`, `open`, `icon`, `color` e `current`. `open` é o destino de um link: a partir do hub é `{hub}/apps/{slug}`, a partir de um app é a URL do app mais o seu caminho `start` (`/auth/sso` por padrão). `Apps::icon($name)` retorna o caminho SVG de um ícone e usa `globe` como alternativa.

### `Hop\Ui\Assets`

O manifesto de assets da família lista as fontes, os blocos flutuantes e as marcas de cada app, cada um com um hash de integridade.

- `Assets::manifest()` lê `https://hel.ink/hop-assets/apps.json` com um timeout de 2 segundos e guarda o resultado em cache por 5 minutos (chave de cache `hop-ui:assets`), assim uma nova versão dos assets chega a todos os apps sem um release. Se hel.ink não puder ser acessado, ou enviar algo inutilizável, o método usa a cópia incluída em `resources/hop-assets/apps.json`. Uma requisição com falha é registrada como aviso.
- `Assets::family($current)` retorna os apps públicos na ordem da família, com o atual marcado. `Assets::asset($key)` retorna a URL e o hash de integridade de `fonts_css`, `float_css` ou `float_js`.
- Configuração: `hop-ui.assets.remote` desliga a leitura remota (ela fica desligada por padrão durante os testes unitários), e `hop-ui.assets.url` muda o endereço. Não há arquivo de configuração para publicar; defina esses valores em um arquivo de configuração próprio chamado `hop-ui.php`.
- `scripts/sync-hop-assets.sh [path to a HEL.ink checkout]` atualiza a cópia incluída a partir de um checkout, ou de hel.ink quando nenhum caminho é informado.

### `Hop\Ui\Locales`

A lista única de idiomas que todo app HOP oferece: English `en`, 简体中文 `zh-CN`, Deutsch `de`, Bahasa Indonesia `id`, 日本語 `ja`, Português (Brasil) `pt-BR`, Español `es`, Français `fr` e Русский `ru`. Idiomas escritos da direita para a esquerda não fazem parte do conjunto.

- `Locales::ALL` associa cada código ao seu `name` nativo e a um rótulo `short`. `codes()` e `names()` retornam os códigos e os nomes nativos, e `short($code)` retorna o rótulo.
- `Locales::resolve($value)` retorna um código suportado ou `null`. O método converte o antigo `zh` em `zh-CN` e `pt` em `pt-BR`, e ignora maiúsculas e minúsculas.
- `Locales::normalize($value)` é `resolve()` com um valor de reserva: qualquer valor vazio, desconhecido ou descontinuado, como `ar`, vira `en`.

O seletor de idioma e a linha de idiomas do rodapé são gerados a partir desta lista.

## Testes

Os testes em `tests/Feature` são testes Pest que rodam dentro de um app que usa o pacote (o HEL.ink inclui uma cópia em `packages/ui`). A CI deste repositório verifica se o `composer.json` é válido, se todo arquivo PHP passa no lint do PHP 8.3 e se a tabela da família abaixo corresponde à tabela canônica.

## Segurança

Relate vulnerabilidades como descrito em [SECURITY.md](SECURITY.md), não em issues públicas.

## Registro de alterações

Veja [CHANGELOG.md](CHANGELOG.md).

## Hospedagem própria

Você não instala este pacote à mão para rodar o HOP. LinkHop e BioHop listam este repositório público no `composer.json` deles (fixado em um commit de `main`), então `composer install` o baixa sem token, e o hub ([HEL.ink](https://github.com/navi-crwn/HEL.ink)) traz uma cópia em `packages/ui`. No seu próprio domínio, lembre-se de duas coisas: as fontes, os blocos flutuantes e as marcas dos apps continuam sendo carregados de `https://hel.ink/hop-assets/` (permita esse host na sua Content Security Policy; sem isso, as páginas usam as fontes do sistema e não mostram blocos), e a lista da família vem do manifesto de hel.ink, a menos que você defina `hop-ui.assets.url` ou desligue a leitura remota com `hop-ui.assets.remote` para usar a cópia incluída. O guia da família cobre o resto: [docs/self-hosting.md](https://github.com/navi-crwn/HEL.ink/blob/main/docs/self-hosting.md).

## Família HOP

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

## Licença

Os pacotes compartilhados do HOP são software de código aberto licenciado sob a [licença MIT](LICENSE).
