import 'package:loovi_ds/loovi_ds.dart';
// ignore: implementation_imports — direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Banner (seed node 3098:2629): Playground + Status (emphasis × status).
WidgetbookComponent looviBannerComponent() => WidgetbookComponent(
  name: 'Banner',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        return SeedStory(
          component: 'Banner',
          child: LooviBanner(
            status: k.object.dropdown<LooviBannerStatus>(
              label: 'status',
              options: LooviBannerStatus.values,
              initialOption: LooviBannerStatus.info,
              labelBuilder: (v) => v.name,
            ),
            emphasis: k.object.dropdown<LooviBannerEmphasis>(
              label: 'emphasis',
              options: LooviBannerEmphasis.values,
              labelBuilder: (v) => v.name,
            ),
            message: k.string(label: 'message', initialValue: 'Vistoria em análise'),
            showIcon: k.boolean(label: 'showIcon', initialValue: true),
            showAction: k.boolean(label: 'showAction', initialValue: true),
            actionLabel: k.string(label: 'action', initialValue: 'Ver detalhes'),
            onAction: () {},
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Status',
      builder: (context) => const SeedStory(component: 'Banner', showDescription: false, child: _BannerStatus()),
    ),
  ],
);

/// Example copy per status (verb + complement actions).
const _bannerCopy = <LooviBannerStatus, (String, String)>{
  LooviBannerStatus.success: ('Pagamento confirmado', 'Ver recibo'),
  LooviBannerStatus.warning: ('Fatura vence amanhã', 'Ver fatura'),
  LooviBannerStatus.info: ('Vistoria em análise', 'Ver detalhes'),
  LooviBannerStatus.danger: ('Cartão recusado', 'Corrigir dados'),
};

/// emphasis × status. Same as the golden `banner_status.png`.
class _BannerStatus extends StatelessWidget {
  const _BannerStatus();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final e in LooviBannerEmphasis.values)
          for (final s in LooviBannerStatus.values) ...[
            LooviBanner(
              status: s,
              emphasis: e,
              message: _bannerCopy[s]!.$1,
              showAction: true,
              actionLabel: _bannerCopy[s]!.$2,
              onAction: () {},
            ),
            SizedBox(height: t.spacing.s100),
          ],
        const LooviBanner(message: 'Sem ícone e sem ação', showIcon: false),
      ],
    );
  }
}
