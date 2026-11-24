// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Seed `SelectCountry` (3935:5522) — Playground (knobs) + States.
WidgetbookComponent looviSelectCountryComponent() => WidgetbookComponent(
      name: 'SelectCountry',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'SelectCountry',
            child: Align(
              alignment: Alignment.centerLeft,
              child: _ToggleCountry(
                size: context.knobs.object.dropdown<LooviSelectCountrySize>(
                  label: 'size',
                  options: LooviSelectCountrySize.values,
                  labelBuilder: (v) => v.name,
                ),
                disabled: context.knobs.boolean(label: 'state=disabled'),
                countryCode: context.knobs.string(label: 'countryCode (placeholder flag)', initialValue: 'BR'),
              ),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) {
            final t = LooviTokens.of(context);
            return SeedStory(
              component: 'SelectCountry',
              showDescription: false,
              child: Wrap(
                spacing: t.spacing.s200,
                runSpacing: t.spacing.s200,
                children: [
                  for (final size in LooviSelectCountrySize.values) ...[
                    LooviSelectCountry(size: size, onPressed: () {}),
                    LooviSelectCountry(size: size, expanded: true, onPressed: () {}),
                    LooviSelectCountry(size: size, disabled: true, onPressed: () {}),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );

/// Toggles `expanded` on tap (the country list itself is screen-level).
class _ToggleCountry extends StatefulWidget {
  const _ToggleCountry({required this.size, required this.disabled, required this.countryCode});

  final LooviSelectCountrySize size;
  final bool disabled;
  final String countryCode;

  @override
  State<_ToggleCountry> createState() => _ToggleCountryState();
}

class _ToggleCountryState extends State<_ToggleCountry> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => LooviSelectCountry(
        size: widget.size,
        disabled: widget.disabled,
        expanded: _expanded,
        countryCode: widget.countryCode,
        onPressed: () => setState(() => _expanded = !_expanded),
      );
}
