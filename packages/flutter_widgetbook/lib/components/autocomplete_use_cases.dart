// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'input_use_cases.dart' show inputSurface;
import 'seed_header.dart';

const _vehicles = ['Chevrolet Onix', 'Chevrolet Tracker', 'Fiat Argo', 'Hyundai HB20', 'Volkswagen Polo'];

/// Seed `Autocomplete` (3918:573) — Playground (knobs, with an external
/// option list as the screen would compose it) + States.
WidgetbookComponent looviAutocompleteComponent() => WidgetbookComponent(
      name: 'Autocomplete',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final appearance = k.object.dropdown<LooviInputAppearance>(
              label: 'appearance',
              options: LooviInputAppearance.values,
              labelBuilder: (v) => v == LooviInputAppearance.standard ? 'default' : v.name,
            );
            return SeedStory(
              component: 'Autocomplete',
              child: _Playground(
                appearance: appearance,
                label: k.string(label: 'label', initialValue: 'Veículo'),
                placeholder: k.string(label: 'placeholder', initialValue: 'Digite para buscar'),
                supportingText: k.string(label: 'supportingText', initialValue: 'Digite para filtrar as opções'),
                showSupportingText: k.boolean(label: 'showSupportingText'),
                error: k.boolean(label: 'state=error'),
                enabled: !k.boolean(label: 'state=disabled'),
                showLeadingIcon: k.boolean(label: 'showLeadingIcon', initialValue: true),
                showClearAction: k.boolean(label: 'showClearAction', initialValue: true),
                loading: k.boolean(label: 'loading'),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) {
            final t = LooviTokens.of(context);
            final gap = SizedBox(height: t.spacing.s200);
            return SeedStory(
              component: 'Autocomplete',
              showDescription: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LooviAutocomplete(),
                  gap,
                  const LooviAutocomplete(selectedValue: 'Chevrolet Onix'),
                  gap,
                  const LooviAutocomplete(selectedValue: 'Chevrolet Onix', loading: true),
                  gap,
                  const LooviAutocomplete(selectedValue: 'Chevrolet Onix', errorText: 'Selecione um veículo da lista'),
                  gap,
                  const LooviAutocomplete(selectedValue: 'Chevrolet Onix', enabled: false),
                  gap,
                  inputSurface(
                    context,
                    LooviInputAppearance.inverse,
                    const LooviAutocomplete(selectedValue: 'Chevrolet Onix', appearance: LooviInputAppearance.inverse),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );

class _Playground extends StatefulWidget {
  const _Playground({
    required this.appearance,
    required this.label,
    required this.placeholder,
    required this.supportingText,
    required this.showSupportingText,
    required this.error,
    required this.enabled,
    required this.showLeadingIcon,
    required this.showClearAction,
    required this.loading,
  });

  final LooviInputAppearance appearance;
  final String label;
  final String placeholder;
  final String supportingText;
  final bool showSupportingText;
  final bool error;
  final bool enabled;
  final bool showLeadingIcon;
  final bool showClearAction;
  final bool loading;

  @override
  State<_Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<_Playground> {
  final _controller = TextEditingController();
  bool _expanded = false;
  String? _selected;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final query = _controller.text.toLowerCase();
    final options = _vehicles.where((v) => v.toLowerCase().contains(query) && v != _selected).toList();
    return inputSurface(
      context,
      widget.appearance,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LooviAutocomplete(
            label: widget.label,
            placeholder: widget.placeholder,
            supportingText: widget.supportingText,
            showSupportingText: widget.showSupportingText,
            error: widget.error,
            enabled: widget.enabled,
            appearance: widget.appearance,
            showLeadingIcon: widget.showLeadingIcon,
            showClearAction: widget.showClearAction,
            loading: widget.loading,
            controller: _controller,
            selectedValue: _selected,
            expanded: _expanded,
            onExpandedChange: (v) => setState(() => _expanded = v),
            onChanged: (_) => setState(() {}),
            onClear: () => setState(() => _selected = null),
          ),
          // The option list is screen-level (ListActionDropdown is not nested).
          if (_expanded && widget.enabled && options.isNotEmpty) ...[
            SizedBox(height: t.spacing.s050),
            LooviList(
              children: [
                for (final o in options)
                  LooviListItem(
                    headline: o,
                    condition: LooviListItemCondition.oneLine,
                    onTap: () => setState(() {
                      _selected = o;
                      _expanded = false;
                    }),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
