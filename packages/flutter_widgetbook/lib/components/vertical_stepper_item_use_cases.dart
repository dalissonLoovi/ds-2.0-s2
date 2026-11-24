import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// VerticalStepperItem (seed node 3437:531): Playground + Status.
WidgetbookComponent looviVerticalStepperItemComponent() => WidgetbookComponent(
  name: 'VerticalStepperItem',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final supporting = k.string(label: 'supportingText', initialValue: 'Envie 6 fotos do carro');
        final overline = k.string(label: 'overline', initialValue: '');
        final trailingMeta = k.string(label: 'trailingSupportingText', initialValue: '');
        final actionable = k.boolean(label: 'actionable (onTap)');
        return SeedStory(
          component: 'VerticalStepperItem',
          child: LooviVerticalStepperItem(
            headline: k.string(label: 'headline', initialValue: 'Fotos do veículo'),
            status: k.object.dropdown<LooviVerticalStepperItemStatus>(
              label: 'status',
              options: LooviVerticalStepperItemStatus.values,
              initialOption: LooviVerticalStepperItemStatus.current,
              labelBuilder: (v) => v.name,
            ),
            showConnector: k.boolean(label: 'showConnector', initialValue: true),
            condition: k.object.dropdown<LooviListItemCondition>(
              label: 'condition',
              options: LooviListItemCondition.values,
              initialOption: LooviListItemCondition.twoLine,
              labelBuilder: (v) => switch (v) {
                LooviListItemCondition.oneLine => '1-line',
                LooviListItemCondition.twoLine => '2-line',
                LooviListItemCondition.threeLine => '3-line',
              },
            ),
            supportingText: supporting.isEmpty ? null : supporting,
            overline: overline.isEmpty ? null : overline,
            trailingSupportingText: trailingMeta.isEmpty ? null : trailingMeta,
            showDivider: k.boolean(label: 'showDivider'),
            onTap: actionable ? () {} : null,
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Status',
      builder: (context) => const SeedStory(component: 'VerticalStepperItem', showDescription: false, child: _Status()),
    ),
  ],
);

/// One item per status. Same as the golden `vertical_stepper_item_status.png`.
class _Status extends StatelessWidget {
  const _Status();

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LooviVerticalStepperItem(headline: 'Dados pessoais', supportingText: 'Concluído'),
          LooviVerticalStepperItem(
            headline: 'Fotos do veículo',
            supportingText: 'Envie 6 fotos',
            status: LooviVerticalStepperItemStatus.current,
          ),
          LooviVerticalStepperItem(
            headline: 'Documento',
            supportingText: 'A foto ficou ilegível',
            status: LooviVerticalStepperItemStatus.error,
          ),
          LooviVerticalStepperItem(
            headline: 'Pagamento',
            supportingText: 'Escolha a forma',
            status: LooviVerticalStepperItemStatus.pending,
            showConnector: false,
          ),
        ],
      );
}
