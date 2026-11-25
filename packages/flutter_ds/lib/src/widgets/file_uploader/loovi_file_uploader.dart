import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';
import '../file_uploader_dropzone_item/loovi_file_uploader_dropzone_item.dart';
import '../file_uploader_item/loovi_file_uploader_item.dart';
import '../file_uploader_list/loovi_file_uploader_list.dart';

/// Seed `FileUploader.variant`. `default` is a reserved word in Dart, so the
/// seed value `default` maps to [standard] (Button trigger);
/// `drag-and-drop` → [dragAndDrop] (dropzone trigger).
enum LooviFileUploaderVariant { standard, dragAndDrop }

/// Seed `FileUploader.size`: nested Button size (1:1) and FileUploaderItem
/// density.
enum LooviFileUploaderSize { sm, md, lg }

/// Seed `FileUploader.state`. `default` → [standard].
enum LooviFileUploaderState { standard, disabled, skeleton }

/// One file shown by [LooviFileUploader] (rendered as a
/// `LooviFileUploaderItem` at the uploader size).
@immutable
class LooviFileUploaderFile {
  const LooviFileUploaderFile({
    required this.fileName,
    this.state = LooviFileUploaderItemState.uploaded,
    this.shortDescription = '',
    this.longDescription = '',
    this.id,
  });

  final String fileName;
  final LooviFileUploaderItemState state;
  final String shortDescription;
  final String longDescription;

  /// Optional app identifier (handy in [LooviFileUploader.onRemove]).
  final Object? id;
}

/// FileUploader (Figma 3581:4454) — upload field: header (label +
/// description), a trigger (Button or dropzone) and the list of files.
///
/// The package does not pick nor upload files: [onPick] asks the app to open
/// its picker; the app feeds [files] back with each file's state and handles
/// [onRemove].
///
/// Paint (mode app-cliente):
/// - root: padding `spacing/200` × `spacing/100`, gap `spacing/200`, radius
///   `border/radius/200`, no fill.
/// - header (gap `spacing/200`): label `body/medium/semi-bold` `text/primary`;
///   description `body/small/regular` `text/secondary`; disabled both
///   `text/placeholder`.
/// - variant=default: `LooviButton` solid / primary, size 1:1, leading icon
///   `upload-outline`, label [actionLabel] ("Subir arquivo"), hugs.
/// - variant=drag-and-drop: `LooviFileUploaderDropzoneItem`.
/// - files: `LooviFileUploaderList` of `LooviFileUploaderItem` (size 1:1),
///   only on state=default with [showFiles]; disabled hard-hides it.
/// - skeleton (bones only, non-interactive): root fill
///   `interactive/disabled-surface`; bones `color/background-surface/0`, radius
///   `border/radius/200`: label 64 × 8 (`spacing/800` × `spacing/100`),
///   description 160 × 8 (2 × `spacing/1000`, frame not tokenized), action
///   40 × 40 (`spacing/500`).
class LooviFileUploader extends StatelessWidget {
  const LooviFileUploader({
    super.key,
    required this.label,
    required this.onPick,
    this.description = '',
    this.variant = LooviFileUploaderVariant.standard,
    this.size = LooviFileUploaderSize.lg,
    this.state = LooviFileUploaderState.standard,
    this.showFiles = true,
    this.files = const [],
    this.onRemove,
    this.actionLabel = 'Subir arquivo',
    this.dropzoneHelperText = 'Toque para selecionar o arquivo.',
    this.listSemanticLabel = 'Arquivos selecionados',
    this.skeletonSemanticLabel = 'Carregando',
  });

  /// Seed `label`.
  final String label;

  /// Seed `description` (limits / formats). Empty = hidden.
  final String description;

  /// Called by the Button / dropzone: the app opens its file picker.
  final VoidCallback? onPick;

  final LooviFileUploaderVariant variant;
  final LooviFileUploaderSize size;
  final LooviFileUploaderState state;

  /// Seed `showFiles` (only wired on state=default — seed rule).
  final bool showFiles;

  /// Files to list (seed React `files`).
  final List<LooviFileUploaderFile> files;

  /// Remove action of a file row. Null = rows are not removable.
  final ValueChanged<LooviFileUploaderFile>? onRemove;

  /// Button label on variant=default (Figma "Subir arquivo").
  final String actionLabel;

  /// Dropzone instruction on variant=drag-and-drop.
  final String dropzoneHelperText;

  /// Accessible name of the file list.
  final String listSemanticLabel;

  /// Announced while state=skeleton.
  final String skeletonSemanticLabel;

  LooviButtonSize get _buttonSize => switch (size) {
        LooviFileUploaderSize.lg => LooviButtonSize.lg,
        LooviFileUploaderSize.md => LooviButtonSize.md,
        LooviFileUploaderSize.sm => LooviButtonSize.sm,
      };

  LooviFileUploaderItemSize get _itemSize => switch (size) {
        LooviFileUploaderSize.lg => LooviFileUploaderItemSize.lg,
        LooviFileUploaderSize.md => LooviFileUploaderItemSize.md,
        LooviFileUploaderSize.sm => LooviFileUploaderItemSize.sm,
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final radius = BorderRadius.circular(t.radius.s200);
    final padding = EdgeInsets.symmetric(horizontal: t.spacing.s200, vertical: t.spacing.s100);

    if (state == LooviFileUploaderState.skeleton) {
      Widget bone(double w, double h) => DecoratedBox(
            decoration: BoxDecoration(color: t.color.backgroundSurface0, borderRadius: radius),
            child: SizedBox(width: w, height: h),
          );
      return Semantics(
        container: true,
        label: skeletonSemanticLabel,
        child: ExcludeSemantics(
          child: DecoratedBox(
            key: const Key('loovi-file-uploader-skeleton'),
            decoration: BoxDecoration(color: t.interactive.disabledSurface, borderRadius: radius),
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  bone(t.spacing.s800, t.spacing.s100),
                  SizedBox(height: t.spacing.s200),
                  // Figma 160 has no spacing token: 2 × spacing/1000.
                  bone(t.spacing.s1000 * 2, t.spacing.s100),
                  SizedBox(height: t.spacing.s200),
                  bone(t.spacing.s500, t.spacing.s500),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final disabled = state == LooviFileUploaderState.disabled;
    final labelColor = disabled ? t.text.placeholder : t.text.primary;
    final descriptionColor = disabled ? t.text.placeholder : t.text.secondary;

    final children = <Widget>[
      Text(label, style: t.typography.bodyMediumSemiBold.copyWith(color: labelColor)),
      if (description.isNotEmpty) ...[
        SizedBox(height: t.spacing.s200),
        Text(description, style: t.typography.bodySmallRegular.copyWith(color: descriptionColor)),
      ],
      SizedBox(height: t.spacing.s200),
      if (variant == LooviFileUploaderVariant.standard)
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: LooviButton(
            label: actionLabel,
            onPressed: onPick,
            size: _buttonSize,
            showIcon: true,
            leadingIcon: LooviIcons.uploadOutline,
            disabled: disabled,
          ),
        )
      else
        LooviFileUploaderDropzoneItem(
          onPick: onPick,
          helperText: dropzoneHelperText,
          disabled: disabled,
        ),
      if (!disabled && showFiles && files.isNotEmpty) ...[
        SizedBox(height: t.spacing.s200),
        LooviFileUploaderList(
          semanticLabel: listSemanticLabel,
          children: [
            for (final f in files)
              LooviFileUploaderItem(
                key: f.id == null ? null : ValueKey(f.id),
                fileName: f.fileName,
                size: _itemSize,
                state: f.state,
                shortDescription: f.shortDescription,
                longDescription: f.longDescription,
                onRemove: onRemove == null ? null : () => onRemove!(f),
              ),
          ],
        ),
      ],
    ];

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
