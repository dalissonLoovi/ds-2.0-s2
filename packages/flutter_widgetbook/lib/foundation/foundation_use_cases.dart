import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'illustrations_use_cases.dart';

/// Foundation gallery — every value comes from `LooviTokens` (generated).
WidgetbookFolder foundationFolder() => WidgetbookFolder(
      name: 'Foundations',
      children: [
        WidgetbookComponent(name: 'Color', useCases: [
          WidgetbookUseCase(name: 'Semantic', builder: (c) => _ColorPage(groups: _semanticGroups(LooviTokens.of(c)))),
          WidgetbookUseCase(name: 'Primitives', builder: (c) => _ColorPage(groups: {'primitive-colors': LooviTokens.of(c).primitive.all})),
        ]),
        WidgetbookComponent(name: 'Typography', useCases: [
          WidgetbookUseCase(name: 'Scale', builder: (c) => const _TypographyPage()),
        ]),
        WidgetbookComponent(name: 'Spacing', useCases: [
          WidgetbookUseCase(name: 'Scale', builder: (c) => const _SpacingPage()),
        ]),
        WidgetbookComponent(name: 'Radius & border', useCases: [
          WidgetbookUseCase(name: 'Scale', builder: (c) => const _RadiusPage()),
        ]),
        WidgetbookComponent(name: 'Product theme', useCases: [
          WidgetbookUseCase(name: 'app-cliente', builder: (c) => const _ProductThemePage()),
        ]),
        illustrationsComponent(),
      ],
    );

Map<String, Map<String, Color>> _semanticGroups(LooviTokens t) => {
      'color': t.color.all,
      'text': t.text.all,
      'feedback': t.feedback.all,
      'interactive': t.interactive.all,
    };

class _Page extends StatelessWidget {
  const _Page({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: ListView(
        padding: EdgeInsets.all(t.spacing.s200),
        children: children,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Padding(
      padding: EdgeInsets.only(top: t.spacing.s300, bottom: t.spacing.s100),
      child: Text(text, style: t.typography.headingH3Medium.copyWith(color: t.text.primary)),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption(this.text, {this.secondary = false});
  final String text;
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Text(
      text,
      style: (secondary ? t.typography.bodySmallRegular : t.typography.bodySmallMedium)
          .copyWith(color: secondary ? t.text.secondary : t.text.primary),
    );
  }
}

String _hex(Color c) {
  final argb = c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
  return argb.startsWith('FF') ? '#${argb.substring(2)}' : '#${argb.substring(2)}${argb.substring(0, 2)}';
}

class _ColorPage extends StatelessWidget {
  const _ColorPage({required this.groups});
  final Map<String, Map<String, Color>> groups;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return _Page(children: [
      for (final g in groups.entries) ...[
        _SectionTitle(g.key),
        for (final e in g.value.entries)
          Padding(
            padding: EdgeInsets.only(bottom: t.spacing.s100),
            child: Row(children: [
              Container(
                width: t.spacing.s600,
                height: t.spacing.s600,
                decoration: BoxDecoration(
                  color: e.value,
                  borderRadius: BorderRadius.circular(t.radius.s200),
                  border: Border.all(color: t.color.border2, width: t.borderWidth.s012),
                ),
              ),
              SizedBox(width: t.spacing.s150),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _Caption(e.key),
                  _Caption(_hex(e.value), secondary: true),
                ]),
              ),
            ]),
          ),
      ],
    ]);
  }
}

class _TypographyPage extends StatelessWidget {
  const _TypographyPage();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return _Page(children: [
      const _SectionTitle('Poppins — typography/*'),
      for (final e in t.typography.all.entries)
        Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s150),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _Caption(
              '${e.key} · ${e.value.fontSize!.toStringAsFixed(0)}/'
              '${(e.value.fontSize! * e.value.height!).toStringAsFixed(0)}',
              secondary: true,
            ),
            Text('Seu carro protegido com a Loovi', style: e.value.copyWith(color: t.text.primary)),
          ]),
        ),
    ]);
  }
}

class _SpacingPage extends StatelessWidget {
  const _SpacingPage();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return _Page(children: [
      const _SectionTitle('spacing/*'),
      for (final e in t.spacing.all.entries)
        Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: Row(children: [
            SizedBox(width: t.spacing.s1200, child: _Caption('${e.key} · ${e.value.toStringAsFixed(0)}')),
            Container(width: e.value, height: t.spacing.s200, color: t.color.backgroundSurfaceBrand),
          ]),
        ),
    ]);
  }
}

class _RadiusPage extends StatelessWidget {
  const _RadiusPage();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return _Page(children: [
      const _SectionTitle('border/radius/*'),
      Wrap(spacing: t.spacing.s200, runSpacing: t.spacing.s200, children: [
        for (final e in t.radius.all.entries)
          Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: t.spacing.s1000,
              height: t.spacing.s700,
              decoration: BoxDecoration(
                color: t.color.backgroundSurface2,
                borderRadius: BorderRadius.circular(e.value),
                border: Border.all(color: t.color.borderFeedbackPrimary, width: t.borderWidth.s012),
              ),
            ),
            SizedBox(height: t.spacing.s050),
            _Caption('${e.key.split('/').last} · ${e.value.toStringAsFixed(0)}'),
          ]),
      ]),
      const _SectionTitle('border/width/*'),
      for (final e in t.borderWidth.all.entries)
        Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: Row(children: [
            SizedBox(width: t.spacing.s1200, child: _Caption('${e.key} · ${e.value}')),
            Expanded(child: Container(height: e.value, color: t.text.primary)),
          ]),
        ),
      const _SectionTitle('effects/elevation'),
      Wrap(spacing: t.spacing.s300, runSpacing: t.spacing.s300, children: [
        for (final e in {
          '1': t.effects.elevation1,
          '2': t.effects.elevation2,
          '3': t.effects.elevation3,
        }.entries)
          Container(
            width: t.spacing.s1000,
            height: t.spacing.s700,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: t.color.backgroundSurface0,
              borderRadius: BorderRadius.circular(t.radius.s400),
              boxShadow: LooviEffects.box(e.value),
            ),
            child: _Caption('elevation/${e.key}'),
          ),
      ]),
    ]);
  }
}

class _ProductThemePage extends StatelessWidget {
  const _ProductThemePage();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final c = t.component;
    final rows = <String, String>{
      'button/container/background': _hex(c.button.containerBackground),
      'button/container/radius/lg · sm': '${c.button.containerRadiusLg} · ${c.button.containerRadiusSm}',
      'button/label/color · weight': '${_hex(c.button.labelColor)} · ${c.button.labelFontWeight}',
      'app-header/inverse/background': _hex(c.appHeader.inverseBackground),
      'app-header/title': '${c.appHeader.titleFontSize}/${c.appHeader.titleLineHeight} · ${c.appHeader.titleFontWeight}',
      'input/field/radius': '${c.input.fieldRadius}',
      'input-textarea/field/radius': '${c.inputTextarea.fieldRadius}',
      'list-action/container/radius': '${c.listAction.containerRadius}',
      'modal/container/radius': '${c.modal.containerRadius}',
      'modal-header/close-action/size-mobile': '${c.modalHeader.closeActionSizeMobile}',
      'section-header/action/background': _hex(c.sectionHeader.actionBackground),
    };
    return _Page(children: [
      _SectionTitle('product-theme · ${t.mode.figmaName}'),
      _Caption('Seed revision $looviSeedRevision', secondary: true),
      SizedBox(height: t.spacing.s200),
      for (final r in rows.entries)
        Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: Row(children: [
            Expanded(child: _Caption(r.key)),
            _Caption(r.value, secondary: true),
          ]),
        ),
    ]);
  }
}
