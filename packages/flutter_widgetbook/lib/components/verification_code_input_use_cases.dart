import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// VerificationCodeInput — Figma 4029:835 (mode app-cliente). No hover on the app.
WidgetbookComponent looviVerificationCodeInputComponent() => WidgetbookComponent(
      name: 'VerificationCodeInput',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'VerificationCodeInput',
            child: _InteractiveCode(
              length: context.knobs.object.dropdown<int>(label: 'length (seed: 5)', options: const [5, 4, 6]),
              label: context.knobs.string(label: 'label', initialValue: 'Digite o código'),
              showLabel: context.knobs.boolean(label: 'showLabel', initialValue: true),
              error: context.knobs.boolean(label: 'error (state=error)'),
              supportingText: context.knobs.string(label: 'supportingText', initialValue: 'Código inválido. Tente novamente.'),
              showSupportingText: context.knobs.boolean(label: 'showSupportingText', initialValue: true),
              disabled: context.knobs.boolean(label: 'disabled (state=disabled)'),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) {
            final t = LooviTokens.of(context);
            Widget row(String state, String digits, {bool error = false, bool disabled = false, bool focus = false}) => Padding(
                  padding: EdgeInsets.only(bottom: t.spacing.s300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('state=$state', style: t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
                      SizedBox(height: t.spacing.s100),
                      LooviVerificationCodeInput(
                        controller: TextEditingController(text: digits),
                        error: error,
                        disabled: disabled,
                        forceFocusRing: focus,
                      ),
                    ],
                  ),
                );
            return SeedStory(
              component: 'VerificationCodeInput',
              showDescription: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  row('default', ''),
                  row('focus', '1234', focus: true),
                  row('error', '12345', error: true),
                  row('disabled', '12', disabled: true),
                ],
              ),
            );
          },
        ),
      ],
    );

/// VerificationCodeInputItem — Figma 4028:773 (mode app-cliente). Paint-only cell.
WidgetbookComponent looviVerificationCodeInputItemComponent() => WidgetbookComponent(
      name: 'VerificationCodeInputItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'VerificationCodeInputItem',
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: LooviVerificationCodeInputItem(
                digit: context.knobs.string(label: 'digit', initialValue: '1'),
                state: context.knobs.object.dropdown<LooviVerificationCodeInputItemState>(
                  label: 'state',
                  options: LooviVerificationCodeInputItemState.values,
                  labelBuilder: (v) => v == LooviVerificationCodeInputItemState.standard ? 'default' : v.name,
                ),
              ),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) {
            final t = LooviTokens.of(context);
            return SeedStory(
              component: 'VerificationCodeInputItem',
              showDescription: false,
              child: Wrap(
                spacing: t.spacing.s200,
                runSpacing: t.spacing.s200,
                children: [
                  for (final s in LooviVerificationCodeInputItemState.values)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LooviVerificationCodeInputItem(digit: '1', state: s),
                        SizedBox(height: t.spacing.s100),
                        Text(
                          s == LooviVerificationCodeInputItemState.standard ? 'default' : s.name,
                          style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );

class _InteractiveCode extends StatefulWidget {
  const _InteractiveCode({
    required this.length,
    required this.label,
    required this.showLabel,
    required this.error,
    required this.supportingText,
    required this.showSupportingText,
    required this.disabled,
  });

  final int length;
  final String label;
  final bool showLabel;
  final bool error;
  final String supportingText;
  final bool showSupportingText;
  final bool disabled;

  @override
  State<_InteractiveCode> createState() => _InteractiveCodeState();
}

class _InteractiveCodeState extends State<_InteractiveCode> {
  String _completed = '';

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LooviVerificationCodeInput(
          key: ValueKey(widget.length),
          length: widget.length,
          label: widget.label,
          showLabel: widget.showLabel,
          error: widget.error,
          supportingText: widget.supportingText,
          showSupportingText: widget.showSupportingText,
          disabled: widget.disabled,
          onChanged: (_) => setState(() => _completed = ''),
          onCompleted: (v) => setState(() => _completed = v),
        ),
        SizedBox(height: t.spacing.s200),
        Text(
          _completed.isEmpty ? 'onCompleted: —' : 'onCompleted: $_completed',
          style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary),
        ),
      ],
    );
  }
}
