import 'dart:ui' show SemanticsRole;

import 'package:material_ui/material_ui.dart';

import '../vertical_stepper_item/loovi_vertical_stepper_item.dart';

/// VerticalStepper (Figma 3833:118) — vertical ordered multi-step container
/// whose `items` SLOT takes [LooviVerticalStepperItem] rows only. Use for
/// flows that need a title/description per step (onboarding, checkout,
/// registration, document review). Not a timeline, navigation list, plain
/// List, StepperPrimary, StepProgressIndicator or FeatureSteps.
///
/// Status and `showConnector` live on each item: the container does no status
/// math (seed `statusOnItem`). Typical composition: completed, current,
/// pending, pending with `showConnector: false` on the last item.
///
/// Paint (mode app-cliente): column, gap `spacing/0`, padding `spacing/0`,
/// radius `border/radius/0`, fills the width, height hugs. No own color.
///
/// Accessibility (seed): ordered list (`SemanticsRole.list`); each item is a
/// list item announcing its status ("Etapa atual" marks the active one).
class LooviVerticalStepper extends StatelessWidget {
  const LooviVerticalStepper({super.key, required this.items, this.semanticLabel});

  /// Seed `items` SLOT.
  final List<LooviVerticalStepperItem> items;

  /// Optional accessible name of the list (e.g. "Etapas do cadastro").
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      role: SemanticsRole.list,
      label: semanticLabel,
      child: LooviVerticalStepperScope(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items,
        ),
      ),
    );
  }
}
