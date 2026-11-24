// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _results = ['Apólice', 'Boleto', 'Carro reserva', 'Documentos', 'Endereço'];

/// Seed `SearchViewFullscreen` (3883:16492) — Playground (knobs, filters a
/// sample result list) inside a phone-height frame.
WidgetbookComponent looviSearchViewFullscreenComponent() => WidgetbookComponent(
      name: 'SearchViewFullscreen',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'SearchViewFullscreen',
              child: SizedBox(
                height: 520,
                child: _Playground(
                  placeholder: k.string(label: 'placeholder', initialValue: 'Pesquisar'),
                  showBack: k.boolean(label: 'showBack', initialValue: true),
                  showClear: k.boolean(label: 'showClear', initialValue: true),
                  showResults: k.boolean(label: 'showResults', initialValue: true),
                ),
              ),
            );
          },
        ),
      ],
    );

class _Playground extends StatefulWidget {
  const _Playground({
    required this.placeholder,
    required this.showBack,
    required this.showClear,
    required this.showResults,
  });

  final String placeholder;
  final bool showBack;
  final bool showClear;
  final bool showResults;

  @override
  State<_Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<_Playground> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _controller.text.toLowerCase();
    return LooviSearchViewFullscreen(
      controller: _controller,
      autofocus: false,
      useSafeArea: false,
      placeholder: widget.placeholder,
      showBack: widget.showBack,
      showClear: widget.showClear,
      showResults: widget.showResults,
      onBack: () {},
      onChanged: (_) => setState(() {}),
      items: [
        for (final r in _results.where((r) => r.toLowerCase().contains(q)))
          LooviListItem(
            headline: r,
            supportingText: 'Toque para abrir',
            condition: LooviListItemCondition.twoLine,
            leading: LooviListItemMonogram(r[0]),
            onTap: () {},
          ),
      ],
    );
  }
}
