// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Seed default composition.
const _defaultItems = [
  LooviFeatureStepsItem(
    leadingIcon: LooviIcons.squareCheckOutline,
    headline: 'Permissões',
    supportingText: 'Ative localização e alertas para resposta mais rápida.',
  ),
  LooviFeatureStepsItem(
    leadingIcon: LooviIcons.carOutline,
    headline: 'Confirmar Veículo',
    supportingText: 'Vincula sua proteção ao veículo certo.',
  ),
  LooviFeatureStepsItem(
    leadingIcon: LooviIcons.trophyOutline,
    headline: 'Enviar fotos e documentos',
    supportingText: 'São as evidências usadas no momento do atendimento.',
    showConnector: false,
  ),
];

/// FeatureSteps (seed node 4344:224): Default (seed composition; same as the
/// golden `feature_steps_default.png`).
WidgetbookComponent looviFeatureStepsComponent() => WidgetbookComponent(
  name: 'FeatureSteps',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const SeedStory(
        component: 'FeatureSteps',
        child: LooviFeatureSteps(items: _defaultItems, semanticLabel: 'Próximos passos'),
      ),
    ),
  ],
);

