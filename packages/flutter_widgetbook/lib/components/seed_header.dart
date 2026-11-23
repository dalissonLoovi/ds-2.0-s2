import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

/// Story frame: seed name, Figma nodeId and AI-READY description on top,
/// the widget below. Text comes from [LooviSeedCatalog] (generated).
class SeedStory extends StatelessWidget {
  const SeedStory({super.key, required this.component, required this.child, this.showDescription = true});

  final String component;
  final Widget child;
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final seed = LooviSeedCatalog.of(component);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: ListView(
        padding: EdgeInsets.all(t.spacing.s200),
        children: [
          Text('${seed.name} · node ${seed.nodeId}', style: t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
          if (showDescription) ...[
            SizedBox(height: t.spacing.s050),
            Text(seed.description, maxLines: 4, overflow: TextOverflow.ellipsis, style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
          ],
          SizedBox(height: t.spacing.s300),
          child,
        ],
      ),
    );
  }
}
