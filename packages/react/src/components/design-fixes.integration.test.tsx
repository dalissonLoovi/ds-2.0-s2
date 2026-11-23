import { describe, expect, it, vi, afterEach } from 'vitest';
import { cleanup, render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './Button/Button';
import { Alert } from './Alert/Alert';
import { Modal } from './Modal/Modal';
import { RadioButton } from './RadioButton/RadioButton';
import { RadioButtonCard } from './RadioButtonCard/RadioButtonCard';
import radioCardCss from './RadioButtonCard/RadioButtonCard.module.css?raw';
import { NavigationBarItem } from './NavigationBarItem/NavigationBarItem';
import { AppHeader } from './AppHeader/AppHeader';
import buttonCss from './Button/Button.module.css?raw';
import radioCss from './RadioButton/RadioButton.module.css?raw';
import alertCss from './Alert/Alert.module.css?raw';
import bannerCss from './Banner/Banner.module.css?raw';
import navItemCss from './NavigationBarItem/NavigationBarItem.module.css?raw';
import appHeaderCss from './AppHeader/AppHeader.module.css?raw';

afterEach(() => cleanup());

/** Returns the declaration block of the first rule whose selector list contains `selector`. */
function ruleBody(css: string, selector: string): string {
  const idx = css.indexOf(selector);
  if (idx < 0) return '';
  const open = css.indexOf('{', idx);
  const close = css.indexOf('}', open);
  return css.slice(open + 1, close);
}

describe('Button appearance (2026-11-23-design-fixes)', () => {
  it('applies inverse on outline/text + primary', () => {
    render(
      <>
        <Button variant="outline" appearance="inverse" label="Outline" />
        <Button variant="text" appearance="inverse" label="Text" />
      </>,
    );
    for (const name of ['Outline', 'Text']) {
      const btn = screen.getByRole('button', { name });
      expect(btn).toHaveAttribute('data-appearance', 'inverse');
      expect(btn.className).toMatch(/appearance-inverse/);
    }
  });

  it('defaults to appearance=default', () => {
    render(<Button variant="outline" label="Save" />);
    expect(screen.getByRole('button', { name: 'Save' })).toHaveAttribute(
      'data-appearance',
      'default',
    );
  });

  it('ignores inverse on solid and on non-primary intents', () => {
    render(
      <>
        <Button variant="solid" appearance="inverse" label="Solid" />
        <Button variant="outline" intent="danger" appearance="inverse" label="Danger" />
      </>,
    );
    for (const name of ['Solid', 'Danger']) {
      const btn = screen.getByRole('button', { name });
      expect(btn).toHaveAttribute('data-appearance', 'default');
      expect(btn.className).not.toMatch(/appearance-inverse/);
    }
  });

  it('paints inverse with on-color tokens and elevation/inverse-4 pressed', () => {
    expect(ruleBody(buttonCss, '.variant-outline.intent-primary.appearance-inverse {')).toContain(
      'var(--text-on-color)',
    );
    expect(ruleBody(buttonCss, '.appearance-inverse.state-pressed')).toContain(
      'var(--color-elevation-inverse-4)',
    );
    expect(ruleBody(buttonCss, '.appearance-inverse:disabled')).toContain(
      'var(--text-on-color-disabled)',
    );
  });
});

describe('Button intents (2026-11-23-design-fixes)', () => {
  it('outline/text danger label uses text/danger class; solid does not', () => {
    render(
      <>
        <Button variant="outline" intent="danger" label="Outline danger" />
        <Button variant="text" intent="danger" label="Text danger" />
        <Button variant="solid" intent="danger" label="Solid danger" />
      </>,
    );
    expect(screen.getByText('Outline danger').className).toMatch(/labelDanger/);
    expect(screen.getByText('Text danger').className).toMatch(/labelDanger/);
    expect(screen.getByText('Solid danger').className).not.toMatch(/labelDanger/);
    expect(ruleBody(buttonCss, '.labelDanger')).toContain('var(--text-danger)');
  });

  it('solid success fills with color/actions/success + text/on-color', () => {
    const body = ruleBody(buttonCss, '.intent-success {');
    expect(body).toContain('--btn-bg: var(--color-actions-success)');
    expect(body).toContain('--btn-fg: var(--text-on-color)');
  });

  it('solid danger uses text/on-color; solid secondary uses text/primary', () => {
    expect(ruleBody(buttonCss, '.intent-danger {')).toContain('--btn-fg: var(--text-on-color)');
    expect(ruleBody(buttonCss, '.intent-secondary {')).toContain('--btn-fg: var(--text-primary)');
  });

  it('solid hover/selected/pressed darken toward interactive/overlay (8/12/16%)', () => {
    expect(ruleBody(buttonCss, '.variant-solid.state-hover {')).toContain(
      'color-mix(in srgb, var(--btn-bg) 92%, var(--interactive-overlay, #474747) 8%)',
    );
    expect(ruleBody(buttonCss, '.variant-solid.state-selected {')).toContain(
      'color-mix(in srgb, var(--btn-bg) 88%, var(--interactive-overlay, #474747) 12%)',
    );
    expect(ruleBody(buttonCss, '.variant-solid:active:not(:disabled)')).toContain(
      'color-mix(in srgb, var(--btn-bg) 84%, var(--interactive-overlay, #474747) 16%)',
    );
    // Never lighten the solid fill with the near-white interactive/hover token.
    expect(buttonCss).not.toMatch(/var\(--btn-bg\)[^;]*var\(--interactive-hover/);
  });

  it('solid state classes apply for every intent', () => {
    render(
      <>
        {(['primary', 'secondary', 'success', 'danger'] as const).map((intent) => (
          <Button key={intent} intent={intent} state="selected" label={intent} />
        ))}
      </>,
    );
    for (const intent of ['primary', 'secondary', 'success', 'danger']) {
      const btn = screen.getByRole('button', { name: intent });
      expect(btn.className).toMatch(/variant-solid/);
      expect(btn.className).toMatch(/state-selected/);
    }
  });

  it('inverse hover uses the elevation/inverse-4 layer (consistent with pressed)', () => {
    expect(ruleBody(buttonCss, '.appearance-inverse.state-hover {')).toContain(
      'var(--color-elevation-inverse-4) 50%',
    );
  });
});

describe('Alert close (2026-11-23-design-fixes)', () => {
  it('hides close by default', () => {
    render(<Alert title="Saved" showAction={false} />);
    expect(screen.queryByRole('button', { name: 'Fechar alerta' })).not.toBeInTheDocument();
  });

  it('renders close with aria-label and calls onClose', async () => {
    const user = userEvent.setup();
    const onClose = vi.fn();
    render(<Alert title="Saved" showAction={false} showClose onClose={onClose} />);
    const close = screen.getByRole('button', { name: 'Fechar alerta' });
    expect(close).toHaveAttribute('data-appearance', 'default');
    await user.click(close);
    expect(onClose).toHaveBeenCalledTimes(1);
  });

  it('uses Button appearance=inverse for action and close on inverse alerts', () => {
    render(
      <Alert appearance="inverse" status="danger" actionLabel="Retry" showClose title="Oops" />,
    );
    const alert = screen.getByRole('status');
    expect(within(alert).getByRole('button', { name: 'Retry' })).toHaveAttribute(
      'data-appearance',
      'inverse',
    );
    expect(within(alert).getByRole('button', { name: 'Fechar alerta' })).toHaveAttribute(
      'data-appearance',
      'inverse',
    );
  });
});

describe('Alert layout + colours (2026-11-23-design-fixes)', () => {
  it('matches Figma spacing, radius and default fill', () => {
    const root = ruleBody(alertCss, '.root {');
    expect(root).toContain('--alert-pad-top: var(--spacing-150');
    expect(root).toContain('--alert-pad-side: var(--spacing-250');
    expect(root).toContain('gap: var(--spacing-100');
    expect(root).toContain('border-radius: var(--border-radius-400');
    expect(root).toContain('background: var(--color-background-surface-3)');
    expect(ruleBody(alertCss, '.body {')).toContain('gap: var(--spacing-150');
    expect(ruleBody(alertCss, '.copy {')).toContain('gap: var(--spacing-100');
    expect(ruleBody(alertCss, '.description {')).toContain('var(--text-secondary)');
  });

  it('inverse = brand-strong + elevation/inverse-3 @ 48%; on-color / on-color-disabled copy', () => {
    const inv = ruleBody(alertCss, '.appearance-inverse {');
    expect(inv).toContain('var(--color-background-surface-brand-strong)');
    expect(inv).toContain('color-mix(in srgb, var(--color-elevation-inverse-3) 48%, transparent)');
    expect(ruleBody(alertCss, '.appearance-inverse .title {')).toContain('var(--text-on-color)');
    expect(ruleBody(alertCss, '.appearance-inverse .description {')).toContain(
      'var(--text-on-color-disabled)',
    );
  });

  it('status icon is feedback/{status} in both appearances; system has no icon', () => {
    expect(ruleBody(alertCss, '.status-info .icon {')).toContain('var(--feedback-info)');
    expect(alertCss).not.toMatch(/\.appearance-inverse \.icon/);
    const { container } = render(<Alert status="system" title="Sys" showAction={false} />);
    expect(container.querySelector('svg')).toBeNull();
  });

  it('action = outline sm intent=primary (border/1 + text/primary on default)', () => {
    render(
      <>
        <Alert status="danger" actionLabel="Default action" title="A" />
        <Alert appearance="inverse" status="danger" actionLabel="Inverse action" title="B" />
      </>,
    );
    const def = screen.getByRole('button', { name: 'Default action' });
    expect(def).toHaveAttribute('data-variant', 'outline');
    expect(def).toHaveAttribute('data-size', 'sm');
    expect(def).toHaveAttribute('data-intent', 'primary');
    expect(def).toHaveAttribute('data-appearance', 'default');
    const inv = screen.getByRole('button', { name: 'Inverse action' });
    expect(inv).toHaveAttribute('data-intent', 'primary');
    expect(inv).toHaveAttribute('data-appearance', 'inverse');
    const action = ruleBody(alertCss, '.appearance-default .action {');
    expect(action).toContain('--btn-border: var(--color-border-1)');
    expect(action).toContain('--btn-fg: var(--text-primary)');
  });
});

describe('Banner info (2026-11-23-design-fixes)', () => {
  it('status=info emphasis=primary uses background-feedback-primary/info', () => {
    expect(ruleBody(bannerCss, '.emphasis-primary.status-info {')).toContain(
      'var(--color-background-feedback-primary-info)',
    );
  });
});

describe('NavigationBarItem colours (2026-11-23-design-fixes)', () => {
  it('selected label is text/primary on default; badge count text/primary on tangerine-1', () => {
    render(<NavigationBarItem href="#" label="Inicio" selected badge="count" count="3" />);
    expect(screen.getByRole('link')).toHaveAttribute('aria-current', 'page');
    expect(ruleBody(navItemCss, '.selected:not(.appearance-inverse) .label {')).toContain(
      'var(--text-primary)',
    );
    const badge = ruleBody(navItemCss, '.iconWrap .badge {');
    expect(badge).toContain('var(--text-primary)');
    expect(badge).toContain('var(--color-palette-tangerine-1');
    expect(navItemCss).not.toMatch(/badge[^}]*text-secondary/);
  });
});

describe('AppHeader small-centered (2026-11-23-design-fixes)', () => {
  it('centers the title on the full width with a 1fr auto 1fr grid', () => {
    const { container } = render(
      <AppHeader hierarchy="specific" layout="small-centered" title="Centro" showSecondTrailingAction />,
    );
    const header = container.querySelector('header')!;
    expect(header.className).toMatch(/centeredTitle/);
    const children = Array.from(header.children);
    expect(children).toHaveLength(3);
    expect(children[1]).toHaveAttribute('data-part', 'title');
    expect(children[1]).toHaveTextContent('Centro');
    expect(ruleBody(appHeaderCss, '.centeredTitle {')).toContain(
      'grid-template-columns: minmax(0, 1fr) minmax(0, auto) minmax(0, 1fr)',
    );
  });

  it('keeps the left-aligned layouts unchanged', () => {
    const { container } = render(<AppHeader hierarchy="specific" layout="medium" title="T" />);
    expect(container.querySelector('header')!.className).not.toMatch(/centeredTitle/);
    expect(container.querySelector('[data-part="title"]')).toBeNull();
  });
});

describe('Modal footer (2026-11-23-design-fixes)', () => {
  it('renders built-in actions with showFooter (web → lg)', async () => {
    const user = userEvent.setup();
    const onPrimary = vi.fn();
    render(
      <Modal open title="Confirm" showFooter onPrimaryAction={onPrimary}>
        Body
      </Modal>,
    );
    const primary = screen.getByRole('button', { name: 'Confirmar' });
    expect(primary).toHaveAttribute('data-size', 'lg');
    expect(primary).toHaveAttribute('data-variant', 'solid');
    expect(screen.getByRole('button', { name: 'Cancelar' })).toHaveAttribute('data-variant', 'text');
    await user.click(primary);
    expect(onPrimary).toHaveBeenCalledTimes(1);
  });

  it('uses size=md on mobile and hides footer by default', () => {
    const { rerender } = render(
      <Modal open title="T" platform="mobile" showFooter primaryActionLabel="OK">
        Body
      </Modal>,
    );
    expect(screen.getByRole('button', { name: 'OK' })).toHaveAttribute('data-size', 'md');
    rerender(
      <Modal open title="T" platform="mobile">
        Body
      </Modal>,
    );
    expect(screen.queryByRole('button', { name: 'OK' })).not.toBeInTheDocument();
  });

  it('keeps DOM (focus) order = visual order: web secondary→primary, mobile primary→secondary', () => {
    const footerButtons = () =>
      Array.from(document.querySelectorAll('footer button')).map((b) => b.textContent);
    const { rerender } = render(
      <Modal open title="T" showCloseAction={false} showFooter>
        Body
      </Modal>,
    );
    expect(footerButtons()).toEqual(['Cancelar', 'Confirmar']);
    expect(document.querySelector('footer')!.className).not.toMatch(/footerStacked/);

    for (const platform of ['mobile', 'mobile-landscape'] as const) {
      rerender(
        <Modal open title="T" platform={platform} showCloseAction={false} showFooter>
          Body
        </Modal>,
      );
      expect(footerButtons()).toEqual(['Confirmar', 'Cancelar']);
      expect(document.querySelector('footer')!.className).toMatch(/footerStacked/);
    }
  });

  it('custom footer overrides showFooter and keeps the row layout', () => {
    render(
      <Modal open title="T" platform="mobile" showFooter footer={<button type="button">Custom</button>}>
        Body
      </Modal>,
    );
    expect(screen.queryByRole('button', { name: 'Confirmar' })).not.toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Custom' })).toBeInTheDocument();
    expect(document.querySelector('footer')!.className).not.toMatch(/footerStacked/);
  });
});

describe('RadioButton checked indicator (2026-11-23-design-fixes)', () => {
  it('checked = thick ring (border/width/050) with no center dot', () => {
    const { container } = render(<RadioButton name="c" label="On" checked readOnly />);
    const ring = container.querySelector('span[aria-hidden]')!;
    expect(ring.children).toHaveLength(0);
    expect(radioCss).not.toMatch(/\.dot\b/);
    const checked = ruleBody(radioCss, '.input:checked + .radio {');
    expect(checked).toContain('var(--border-width-050');
    expect(checked).toContain('var(--color-actions-primary)');
  });
});

describe('RadioButtonCard checked indicator (2026-11-23-design-fixes)', () => {
  it('checked = 4px ring, no dot; disabled checked = text/placeholder ring', () => {
    const { container } = render(<RadioButtonCard name="rc" label="Card" checked readOnly />);
    // The ring is the aria-hidden span right after the input (stateLayer is a separate span).
    const ring = container.querySelector('input + span[aria-hidden]')!;
    expect(ring).not.toBeNull();
    expect(ring.children).toHaveLength(0);
    expect(radioCardCss).not.toMatch(/\.dot\b/);
    const checked = ruleBody(radioCardCss, '.input:checked + .radio {');
    expect(checked).toContain('var(--border-width-050');
    expect(checked).toContain('var(--color-actions-primary)');
    const disabledChecked = ruleBody(radioCardCss, '.input:disabled:checked + .radio {');
    expect(disabledChecked).toContain('var(--border-width-050');
    expect(disabledChecked).toContain('var(--text-placeholder)');
    expect(ruleBody(radioCardCss, '.input:disabled + .radio {')).toContain('var(--color-border-2)');
  });
});

describe('RadioButton disabled (2026-11-23-design-fixes)', () => {
  it('distinguishes disabled checked vs unchecked', () => {
    render(
      <>
        <RadioButton name="a" label="On" disabled checked readOnly />
        <RadioButton name="b" label="Off" disabled checked={false} readOnly />
      </>,
    );
    const on = screen.getByLabelText('On');
    const off = screen.getByLabelText('Off');
    expect(on).toBeDisabled();
    expect(on).toBeChecked();
    expect(off).toBeDisabled();
    expect(off).not.toBeChecked();
    expect(on.closest('label')).toHaveAttribute('data-checked', 'true');
    expect(off.closest('label')).toHaveAttribute('data-checked', 'false');

    const checkedRule = ruleBody(radioCss, '.input:disabled:checked + .radio {');
    expect(checkedRule).toContain('var(--border-width-050');
    expect(checkedRule).toContain('var(--text-placeholder)');
    const uncheckedRule = ruleBody(radioCss, '.input:disabled + .radio {');
    expect(uncheckedRule).toContain('var(--border-width-025');
    expect(uncheckedRule).toContain('var(--color-border-2)');
  });
});
