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

/// Seed footer (showFooter): primary "Manter plano" (solid) + secondary
/// "Cancelar plano" (text, danger). Layout follows the enclosing Modal platform
/// (web: row at the end, lg; mobile: stacked full width, md). Inside a route the
/// actions pop with the choice.
Widget _actions(BuildContext context, {bool popRoute = false}) => LooviModalFooter(
  primaryAction: LooviModalAction(
    label: 'Manter plano',
    onPressed: () => popRoute ? Navigator.of(context).pop(false) : null,
  ),
  secondaryAction: LooviModalAction(
    label: 'Cancelar plano',
    intent: LooviButtonIntent.danger,
    onPressed: () => popRoute ? Navigator.of(context).pop(true) : null,
  ),
);

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
        final showFooter = k.boolean(label: 'showFooter', initialValue: true);

        return SeedStory(
          component: 'Modal',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    primaryAction: showFooter ? LooviModalAction(label: 'Manter plano', onPressed: () {}) : null,
                    secondaryAction: showFooter
                        ? LooviModalAction(label: 'Cancelar plano', intent: LooviButtonIntent.danger, onPressed: () {})
                        : null,
                    child: Builder(builder: _bodyText),
                  ),
                ),
              ),
            ],
          ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final layout in LooviModalHeaderLayout.values)
                  for (final alignment in LooviModalHeaderAlignment.values)
                    LooviModalHeader(
                      title: 'Cancelar plano?',
                      label: 'Plano Essencial',
                      showLabel: true,
                      layout: layout,
                      alignment: alignment,
                      onClose: () {},
                    ),
              ],
            ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            caption('Modal · platform=mobile · slot + showFooter'),
            LooviModal(
              title: _title,
              onClose: () {},
              primaryAction: LooviModalAction(label: 'Manter plano', onPressed: () {}),
              secondaryAction: LooviModalAction(
                label: 'Cancelar plano',
                intent: LooviButtonIntent.danger,
                onPressed: () {},
              ),
              child: Builder(builder: _bodyText),
            ),
            SizedBox(height: t.spacing.s300),
            caption('Modal · platform=web · showFooter'),
            LooviModal(
              title: _title,
              platform: LooviModalPlatform.web,
              onClose: () {},
              primaryAction: LooviModalAction(label: 'Manter', onPressed: () {}),
              secondaryAction: LooviModalAction(label: 'Cancelar', intent: LooviButtonIntent.danger, onPressed: () {}),
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
              child: Column(
                children: [
                  LooviModalHeader(title: 'Cancelar plano?', label: 'Plano Essencial', showLabel: true, onClose: () {}),
                  LooviModalHeader(
                    title: 'Cancelar plano?',
                    label: 'Plano Essencial',
                    showLabel: true,
                    alignment: LooviModalHeaderAlignment.center,
                    onClose: () {},
                  ),
                  const LooviModalHeader(title: 'Cancelar plano?', showCloseAction: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
