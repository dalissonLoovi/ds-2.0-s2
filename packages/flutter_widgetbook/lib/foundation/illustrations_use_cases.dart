import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

/// Illustrations (Figma page "Ilustrações e animações" 4326:1764) —
/// a name picker plus the full grid, grouped by family.
WidgetbookComponent illustrationsComponent() => WidgetbookComponent(
      name: 'Illustrations',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final name = context.knobs.object.dropdown<String>(
              label: 'name',
              options: LooviIllustrations.all,
              initialOption: LooviIllustrations.claimReasonTheft,
              labelBuilder: (v) => v,
            );
            final width = context.knobs.double.slider(label: 'width', initialValue: 208, min: 32, max: 520);
            final spec = LooviIllustrations.specOf(name)!;
            final t = LooviTokens.of(context);
            return ColoredBox(
              color: t.color.backgroundSurface0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LooviIllustration(name, width: width),
                    SizedBox(height: t.spacing.s200),
                    Text(
                      '$name · ${spec.width.toStringAsFixed(0)} × ${spec.height.toStringAsFixed(0)} · node ${spec.nodeId}',
                      style: t.typography.bodySmallRegular.copyWith(color: t.text.secondary),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(name: 'Gallery', builder: (context) => const _IllustrationGallery()),
      ],
    );

class _IllustrationGallery extends StatelessWidget {
  const _IllustrationGallery();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final groups = <String, List<String>>{};
    for (final n in LooviIllustrations.all) {
      groups.putIfAbsent(n.split('/').first, () => []).add(n);
    }
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: ListView(
        padding: EdgeInsets.all(t.spacing.s200),
        children: [
          for (final entry in groups.entries) ...[
            Padding(
              padding: EdgeInsets.only(top: t.spacing.s300, bottom: t.spacing.s100),
              child: Text(entry.key, style: t.typography.headingH3Medium.copyWith(color: t.text.primary)),
            ),
            Wrap(
              spacing: t.spacing.s200,
              runSpacing: t.spacing.s200,
              children: [
                for (final n in entry.value)
                  SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        LooviIllustration(n, width: 120, height: 120),
                        SizedBox(height: t.spacing.s050),
                        Text(
                          n.split('/').last,
                          textAlign: TextAlign.center,
                          style: t.typography.bodySmallRegular.copyWith(color: t.text.secondary),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
