import 'package:loovi_ds/loovi_ds.dart';
// Direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Alert (seed node 4406:91): Playground + Status.
/// The close control is not in the Figma set (product request); it is a knob,
/// off by default.
WidgetbookComponent looviAlertComponent() => WidgetbookComponent(
      name: 'Alert',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final t = LooviTokens.of(context);
            return SeedStory(
              component: 'Alert',
              child: ColoredBox(
                color: t.color.backgroundSurface0,
                child: LooviAlert(
                  appearance: k.object.dropdown<LooviAlertAppearance>(
                    label: 'appearance',
                    options: LooviAlertAppearance.values,
                    labelBuilder: (v) => v == LooviAlertAppearance.defaultAppearance ? 'default' : v.name,
                  ),
                  status: k.object.dropdown<LooviAlertStatus>(
                    label: 'status',
                    options: LooviAlertStatus.values,
                    initialOption: LooviAlertStatus.success,
                    labelBuilder: (v) => v.name,
                  ),
                  title: k.string(label: 'title', initialValue: 'Pagamento confirmado'),
                  description: k.string(
                    label: 'description',
                    initialValue: 'Seu plano segue ativo. O comprovante está no seu e-mail.',
                  ),
                  showDescription: k.boolean(label: 'showDescription', initialValue: true),
                  showAction: k.boolean(label: 'showAction', initialValue: true),
                  actionLabel: k.string(label: 'actionLabel', initialValue: 'Ver comprovante'),
                  onAction: () {},
                  showClose: k.boolean(label: 'showClose (fora do Figma)'),
                  onClose: () {},
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Status',
          builder: (context) => const SeedStory(component: 'Alert', showDescription: false, child: _AlertStatus()),
        ),
      ],
    );

/// appearance × status. Same layout as the golden `alert_status.png`.
class _AlertStatus extends StatelessWidget {
  const _AlertStatus();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final a in LooviAlertAppearance.values)
          for (final s in LooviAlertStatus.values) ...[
            LooviAlert(
              appearance: a,
              status: s,
              title: 'Pagamento confirmado',
              description: 'Seu plano segue ativo. O comprovante está no seu e-mail.',
              actionLabel: 'Ver comprovante',
              onAction: () {},
            ),
            SizedBox(height: t.spacing.s100),
          ],
      ],
    );
  }
}
