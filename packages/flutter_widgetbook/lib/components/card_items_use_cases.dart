// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

Widget _demo(BuildContext context) {
  final t = LooviTokens.of(context);
  return SizedBox(
    height: t.spacing.s1000,
    child: Center(
      child: Text('Content', style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary)),
    ),
  );
}

WidgetbookUseCase _playground(String seed, Widget Function(BuildContext, bool dragged, bool showFocus, bool pressable) build) =>
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        return SeedStory(
          component: seed,
          child: build(
            context,
            k.boolean(label: 'dragged (state=dragged)'),
            k.boolean(label: 'showFocusIndicator', initialValue: true),
            k.boolean(label: 'onPressed (pressed / focus at runtime)', initialValue: true),
          ),
        );
      },
    );

/// CardOutlinedItem (seed node 4170:4552).
WidgetbookComponent looviCardOutlinedItemComponent() => WidgetbookComponent(
      name: 'CardOutlinedItem',
      useCases: [
        _playground(
          'CardOutlinedItem',
          (context, dragged, showFocus, pressable) => LooviCardOutlinedItem(
            dragged: dragged,
            showFocusIndicator: showFocus,
            onPressed: pressable ? () {} : null,
            semanticLabel: 'Card',
            child: _demo(context),
          ),
        ),
      ],
    );

/// CardElevatedItem (seed node 4170:4564).
WidgetbookComponent looviCardElevatedItemComponent() => WidgetbookComponent(
      name: 'CardElevatedItem',
      useCases: [
        _playground(
          'CardElevatedItem',
          (context, dragged, showFocus, pressable) => LooviCardElevatedItem(
            dragged: dragged,
            showFocusIndicator: showFocus,
            onPressed: pressable ? () {} : null,
            semanticLabel: 'Card',
            child: _demo(context),
          ),
        ),
      ],
    );

/// CardFilledItem (seed node 4170:4576).
WidgetbookComponent looviCardFilledItemComponent() => WidgetbookComponent(
      name: 'CardFilledItem',
      useCases: [
        _playground(
          'CardFilledItem',
          (context, dragged, showFocus, pressable) => LooviCardFilledItem(
            dragged: dragged,
            showFocusIndicator: showFocus,
            onPressed: pressable ? () {} : null,
            semanticLabel: 'Card',
            child: _demo(context),
          ),
        ),
      ],
    );
