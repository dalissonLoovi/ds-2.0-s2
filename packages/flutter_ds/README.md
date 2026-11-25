# loovi_ds — Design System Loovi S2 para Flutter

Componentes do Design System Loovi (S2) para o App Cliente: 102 componentes, ícones,
ilustrações, logo e marcas de pagamento. As cores, espaçamentos, raios e tipografia
vêm do pacote `loovi_tokens` (incluído automaticamente).

- Catálogo (Widgetbook): https://dalissonloovi.github.io/ds-2.0-s2/flutter/
- Documentação do DS (Storybook): https://dalissonloovi.github.io/ds-2.0-s2/
- Inventário dos componentes Flutter: [`FLUTTER-INVENTORY.md`](../../FLUTTER-INVENTORY.md)
- Regras para quem contribui com o pacote: [`FLUTTER-CONTRIBUTING.md`](../../FLUTTER-CONTRIBUTING.md)

## Requisitos

- Flutter **3.50.1** ou mais novo (Dart ^3.14).
- `material_ui` ^1.11.1 — use `package:material_ui/material_ui.dart`, não
  `package:flutter/material.dart` (descontinuado).

## Instalação

No `pubspec.yaml` do app, aponte para uma **versão (tag)** do repositório:

```yaml
dependencies:
  flutter:
    sdk: flutter
  material_ui: ^1.11.1
  loovi_ds:
    git:
      url: https://github.com/dalissonLoovi/ds-2.0-s2
      path: packages/flutter_ds
      ref: flutter-v0.1.0
```

Depois: `flutter pub get`. Não é preciso declarar `loovi_tokens`; ele vem junto.

Para atualizar o DS, troque o `ref` para a tag nova (ex.: `flutter-v0.2.0`) e rode
`flutter pub upgrade loovi_ds`. Evite `ref: main` em produção: qualquer mudança no DS
entraria no app sem aviso.

## Uso

```dart
import 'package:loovi_ds/loovi_ds.dart'; // reexporta loovi_tokens
import 'package:material_ui/material_ui.dart';

void main() => runApp(
      MaterialApp(
        theme: LooviTheme.light(), // modo de produto app-cliente por padrão
        home: const HomePage(),
      ),
    );

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          children: [
            const LooviInput(label: 'Nome completo', placeholder: 'Digite seu nome'),
            SizedBox(height: t.spacing.s200),
            LooviButton(label: 'Continuar', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
```

- **Tokens:** sempre `LooviTokens.of(context)` — `t.color.*`, `t.text.*`, `t.spacing.*`,
  `t.radius.*`, `t.typography.*`. Não use cores ou tamanhos escritos à mão.
- **Ícones:** `LooviIcon(LooviIcons.searchOutline)` — nomes no contrato do DS
  (`*-outline` / `*-filled`).
- **Exemplos de cada componente:** no Widgetbook (link acima), com os parâmetros ajustáveis.

## O que o app fornece

O pacote não tem regra de negócio nem dependências de estado (Riverpod, Bloc, go_router).
Ficam com o app:

- **Fotos e imagens** (cards, miniaturas, `LooviImageItem`): passadas como `ImageProvider`.
- **Bandeiras de país** no `LooviSelectCountry` (parâmetro `countryFlag`).
- **Escolha e envio de arquivos e fotos:** os componentes de upload (`LooviFileUploader`,
  `LooviUploadPhotos`) mostram os estados e chamam os callbacks (`onPick`, `onRemove`,
  `onSelectPhoto`…); o app usa o plugin de câmera/arquivos que preferir.
- **Exibição temporária** de Toast, Modal e BottomSheet (quando abrir, por quanto tempo).

## Limitações conhecidas

- Só tema claro (o DS não tem modo escuro).
- Sem hover: os componentes seguem o modelo de toque do celular.
- Textos padrão em pt-BR; troque pelos parâmetros de cada componente.

## Versões

| Tag | Data | Conteúdo |
| --- | --- | --- |
| `flutter-v0.1.0` | 2026-11-25 | Primeira versão: 102 componentes (ondas 1–5), 58 ícones, 25 marcas de pagamento, logo e ilustrações. |
