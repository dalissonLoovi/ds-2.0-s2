import 'package:loovi_ds/loovi_ds.dart';
// Until lib/loovi_ds.dart exports it (integration step owned by the lead).
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Accordion (seed node 3669:9362) — Playground + Lista.
/// `expanded` is interactive (tap the trigger); `state=disabled` is a knob.
WidgetbookComponent looviAccordionComponent() => WidgetbookComponent(
      name: 'Accordion',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final t = LooviTokens.of(context);
            return SeedStory(
              component: 'Accordion',
              child: LooviAccordion(
                label: k.string(label: 'label', initialValue: 'Plano Loovi'),
                showSubtitle: k.boolean(label: 'showSubtitle', initialValue: true),
                subtitle: k.string(label: 'subtitle', initialValue: 'Cobertura completa'),
                showSummary: k.boolean(label: 'showSummary', initialValue: true),
                summary: k.string(label: 'summary', initialValue: r'R$ 89,90'),
                showAction: k.boolean(label: 'showAction', initialValue: true),
                actionLabel: k.string(label: 'action label', initialValue: 'Ver detalhes'),
                onAction: () {},
                disabled: k.boolean(label: 'state=disabled'),
                size: k.object.dropdown<LooviAccordionSize>(
                  label: 'size',
                  options: LooviAccordionSize.values,
                  initialOption: LooviAccordionSize.md,
                  labelBuilder: (v) => v.name,
                ),
                padding: k.object.dropdown<LooviAccordionPadding>(
                  label: 'padding',
                  options: LooviAccordionPadding.values,
                  labelBuilder: (v) => v.name,
                ),
                initiallyExpanded: true,
                child: Text(
                  'Assistência 24h, guincho e carro reserva em todo o Brasil.',
                  style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Lista',
          builder: (context) {
            final t = LooviTokens.of(context);
            Widget body(String s) => Text(s, style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary));
            return SeedStory(
              component: 'Accordion',
              showDescription: false,
              child: Column(
                children: [
                  LooviAccordion(
                    label: 'O que está incluso?',
                    child: body('Rastreamento, assistência 24h e proteção contra roubo e furto.'),
                  ),
                  LooviAccordion(
                    label: 'Como cancelar?',
                    child: body('Pelo app, em Perfil > Plano > Cancelar.'),
                  ),
                  const LooviAccordion(label: 'Indisponível no seu plano', disabled: true),
                ],
              ),
            );
          },
        ),
      ],
    );
