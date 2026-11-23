import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

// Expected values below are the DS contract for mode app-cliente (seed
// meta.productTheme, aliases resolved to primitives). They are test oracles,
// not styling — widgets never read them.
void main() {
  const t = LooviTokens.appCliente;
  final c = t.component;

  group('critical tokens — app-cliente', () {
    test('Button background closes on #4C6BF8 (color/actions/primary)', () {
      expect(c.button.containerBackground, const Color(0xFF4C6BF8));
      expect(c.button.containerBackground, t.color.actionsPrimary);
    });

    test('Button radius lg and sm close on border/radius/full', () {
      expect(c.button.containerRadiusLg, t.radius.full);
      expect(c.button.containerRadiusSm, t.radius.full);
      expect(t.radius.full, 9999);
    });

    test('Button label/icon are on-color, label weight medium', () {
      expect(c.button.labelColor, const Color(0xFFFFFFFF));
      expect(c.button.iconColor, t.text.onColor);
      expect(c.button.labelFontWeight, FontWeight.w500);
    });

    test('AppHeader title is body/medium regular (not heading/h3)', () {
      expect(c.appHeader.titleFontSize, 14);
      expect(c.appHeader.titleLineHeight, 20);
      expect(c.appHeader.titleFontWeight, FontWeight.w400);
    });

    test('AppHeader inverse/leading-action/avatar', () {
      expect(c.appHeader.inverseBackground, const Color(0xFF5A78FF));
      expect(c.appHeader.leadingActionBackground, const Color(0xFFE7EFFC));
      expect(c.appHeader.leadingActionRadius, t.radius.full);
      expect(c.appHeader.avatarBackground, const Color(0x29FFFFFF)); // rgba(255,255,255,0.16)
      expect(c.appHeader.avatarIconColor, const Color(0xFFFFFFFF));
    });

    test('Modal / ModalHeader / Input / List / SectionHeader radii', () {
      expect(c.modal.containerRadius, 32);
      expect(c.modalHeader.closeActionSizeMobile, 32);
      expect(c.modalHeader.closeActionRadius, t.radius.full);
      expect(c.modalHeader.closeActionBackground, t.color.backgroundSurface2);
      expect(c.input.fieldRadius, t.radius.full);
      expect(c.inputTextarea.fieldRadius, 20);
      expect(c.listAction.containerRadius, 20);
      expect(c.sectionHeader.actionBackground, const Color(0xFFE7EFFC));
      expect(c.sectionHeader.actionRadius, t.radius.full);
    });
  });

  group('modes', () {
    test('default mode is app-cliente', () {
      expect(LooviTokens.forMode().mode, LooviProductMode.appCliente);
      final theme = LooviTheme.light();
      expect(theme.extension<LooviTokens>()!.mode, LooviProductMode.appCliente);
    });

    test('site-loovi button is the green pill, not the app button', () {
      final s = LooviTokens.siteLoovi.component.button;
      expect(s.containerBackground, const Color(0xFF3AD06D));
      expect(s.labelColor, const Color(0xFF1A1E1F));
      expect(c.button.containerBackground, isNot(s.containerBackground));
    });

    test('escritorio-virtual keeps 8/6 radius', () {
      final ev = LooviTokens.escritorioVirtual.component.button;
      expect(ev.containerRadiusLg, 8);
      expect(ev.containerRadiusSm, 6);
    });
  });

  group('foundation', () {
    test('typography scale matches seed', () {
      final ty = t.typography;
      expect([ty.displayLargeRegular.fontSize, ty.displayLargeRegular.height! * 40], [40, 56]);
      expect(ty.headingH1Regular.fontSize, 32);
      expect(ty.headingH2Regular.fontSize, 24);
      expect(ty.headingH3Regular.fontSize, 20);
      expect(ty.bodyLargeRegular.fontSize, 16);
      expect(ty.bodyMediumRegular.fontSize, 14);
      expect(ty.bodySmallRegular.fontSize, 12);
      expect(ty.captionLargeRegular.fontSize, 10);
      expect(ty.captionLargeRegular.height! * 10, closeTo(14, 1e-9));
      expect(ty.bodyMediumMedium.fontWeight, FontWeight.w500);
      expect(ty.bodyMediumRegular.fontFamily, 'packages/loovi_tokens/Poppins');
      expect(ty.all.length, 50);
    });

    test('spacing, canvas, brand-muted alpha', () {
      expect(t.spacing.s200, 16);
      expect(t.spacing.s025, 2);
      expect(t.color.backgroundSurface0, const Color(0xFFFCFCFE));
      expect(t.color.backgroundSurfaceBrandMuted, const Color(0xB85A78FF)); // #5A78FFB8
    });
  });
}
