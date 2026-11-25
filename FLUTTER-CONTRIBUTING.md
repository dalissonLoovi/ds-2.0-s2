# Flutter contributing — loovi_tokens + loovi_ds

Saída Flutter do DS S2 para o **App Cliente**. Mode default: `app-cliente`.

## Versão

| Item | Versão |
| --- | --- |
| Flutter | **3.50.1 stable** (Dart 3.14.0) — fixado nos `pubspec.yaml` (`flutter: ">=3.50.1"`) |
| Material | `material_ui` ^1.11 (o Material saiu do SDK no 3.47+; `package:flutter/material.dart` está deprecated) |
| Widgetbook | 3.25 (catálogo) |

Instalação: SDK oficial (zip) + `flutter config --no-analytics`.

## Layout

```text
packages/flutter_tokens/     # loovi_tokens — GERADO do seed (ThemeExtension + Poppins TTF)
  tool/generate_tokens.mjs   #   seed → lib/src/generated/loovi_tokens.g.dart + RESOLVED-APP-CLIENTE.md
packages/flutter_ds/         # loovi_ds — widgets (pintura do mode app-cliente)
  tool/extract_icons.mjs     #   exports SVG dos aliases Hugeicons → assets/icons/app-cliente
  tool/generate_catalog.mjs  #   seed → LooviSeedCatalog (nodeId, descrição) + FLUTTER-INVENTORY.md
packages/flutter_widgetbook/ # catálogo Flutter (Widgetbook, web), viewport 390
```

O npm ignora essas pastas (sem `package.json`); os workspaces `@ds/*` não mudam.

## Gerar

```bash
npm run flutter:tokens     # seed → loovi_tokens (falha se um alias do app-cliente não fechar)
npm run flutter:catalog    # seed → LooviSeedCatalog + FLUTTER-INVENTORY.md
```

Por que o gerador lê o **seed** e não `packages/tokens/dist/tokens.json`: o `tokens.json` é lista plana, sem modes e sem `component/*`. As 23 variáveis do `product-theme` existem só em `meta.productTheme.tokens[].aliasByMode`. O gerador resolve cada alias até o primitivo **no mesmo mode** (inclusive alias → outro token de componente) e confere com `tokens.component` quando existe: divergência no `app-cliente` trava; nos outros modes o alias ganha e vira aviso.

Ícones: o slot é `LooviIcon(LooviIcons.xxx)` com nome do contrato (`*-outline` / `*-filled`). Para adicionar um ícone: exportar o componente de alias (Figma `4LsFOmHu3B25vXsDPjklWs`, seção `7003:12884`) em SVG 24×24 com o nome DS, registrar o node em `tool/icon_alias_nodes.json` e rodar `node packages/flutter_ds/tool/extract_icons.mjs <pasta>`. O nome nativo Hugeicons nunca entra no código.

## Testar

```bash
cd packages/flutter_tokens && flutter test          # resolução dos tokens críticos
cd packages/flutter_ds && flutter test              # widget tests + goldens
cd packages/flutter_ds && flutter test --update-goldens   # só quando a mudança visual for intencional
```

Goldens: `textScaler` travado em 1.0 e Poppins carregada (`setUpAll(loadGoldenFonts)`), largura 390, DPR 1. Gerados no Windows — renderização de fonte varia por SO; regenere na mesma plataforma. O app em produção **não** trava o `textScaler`.

## Widgetbook

Publicado em https://dalissonloovi.github.io/ds-2.0-s2/flutter/ — o workflow `.github/workflows/storybook.yml` (job `widgetbook`) gera a build web a cada push em `main` e a coloca em `/flutter/` junto do Storybook.

```bash
cd packages/flutter_widgetbook
flutter run -d chrome          # ou: flutter build web && servir build/web
```

## Consumir em um app

Guia completo (instalação, tema, o que o app fornece): [`packages/flutter_ds/README.md`](./packages/flutter_ds/README.md).

```yaml
dependencies:
  material_ui: ^1.11.1
  loovi_ds:
    git:
      url: https://github.com/dalissonLoovi/ds-2.0-s2
      path: packages/flutter_ds
      ref: flutter-v0.1.3   # tag de versão; não usar main em produção
```

```dart
import 'package:loovi_ds/loovi_ds.dart'; // reexporta loovi_tokens

MaterialApp(theme: LooviTheme.light(), home: ...);
final t = LooviTokens.of(context);
Padding(padding: EdgeInsets.all(t.spacing.s200), child: LooviButton(label: 'Continuar', onPressed: ...));
```

Dependência por caminho (`path: ../ds/packages/flutter_ds`) só serve para desenvolvimento local com as duas pastas lado a lado. O pacote não depende de Riverpod, Bloc nem go_router.

### Versionar (lançar uma versão)

1. Suíte verde (`flutter analyze` + `flutter test` em `packages/flutter_ds` e `packages/flutter_tokens`).
2. Subir `version` nos dois `pubspec.yaml` e adicionar a linha na tabela "Versões" do README do `loovi_ds`.
3. Commit em `main`, depois `git tag flutter-vX.Y.Z` e `git push origin flutter-vX.Y.Z`.
4. Avisar o time do app para trocar o `ref`.

## Regras para widgets (Definition of Done)

1. **Fonte:** Figma (mode `app-cliente`) → seed (props, variants, nodeId, accessibility, `productTheme`) → React só para comportamento. **Não portar o CSS** de `packages/react` (é visual Escritório Virtual).
2. **Pintura só por token:** `LooviTokens.of(context)` — `t.color.*`, `t.text.*`, `t.spacing.*`, `t.radius.*`, `t.typography.*`, `t.component.*` (product-theme). Nenhum `Color(0x…)`, hex, espaço, raio ou tamanho escrito à mão em widget. Valor do frame sem variável no Figma → usar o token de mesmo valor e reportar ("frame não tokenizado").
3. **Diferença frame × token:** o token ganha; reportar o frame, não "consertar" o Figma.
4. **API:** classe `Loovi<Nome>`; enums `Loovi<Nome><Prop>` com os valores do seed (camelCase). `state` do seed vira estado de interação em runtime (pressed/focus via `WidgetStatesController`/`FocusableActionDetector`); `selected`, `disabled`, `loading` são props quando o seed os tem. **Sem hover** no app (mobile).
5. **Texto:** estilos `t.typography.*`; respeitar o `textScaler` do sistema (nunca travar no widget).
6. **Acessibilidade:** `Semantics` com o nome do seed/label; contraste AA; alvo de toque ≥ 48 dp — se o Figma for menor, a pintura fica no tamanho do Figma e a área cresce por fora (`LooviTapTarget`).
7. **Ícones:** só `LooviIcon(LooviIcons.…)`.
7a. **Material:** importar `package:material_ui/material_ui.dart`, **nunca** `package:flutter/material.dart` (deprecated, saiu do SDK).
7b. **Cor de status (seed `meta.governance.feedbackColorRule`):** TEXTO de status (label, mensagem de erro/validação, rótulo de Button outline/text) e ícone de status **sozinho** → `t.text.success|danger|warning|info` (AA). Ícone/indicador que **acompanha um texto** (ícone do Alert, ícone de erro ao lado da mensagem do Input, chips) → `t.feedback.success|danger|warning|info` (cor clara — nunca em texto). Fundo: `emphasis=primary` → `t.color.backgroundFeedbackPrimary{Status}`, `emphasis=secondary` → `t.color.backgroundFeedbackSecondary{Status}` (ChipTag, ChipClickable). Alert não usa emphasis (status muda só o ícone).
8. **Catálogo:** story em `packages/flutter_widgetbook/lib/components/<nome>_use_cases.dart`, com `SeedHeader('<Nome>')` (descrição + nodeId do seed) e knobs dos props.
9. **Testes:** `test/widgets/<nome>_test.dart` (render, interação, semântica, disabled) + golden do que a story mostra.
10. Componente fora do seed não entra; vira proposta em `DS-BACKLOG-PROXIMAS-ETAPAS.md`, sem widget provisório.
11. Figma, seed e React só mudam com "aplicar".
