// Direct imports until the wave exports the widgets from loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _title = 'Cancelar plano?';
const _body = 'Você perde a cobertura a partir da data de cancelamento.';

Widget _bodyText(BuildContext context) {
  final t = LooviTokens.of(context);
  return Text(_body, style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary));
}

/// Stacked actions: "Manter plano" (safe, solid) over "Cancelar plano"
/// (destructive, text/danger). Inside a route they pop with the choice.
Widget _actions(BuildContext context, {bool popRoute = false}) {
  final t = LooviTokens.of(context);
  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    LooviButton(
      label: 'Manter plano',
      fullWidth: true,
      onPressed: () => popRoute ? Navigator.of(context).pop(false) : null,
    ),
    SizedBox(height: t.spacing.s100),
    LooviButton(
      label: 'Cancelar plano',
      variant: LooviButtonVariant.text,
      intent: LooviButtonIntent.danger,
      fullWidth: true,
      onPressed: () => popRoute ? Navigator.of(context).pop(true) : null,
    ),
  ]);
}

/// Modal (seed node 3306:4278) — Playground (inline panel + real dialog) and
/// Variants. Nested ModalHeader props are knobs, as in the seed.
WidgetbookComponent looviModalComponent() => WidgetbookComponent(
      name: 'Modal',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final t = LooviTokens.of(context);
            final platform = k.object.dropdown<LooviModalPlatform>(
              label: 'platform',
              options: LooviModalPlatform.values,
              initialOption: LooviModalPlatform.mobile,
              labelBuilder: (v) => v == LooviModalPlatform.mobileLandscape ? 'mobile-landscape' : v.name,
            );
            final alignment = k.object.dropdown<LooviModalHeaderAlignment>(
              label: 'alignment (ModalHeader)',
              options: LooviModalHeaderAlignment.values,
              labelBuilder: (v) => v.name,
            );
            final title = k.string(label: 'title', initialValue: _title);
            final label = k.string(label: 'label', initialValue: 'Plano Essencial');
            final showLabel = k.boolean(label: 'showLabel');
            final showCloseAction = k.boolean(label: 'showCloseAction', initialValue: true);
            final showFooter = k.boolean(label: 'footer (actions)', initialValue: true);

            return SeedStory(
              component: 'Modal',
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Builder(
                  builder: (context) => Align(
                    alignment: Alignment.centerLeft,
                    child: LooviButton(
                      label: 'Abrir modal',
                      onPressed: () => showLooviModal<bool>(
                        context,
                        title: title,
                        platform: platform,
                        alignment: alignment,
                        label: label,
                        showLabel: showLabel,
                        showCloseAction: showCloseAction,
                        builder: _bodyText,
                        footerBuilder: showFooter ? (c) => _actions(c, popRoute: true) : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: t.spacing.s300),
                ColoredBox(
                  color: t.color.backgroundSurface1,
                  child: Padding(
                    padding: EdgeInsets.all(t.spacing.s300),
                    child: LooviModal(
                      title: title,
                      platform: platform,
                      alignment: alignment,
                      label: label,
                      showLabel: showLabel,
                      showCloseAction: showCloseAction,
                      onClose: () {},
                      footer: showFooter ? Builder(builder: (c) => _actions(c)) : null,
                      child: Builder(builder: _bodyText),
                    ),
                  ),
                ),
              ]),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => const SeedStory(component: 'Modal', showDescription: false, child: _ModalVariants()),
        ),
      ],
    );

/// ModalHeader (seed node 3786:9403) — Playground + Variants.
WidgetbookComponent looviModalHeaderComponent() => WidgetbookComponent(
      name: 'ModalHeader',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final t = LooviTokens.of(context);
            return SeedStory(
              component: 'ModalHeader',
              child: ColoredBox(
                color: t.color.backgroundSurface0,
                child: LooviModalHeader(
                  title: k.string(label: 'title', initialValue: _title),
                  layout: k.object.dropdown<LooviModalHeaderLayout>(
                    label: 'layout',
                    options: LooviModalHeaderLayout.values,
                    initialOption: LooviModalHeaderLayout.mobile,
                    labelBuilder: (v) => v.name,
                  ),
                  alignment: k.object.dropdown<LooviModalHeaderAlignment>(
                    label: 'alignment',
                    options: LooviModalHeaderAlignment.values,
                    labelBuilder: (v) => v.name,
                  ),
                  label: k.string(label: 'label', initialValue: 'Plano Essencial'),
                  showLabel: k.boolean(label: 'showLabel'),
                  showCloseAction: k.boolean(label: 'showCloseAction', initialValue: true),
                  onClose: () {},
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) {
            final t = LooviTokens.of(context);
            return SeedStory(
              component: 'ModalHeader',
              showDescription: false,
              child: ColoredBox(
                color: t.color.backgroundSurface0,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  for (final layout in LooviModalHeaderLayout.values)
                    for (final alignment in LooviModalHeaderAlignment.values)
                      LooviModalHeader(
                        title: 'Title',
                        label: 'Optional label',
                        showLabel: true,
                        layout: layout,
                        alignment: alignment,
                        onClose: () {},
                      ),
                ]),
              ),
            );
          },
        ),
      ],
    );

/// Same layout as the golden `modal_variants.png`.
class _ModalVariants extends StatelessWidget {
  const _ModalVariants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget caption(String s) => Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: Text(s, style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
        );
    return ColoredBox(
      color: t.color.backgroundSurface1,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s300),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          caption('Modal · platform=mobile · slot + footer'),
          LooviModal(
            title: _title,
            onClose: () {},
            footer: Builder(builder: (c) => _actions(c)),
            child: Builder(builder: _bodyText),
          ),
          SizedBox(height: t.spacing.s300),
          caption('Modal · mobile · alignment=center · showLabel'),
          LooviModal(
            title: _title,
            label: 'Plano Essencial',
            showLabel: true,
            alignment: LooviModalHeaderAlignment.center,
            onClose: () {},
            child: Builder(builder: _bodyText),
          ),
          SizedBox(height: t.spacing.s300),
          caption('ModalHeader · layout=mobile · start / center'),
          ColoredBox(
            color: t.color.backgroundSurface0,
            child: Column(children: [
              LooviModalHeader(title: 'Title', label: 'Optional label', showLabel: true, onClose: () {}),
              LooviModalHeader(
                title: 'Title',
                label: 'Optional label',
                showLabel: true,
                alignment: LooviModalHeaderAlignment.center,
                onClose: () {},
              ),
              const LooviModalHeader(title: 'Title', showCloseAction: false),
            ]),
          ),
        ]),
      ),
    );
  }
}
