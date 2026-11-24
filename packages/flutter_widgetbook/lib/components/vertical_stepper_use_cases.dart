import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _steps = <(String, String)>[
  ('Dados pessoais', 'Nome, CPF e contato'),
  ('Dados do veículo', 'Placa e modelo'),
  ('Vistoria', 'Fotos do carro'),
  ('Pagamento', 'Forma de pagamento'),
];

/// VerticalStepper (seed node 3833:118): Playground + Default.
WidgetbookComponent looviVerticalStepperComponent() => WidgetbookComponent(
  name: 'VerticalStepper',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final current = k.int.slider(label: 'current step (app logic)', initialValue: 2, min: 1, max: _steps.length);
        final error = k.boolean(label: 'current step has error');
        // Status math is app logic (seed statusOnItem); the story derives it.
        return SeedStory(
          component: 'VerticalStepper',
          child: LooviVerticalStepper(
            semanticLabel: 'Etapas da adesão',
            items: [
              for (var i = 1; i <= _steps.length; i++)
                LooviVerticalStepperItem(
                  headline: _steps[i - 1].$1,
                  supportingText: _steps[i - 1].$2,
                  status: i < current
                      ? LooviVerticalStepperItemStatus.completed
                      : i > current
                          ? LooviVerticalStepperItemStatus.pending
                          : error
                              ? LooviVerticalStepperItemStatus.error
                              : LooviVerticalStepperItemStatus.current,
                  showConnector: i < _steps.length,
                ),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => SeedStory(
        component: 'VerticalStepper',
        showDescription: false,
        child: LooviVerticalStepper(
          semanticLabel: 'Etapas da adesão',
          items: [
            LooviVerticalStepperItem(headline: _steps[0].$1, supportingText: _steps[0].$2),
            LooviVerticalStepperItem(
              headline: _steps[1].$1,
              supportingText: _steps[1].$2,
              status: LooviVerticalStepperItemStatus.current,
            ),
            LooviVerticalStepperItem(
              headline: _steps[2].$1,
              supportingText: _steps[2].$2,
              status: LooviVerticalStepperItemStatus.pending,
            ),
            LooviVerticalStepperItem(
              headline: _steps[3].$1,
              supportingText: _steps[3].$2,
              status: LooviVerticalStepperItemStatus.pending,
              showConnector: false,
            ),
          ],
        ),
      ),
    ),
  ],
);
