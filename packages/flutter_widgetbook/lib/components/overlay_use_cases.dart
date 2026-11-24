// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Overlay (seed node 3768:3886): Playground + Variants (modal and
/// bottom-sheet, platform=mobile; same as the golden `overlay_variants.png`).
/// To present dialogs in the app use showLooviModal / showLooviBottomSheet.
WidgetbookComponent looviOverlayComponent() => WidgetbookComponent(
  name: 'Overlay',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final type = k.object.dropdown<LooviOverlayType>(
          label: 'type',
          options: LooviOverlayType.values,
          labelBuilder: (v) => v == LooviOverlayType.bottomSheet ? 'bottom-sheet' : v.name,
        );
        // Sparse matrix: bottom-sheet is published only with platform=mobile.
        final platform = type == LooviOverlayType.bottomSheet
            ? LooviOverlayPlatform.mobile
            : k.object.dropdown<LooviOverlayPlatform>(
                label: 'platform (modal only)',
                options: LooviOverlayPlatform.values,
                labelBuilder: (v) => v.name,
              );
        return SeedStory(
          component: 'Overlay',
          child: _Frame(child: _overlay(context, type, platform)),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Variants',
      builder: (context) => SeedStory(
        component: 'Overlay',
        showDescription: false,
        child: Row(
          children: [
            Expanded(child: _Frame(child: _overlay(context, LooviOverlayType.modal, LooviOverlayPlatform.mobile))),
            Expanded(
              child: _Frame(child: _overlay(context, LooviOverlayType.bottomSheet, LooviOverlayPlatform.mobile)),
            ),
          ],
        ),
      ),
    ),
  ],
);

Widget _overlay(BuildContext context, LooviOverlayType type, LooviOverlayPlatform platform) {
  final t = LooviTokens.of(context);
  final body = Text('Deseja sair?', style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary));
  return LooviOverlay(
    type: type,
    platform: platform,
    child: type == LooviOverlayType.modal
        ? LooviModal(
            title: 'Sair',
            showCloseAction: false,
            platform: platform == LooviOverlayPlatform.web ? LooviModalPlatform.web : LooviModalPlatform.mobile,
            child: body,
          )
        : LooviBottomSheet(header: LooviBottomSheetHeaderVariant.none, semanticLabel: 'Opções', child: body),
  );
}

/// Fake page (420 tall) behind the scrim.
class _Frame extends StatelessWidget {
  const _Frame({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return SizedBox(
      height: 420,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: t.color.backgroundSurface0,
            child: Padding(
              padding: EdgeInsets.all(t.spacing.s200),
              child: Text('Conteúdo da página', style: t.typography.bodyMediumRegular.copyWith(color: t.text.primary)),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
