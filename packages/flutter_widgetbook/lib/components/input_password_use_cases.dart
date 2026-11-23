// Direct src imports until lib/loovi_ds.dart exports the Input family (wave integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'input_use_cases.dart' show inputSurface;
import 'seed_header.dart';

/// Seed `InputPassword` (3950:1701) — Playground (knobs) + States.
WidgetbookComponent looviInputPasswordComponent() => WidgetbookComponent(
      name: 'InputPassword',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final appearance = context.knobs.object.dropdown<LooviInputAppearance>(
              label: 'appearance',
              options: LooviInputAppearance.values,
              labelBuilder: (v) => v == LooviInputAppearance.standard ? 'default' : v.name,
            );
            final field = LooviInputPassword(
              label: context.knobs.string(label: 'label', initialValue: 'Senha'),
              placeholder: context.knobs.stringOrNull(label: 'placeholder', initialValue: 'Digite sua senha'),
              supportingText: context.knobs.string(label: 'supportingText', initialValue: 'Use pelo menos 8 caracteres.'),
              showSupportingText: context.knobs.boolean(label: 'showSupportingText'),
              error: context.knobs.boolean(label: 'state=error'),
              enabled: !context.knobs.boolean(label: 'state=disabled'),
              appearance: appearance,
              leadingIcon: context.knobs.boolean(label: 'leadingIcon', initialValue: true),
            );
            return SeedStory(component: 'InputPassword', child: inputSurface(context, appearance, field));
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) => SeedStory(
            component: 'InputPassword',
            showDescription: false,
            child: _PasswordStatesStory(),
          ),
        ),
      ],
    );

class _PasswordStatesStory extends StatefulWidget {
  @override
  State<_PasswordStatesStory> createState() => _PasswordStatesStoryState();
}

class _PasswordStatesStoryState extends State<_PasswordStatesStory> {
  late final List<TextEditingController> _c = List.generate(5, (_) => TextEditingController(text: 'minhasenha12'));

  @override
  void dispose() {
    for (final c in _c) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final gap = SizedBox(height: t.spacing.s200);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LooviInputPassword(),
        gap,
        LooviInputPassword(label: 'visibility=hidden', controller: _c[0]),
        gap,
        LooviInputPassword(label: 'visibility=visible', controller: _c[1], visibility: LooviInputPasswordVisibility.visible),
        gap,
        LooviInputPassword(label: 'state=error', controller: _c[2], errorText: 'Senha incorreta. Confira e tente de novo.'),
        gap,
        LooviInputPassword(label: 'state=disabled', controller: _c[3], enabled: false),
        gap,
        inputSurface(
          context,
          LooviInputAppearance.inverse,
          LooviInputPassword(label: 'appearance=inverse', controller: _c[4], appearance: LooviInputAppearance.inverse),
        ),
      ],
    );
  }
}
