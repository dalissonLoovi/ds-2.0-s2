// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Leading options available in Flutter (seed `leading` axis subset that is
/// paintable with tokens + LooviIcon).
enum _Leading { none, icon, monogram, image }

/// Trailing options (seed `trailing` axis subset).
enum _Trailing { none, icon }

WidgetbookComponent looviListItemComponent() => WidgetbookComponent(
      name: 'ListItem',
      useCases: [
        WidgetbookUseCase(name: 'Playground', builder: _playground),
        WidgetbookUseCase(name: 'Variants', builder: (_) => const _Variants()),
      ],
    );

Widget _playground(BuildContext context) {
  final k = context.knobs;
  final condition = k.object.dropdown<LooviListItemCondition>(
    label: 'condition',
    options: LooviListItemCondition.values,
    initialOption: LooviListItemCondition.threeLine,
    labelBuilder: (c) => switch (c) {
      LooviListItemCondition.oneLine => '1-line',
      LooviListItemCondition.twoLine => '2-line',
      LooviListItemCondition.threeLine => '3-line',
    },
  );
  final leading = k.object.dropdown<_Leading>(label: 'leading', options: _Leading.values, initialOption: _Leading.icon, labelBuilder: (v) => v.name);
  final trailing = k.object.dropdown<_Trailing>(label: 'trailing', options: _Trailing.values, initialOption: _Trailing.icon, labelBuilder: (v) => v.name);
  final headline = k.string(label: 'headline', initialValue: 'Meu veículo');
  final showOverline = k.boolean(label: 'showOverline');
  final overline = k.string(label: 'overline', initialValue: 'Plano Essencial');
  final showSupporting = k.boolean(label: 'showSupportingText', initialValue: true);
  final supporting = k.string(label: 'supportingText', initialValue: 'Onix 2022 · placa ABC1D23');
  final showMeta = k.boolean(label: 'showTrailingSupportingText');
  final meta = k.string(label: 'trailingSupportingText', initialValue: 'Ativo');
  final showDivider = k.boolean(label: 'showDivider');
  final interactive = k.boolean(label: 'onTap (interativo)', initialValue: true);

  return SeedStory(
    component: 'ListItem',
    child: LooviListItem(
      condition: condition,
      headline: headline,
      overline: showOverline ? overline : null,
      supportingText: showSupporting ? supporting : null,
      trailingSupportingText: showMeta ? meta : null,
      leadingIcon: leading == _Leading.icon ? LooviIcons.carOutline : null,
      leading: switch (leading) {
        _Leading.monogram => const LooviListItemMonogram('O'),
        _Leading.image => const LooviListItemImageThumbnail(),
        _ => null,
      },
      trailingIcon: trailing == _Trailing.icon ? LooviIcons.chevronRightOutline : null,
      showDivider: showDivider,
      onTap: interactive ? () {} : null,
    ),
  );
}

class _Variants extends StatelessWidget {
  const _Variants();

  @override
  Widget build(BuildContext context) {
    return SeedStory(
      component: 'ListItem',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LooviListItem(condition: LooviListItemCondition.oneLine, headline: 'Meu veículo', leadingIcon: LooviIcons.carOutline, trailingIcon: LooviIcons.chevronRightOutline, showDivider: true, onTap: () {}),
          LooviListItem(condition: LooviListItemCondition.oneLine, overline: 'Titular', headline: 'Ana Souza', leadingIcon: LooviIcons.userOutline, trailingSupportingText: 'Editar', showDivider: true, onTap: () {}),
          LooviListItem(condition: LooviListItemCondition.twoLine, headline: 'Coberturas do plano', supportingText: 'Roubo, furto e assistência 24h em todo o Brasil', leading: const LooviListItemMonogram('C'), trailingIcon: LooviIcons.chevronRightOutline, showDivider: true, onTap: () {}),
          LooviListItem(headline: 'Vistoria do veículo', supportingText: 'Envie as fotos pelo app e acompanhe a análise em até 2 dias úteis.', leading: const LooviListItemImageThumbnail(), trailingIcon: LooviIcons.chevronRightOutline, showDivider: true, onTap: () {}),
          const LooviListItem(headline: 'Documentos', supportingText: 'Apólice e termos do seu plano', leadingIcon: LooviIcons.fileTextOutline),
        ],
      ),
    );
  }
}
