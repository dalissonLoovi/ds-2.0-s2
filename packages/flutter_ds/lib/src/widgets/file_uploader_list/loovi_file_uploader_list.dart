import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// FileUploaderList (Figma 3581:3887) — vertical stack of
/// `LooviFileUploaderItem` rows.
///
/// The Figma booleans `showFileItem02…07` only document stacking (7 fixed
/// slots); in code the app maps its files to N items ([children]).
///
/// Paint (mode app-cliente): item gap `spacing/100`; each item owns its
/// tokens. No fill, stroke or padding of its own.
///
/// Accessibility: a group named [semanticLabel]; each item keeps its own file
/// name, status and remove semantics.
class LooviFileUploaderList extends StatelessWidget {
  const LooviFileUploaderList({
    super.key,
    required this.children,
    this.semanticLabel = 'Arquivos selecionados',
  });

  /// File rows (normally `LooviFileUploaderItem`).
  final List<Widget> children;

  /// Accessible name of the group.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: t.spacing.s100),
            children[i],
          ],
        ],
      ),
    );
  }
}
