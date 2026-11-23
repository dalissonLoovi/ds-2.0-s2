import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Alert (seed node 4406:91): Playground + Status + Close.
/// Seed `showClose` (default false) is a knob.
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
                labelBuilder: (v) => v == LooviAlertAppearance.standard ? 'default' : v.name,
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
              showClose: k.boolean(label: 'showClose'),
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
    WidgetbookUseCase(
      name: 'Close',
      builder: (context) => const SeedStory(component: 'Alert', showDescription: false, child: _AlertClose()),
    ),
  ],
);

/// Example copy per status (brand voice; no invented dates or claims).
const _alertCopy = <LooviAlertStatus, (String, String, String)>{
  LooviAlertStatus.system: ('Confira seus dados de contato', 'Mantenha e-mail e telefone em dia para receber os avisos.', 'Revisar dados'),
  LooviAlertStatus.info: ('Vistoria do veículo', 'Envie as fotos do veículo pelo app para concluir a vistoria.', 'Enviar fotos'),
  LooviAlertStatus.success: ('Pagamento confirmado', 'Seu plano segue ativo. O comprovante está no seu e-mail.', 'Ver comprovante'),
  LooviAlertStatus.danger: ('Pagamento não aprovado', 'Confira os dados do cartão ou escolha outra forma de pagamento.', 'Tentar de novo'),
  LooviAlertStatus.warning: ('Sua fatura vence amanhã', 'Pague até o vencimento para manter a proteção do carro ativa.', 'Ver fatura'),
};

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
              title: _alertCopy[s]!.$1,
              description: _alertCopy[s]!.$2,
              actionLabel: _alertCopy[s]!.$3,
              onAction: () {},
            ),
            SizedBox(height: t.spacing.s100),
          ],
      ],
    );
  }
}

/// showClose=true on both appearances; status=system (no icon) shows the long
/// title kept clear of the close action.
class _AlertClose extends StatelessWidget {
  const _AlertClose();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final a in LooviAlertAppearance.values)
          for (final s in [LooviAlertStatus.info, LooviAlertStatus.system]) ...[
            LooviAlert(
              appearance: a,
              status: s,
              title: 'Seu boleto vence amanhã e o pagamento ainda não foi identificado',
              description: 'Pague até o vencimento para manter a cobertura ativa.',
              actionLabel: 'Ver boleto',
              onAction: () {},
              showClose: true,
              onClose: () {},
            ),
            SizedBox(height: t.spacing.s100),
          ],
      ],
    );
  }
}
