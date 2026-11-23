// Direct imports until the wave exports the widgets from loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _title = 'Cancelar plano?';
const _body = 'Você perde a cobertura a partir da data de cancelamento.';

/// Slot content: copy + side-by-side actions. Inside a route the actions pop.
Widget _content(BuildContext context, {bool popRoute = false}) {
  final t = LooviTokens.of(context);
  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Text(_body, style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary)),
    SizedBox(height: t.spacing.s300),
    Row(children: [
      Expanded(
        child: LooviButton(
          label: 'Manter plano',
          variant: LooviButtonVariant.outline,
          fullWidth: true,
          onPressed: () => popRoute ? Navigator.of(context).pop(false) : null,
        ),
      ),
      SizedBox(width: t.spacing.s100),
      Expanded(
        child: LooviButton(
          label: 'Cancelar plano',
          intent: LooviButtonIntent.danger,
          fullWidth: true,
          onPressed: () => popRoute ? Navigator.of(context).pop(true) : null,
        ),
      ),
    ]),
  ]);
}

String _headerName(LooviBottomSheetHeaderVariant v) => v == LooviBottomSheetHeaderVariant.sheetHeader ? 'sheet-header' : 'none';

/// BottomSheet (seed node 3181:8289) — Playground (inline panel + real sheet)
/// and Variants. Nested BottomSheetHeader props are knobs.
WidgetbookComponent looviBottomSheetComponent() => WidgetbookComponent(
      name: 'BottomSheet',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final t = LooviTokens.of(context);
            final header = k.object.dropdown<LooviBottomSheetHeaderVariant>(
              label: 'header',
              options: LooviBottomSheetHeaderVariant.values,
              initialOption: LooviBottomSheetHeaderVariant.sheetHeader,
              labelBuilder: _headerName,
            );
            final title = k.string(label: 'title', initialValue: _title);
            final showLabel = k.boolean(label: 'showLabel', initialValue: true);
            final showOptionsAction = k.boolean(label: 'showOptionsAction');
            final showLeadingAction = k.boolean(label: 'showLeadingAction');
            final showCloseAction = k.boolean(label: 'showCloseAction', initialValue: true);

            return SeedStory(
              component: 'BottomSheet',
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Builder(
                  builder: (context) => Align(
                    alignment: Alignment.centerLeft,
                    child: LooviButton(
                      label: 'Abrir bottom sheet',
                      onPressed: () => showLooviBottomSheet<bool>(
                        context,
                        header: header,
                        title: title,
                        showLabel: showLabel,
                        showOptionsAction: showOptionsAction,
                        showLeadingAction: showLeadingAction,
                        showCloseAction: showCloseAction,
                        onOptions: () {},
                        onLeadingAction: () {},
                        semanticLabel: title,
                        builder: (c) => _content(c, popRoute: true),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: t.spacing.s300),
                ColoredBox(
                  color: t.color.backgroundSurface2,
                  child: Padding(
                    padding: EdgeInsets.only(top: t.spacing.s300),
                    child: LooviBottomSheet(
                      header: header,
                      title: title,
                      showLabel: showLabel,
                      showOptionsAction: showOptionsAction,
                      showLeadingAction: showLeadingAction,
                      showCloseAction: showCloseAction,
                      onClose: () {},
                      onOptions: () {},
                      onLeadingAction: () {},
                      child: Builder(builder: (c) => _content(c)),
                    ),
                  ),
                ),
              ]),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) =>
              const SeedStory(component: 'BottomSheet', showDescription: false, child: _BottomSheetVariants()),
        ),
      ],
    );

/// BottomSheetHeader (seed node 4307:3760) — Playground + Variants.
WidgetbookComponent looviBottomSheetHeaderComponent() => WidgetbookComponent(
      name: 'BottomSheetHeader',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'BottomSheetHeader',
              child: LooviBottomSheetHeader(
                title: k.string(label: 'title', initialValue: 'Detalhes do plano'),
                showLabel: k.boolean(label: 'showLabel', initialValue: true),
                showOptionsAction: k.boolean(label: 'showOptionsAction'),
                showLeadingAction: k.boolean(label: 'showLeadingAction'),
                showCloseAction: k.boolean(label: 'showCloseAction', initialValue: true),
                onOptions: () {},
                onLeadingAction: () {},
                onClose: () {},
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => SeedStory(
            component: 'BottomSheetHeader',
            showDescription: false,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              LooviBottomSheetHeader(title: 'Detalhes do plano', onClose: () {}),
              LooviBottomSheetHeader(
                title: 'Detalhes do plano',
                showLeadingAction: true,
                onLeadingAction: () {},
                onClose: () {},
              ),
              LooviBottomSheetHeader(title: 'Detalhes do plano', showOptionsAction: true, onOptions: () {}, onClose: () {}),
              LooviBottomSheetHeader(showLabel: false, onClose: () {}),
            ]),
          ),
        ),
      ],
    );

/// Same layout as the golden `bottom_sheet_variants.png`.
class _BottomSheetVariants extends StatelessWidget {
  const _BottomSheetVariants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget caption(String s) => Padding(
          padding: EdgeInsets.fromLTRB(t.spacing.s300, t.spacing.s0, t.spacing.s300, t.spacing.s100),
          child: Text(s, style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
        );
    return ColoredBox(
      color: t.color.backgroundSurface2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: t.spacing.s300),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          caption('BottomSheet · header=none'),
          LooviBottomSheet(header: LooviBottomSheetHeaderVariant.none, child: Builder(builder: (c) => _content(c))),
          SizedBox(height: t.spacing.s300),
          caption('BottomSheet · header=sheet-header'),
          LooviBottomSheet(title: _title, onClose: () {}, child: Builder(builder: (c) => _content(c))),
          SizedBox(height: t.spacing.s300),
          caption('BottomSheetHeader · leading / options / showLabel=false'),
          LooviBottomSheetHeader(title: 'Detalhes do plano', showLeadingAction: true, onLeadingAction: () {}, onClose: () {}),
          LooviBottomSheetHeader(title: 'Detalhes do plano', showOptionsAction: true, onOptions: () {}, onClose: () {}),
          LooviBottomSheetHeader(showLabel: false, onClose: () {}),
        ]),
      ),
    );
  }
}
