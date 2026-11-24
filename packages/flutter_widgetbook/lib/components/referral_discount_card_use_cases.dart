import 'package:loovi_ds/loovi_ds.dart';
// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ReferralDiscountCard (seed node 4594:995) — Playground (mode + referrals).
WidgetbookComponent looviReferralDiscountCardComponent() => WidgetbookComponent(
      name: 'ReferralDiscountCard',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final referrals = k.int.slider(label: 'referrals (runtime, 0–10)', initialValue: 2, min: 0, max: 10);
            final percent = '${referrals * 10}% de desconto';
            return SeedStory(
              component: 'ReferralDiscountCard',
              child: LooviReferralDiscountCard(
                mode: k.object.dropdown<LooviReferralDiscountCardMode>(
                  label: 'mode',
                  options: LooviReferralDiscountCardMode.values,
                  labelBuilder: (v) => v.name,
                ),
                referrals: referrals,
                title: k.string(label: 'title', initialValue: 'Descontômetro'),
                promoTitle: k.string(label: 'promoTitle', initialValue: 'Zere sua mensalidade'),
                description: k.string(
                  label: 'description',
                  initialValue: 'Para cada indicação você ganha 10% de desconto. Com 10 indicações você zera sua mensalidade.',
                ),
                fleetTitle: k.string(label: 'fleetTitle', initialValue: 'Indique amigos e ganhe desconto'),
                fleetDescription: k.string(
                  label: 'fleetDescription',
                  initialValue: 'A cada amigo que contratar pela sua indicação, você ganha 10% de desconto na mensalidade.',
                ),
                referralCount: '$referrals indicações',
                discountPercent: percent,
                savingsAmount: k.string(label: 'savingsAmount', initialValue: 'R\$ 0,00'),
                savingsCaption: k.string(label: 'savingsCaption', initialValue: 'economizados até agora.'),
                simulatorTitle: k.string(label: 'simulatorTitle', initialValue: 'Simulador de indicação'),
                projectedDiscount: percent,
                discountAmount: k.string(label: 'discountAmount', initialValue: '- R\$ 0,00/mês'),
                onInvite: () {},
              ),
            );
          },
        ),
      ],
    );
