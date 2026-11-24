import 'package:loovi_ds/loovi_ds.dart';
// ignore: implementation_imports — direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Toast (seed node 3550:4107): Playground + Status.
/// Showing / timing / stacking is app logic; the story renders the toast inline.
WidgetbookComponent looviToastComponent() => WidgetbookComponent(
  name: 'Toast',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        return SeedStory(
          component: 'Toast',
          child: LooviToast(
            status: k.object.dropdown<LooviToastStatus>(
              label: 'status',
              options: LooviToastStatus.values,
              initialOption: LooviToastStatus.success,
              labelBuilder: (v) => v.name,
            ),
            message: k.string(label: 'message', initialValue: 'Pagamento confirmado'),
            showAction: k.boolean(label: 'showAction'),
            actionLabel: k.string(label: 'actionLabel', initialValue: 'Ver'),
            onAction: () {},
            dismissible: k.boolean(label: 'dismissible', initialValue: true),
            onDismiss: () {},
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Status',
      builder: (context) => const SeedStory(component: 'Toast', showDescription: false, child: _ToastStatus()),
    ),
  ],
);

/// Example copy per status (brand voice; no invented dates or claims).
const _toastCopy = <LooviToastStatus, String>{
  LooviToastStatus.system: 'Seus dados foram atualizados',
  LooviToastStatus.info: 'Vistoria enviada para análise',
  LooviToastStatus.success: 'Pagamento confirmado',
  LooviToastStatus.danger: 'Não foi possível enviar as fotos',
  LooviToastStatus.warning: 'Sua conexão está instável',
};

/// Every status + action + non-dismissible. Same as the golden `toast_status.png`.
class _ToastStatus extends StatelessWidget {
  const _ToastStatus();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final s in LooviToastStatus.values) ...[
          LooviToast(status: s, message: _toastCopy[s]!, onDismiss: () {}),
          SizedBox(height: t.spacing.s200),
        ],
        LooviToast(
          status: LooviToastStatus.danger,
          message: 'Pagamento não aprovado',
          showAction: true,
          actionLabel: 'Tentar',
          onAction: () {},
          onDismiss: () {},
        ),
        SizedBox(height: t.spacing.s200),
        const LooviToast(status: LooviToastStatus.success, message: 'Foto enviada', dismissible: false),
      ],
    );
  }
}
