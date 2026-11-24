import { createRef } from 'react';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { cleanup, fireEvent, render, screen } from '@testing-library/react';
import { ChipTag } from './ChipTag/ChipTag';
import { ChipClickable } from './ChipClickable/ChipClickable';
import { Banner } from './Banner/Banner';
import chipTagStyles from './ChipTag/ChipTag.module.css';
import chipClickableStyles from './ChipClickable/ChipClickable.module.css';
import bannerStyles from './Banner/Banner.module.css';
import chipTagCss from './ChipTag/ChipTag.module.css?raw';
import chipClickableCss from './ChipClickable/ChipClickable.module.css?raw';

/** Returns the declaration block of the first rule whose selector list contains `selector`. */
function ruleBody(css: string, selector: string): string {
  const idx = css.indexOf(selector);
  if (idx < 0) return '';
  const open = css.indexOf('{', idx);
  const close = css.indexOf('}', open);
  return css.slice(open + 1, close);
}

afterEach(() => cleanup());

const STATUS = ['info', 'system', 'success', 'warning', 'danger'] as const;

describe('ChipTag emphasis', () => {
  it('defaults to secondary (soft fill) since 2026-11-23', () => {
    render(<ChipTag label="Tag" intent="success" />);
    const chip = screen.getByText('Tag').parentElement!;
    expect(chip).toHaveAttribute('data-emphasis', 'secondary');
    expect(chip).toHaveClass(chipTagStyles['emphasis-secondary']);
  });

  it('renders primary (strong fill) when opted in', () => {
    render(<ChipTag label="Strong" intent="success" emphasis="primary" />);
    const chip = screen.getByText('Strong').parentElement!;
    expect(chip).toHaveAttribute('data-emphasis', 'primary');
    expect(chip).toHaveClass(chipTagStyles['emphasis-primary']);
  });

  it('icon/avatar sizes follow the seed: sm 20/20, md icon 32 · avatar 24', () => {
    expect(ruleBody(chipTagCss, '.size-sm .icon {')).toContain('var(--spacing-250, 20px)');
    expect(ruleBody(chipTagCss, '.size-md .icon {')).toContain('var(--spacing-400, 32px)');
    expect(ruleBody(chipTagCss, '.size-sm .avatar {')).toContain('var(--spacing-250, 20px)');
    expect(ruleBody(chipTagCss, '.size-md .avatar {')).toContain('var(--spacing-300, 24px)');
    const { container } = render(
      <>
        <ChipTag size="sm" label="S" showLeadingIcon />
        <ChipTag size="md" label="M" showLeadingIcon />
      </>,
    );
    const svgs = container.querySelectorAll('svg');
    expect(svgs[0]).toHaveAttribute('width', '20');
    expect(svgs[1]).toHaveAttribute('width', '32');
  });

  it('brand fills with surface/brand-strong + text/on-color regardless of emphasis', () => {
    const body = ruleBody(chipTagCss, '.intent-brand {');
    expect(body).toContain('var(--color-background-surface-brand-strong');
    expect(body).toContain('var(--text-on-color)');
    expect(chipTagCss).not.toContain('--color-background-surface-brand,');
    expect(chipTagCss).not.toContain('surface-brand-muted');
  });

  it.each(STATUS)('renders secondary for intent=%s', (intent) => {
    render(<ChipTag label={intent} intent={intent} emphasis="secondary" />);
    const chip = screen.getByText(intent).parentElement!;
    expect(chip).toHaveAttribute('data-emphasis', 'secondary');
    expect(chip).toHaveClass(chipTagStyles['emphasis-secondary']);
    expect(chip).toHaveClass(chipTagStyles[`intent-${intent}`]);
  });

  it.each([
    ['strong', 'primary'],
    ['soft', 'secondary'],
  ] as const)('maps deprecated emphasis=%s to %s', (legacy, normalized) => {
    render(<ChipTag label="Legacy" intent="warning" emphasis={legacy} />);
    const chip = screen.getByText('Legacy').parentElement!;
    expect(chip).toHaveAttribute('data-emphasis', normalized);
    expect(chip).toHaveClass(chipTagStyles[`emphasis-${normalized}`]);
  });
});

describe('ChipClickable emphasis', () => {
  it('defaults to secondary on status intents since 2026-11-23', () => {
    render(<ChipClickable label="Ok" intent="success" />);
    const btn = screen.getByRole('button', { name: 'Ok' });
    expect(btn).toHaveAttribute('data-emphasis', 'secondary');
    expect(btn).toHaveClass(chipClickableStyles['emphasis-secondary']);
  });

  it('renders primary when opted in', () => {
    render(<ChipClickable label="Ok" intent="success" emphasis="primary" />);
    const btn = screen.getByRole('button', { name: 'Ok' });
    expect(btn).toHaveAttribute('data-emphasis', 'primary');
    expect(btn).toHaveClass(chipClickableStyles['emphasis-primary']);
  });

  it.each([
    ['strong', 'primary'],
    ['soft', 'secondary'],
  ] as const)('maps deprecated emphasis=%s to %s', (legacy, normalized) => {
    render(<ChipClickable label="Legacy" intent="warning" emphasis={legacy} />);
    const btn = screen.getByRole('button', { name: 'Legacy' });
    expect(btn).toHaveAttribute('data-emphasis', normalized);
    expect(btn).toHaveClass(chipClickableStyles[`emphasis-${normalized}`]);
  });

  it('brand fills with surface/brand-strong + text/on-color', () => {
    const body = ruleBody(chipClickableCss, '.intent-brand {');
    expect(body).toContain('var(--color-background-surface-brand-strong');
    expect(body).toContain('var(--text-on-color)');
  });

  it.each(STATUS)('renders secondary for intent=%s (incl. selected state)', (intent) => {
    render(<ChipClickable label={intent} intent={intent} emphasis="secondary" state="selected" />);
    const btn = screen.getByRole('button', { name: intent });
    expect(btn).toHaveAttribute('data-emphasis', 'secondary');
    expect(btn).toHaveClass(chipClickableStyles['emphasis-secondary']);
    expect(btn).toHaveClass(chipClickableStyles.status);
    expect(btn).toHaveAttribute('aria-pressed', 'true');
  });

  it.each(['outline', 'soft', 'brand'] as const)('ignores emphasis on intent=%s', (intent) => {
    render(<ChipClickable label={intent} intent={intent} emphasis="secondary" />);
    const btn = screen.getByRole('button', { name: intent });
    expect(btn).not.toHaveAttribute('data-emphasis');
    expect(btn).not.toHaveClass(chipClickableStyles['emphasis-secondary']);
  });
});

describe('ChipClickable avatar + deleteAction (2026-11-23)', () => {
  it('avatar is bound to spacing tokens: sm 20, md 32; sm chip with avatar = 28', () => {
    expect(ruleBody(chipClickableCss, '.size-sm .avatar {')).toContain('var(--spacing-250, 20px)');
    expect(ruleBody(chipClickableCss, '.size-md .avatar {')).toContain('var(--spacing-400, 32px)');
    expect(ruleBody(chipClickableCss, '.size-sm.hasAvatar {')).toContain('min-height: 28px');
    render(<ChipClickable size="sm" label="Maria" showAvatar />);
    expect(screen.getByRole('button', { name: 'Maria' })).toHaveClass(chipClickableStyles.hasAvatar);
  });

  it('deleteAction is 16×16 with an invisible ≥ 24×24 hit area', () => {
    // Anchor on the dedicated `.delete {` rule (not the shared `.icon,\n.delete {` one).
    const box = ruleBody(chipClickableCss, '.delete {\n  position: relative;');
    expect(box).toContain('width: 16px');
    expect(box).toContain('height: 16px');
    expect(ruleBody(chipClickableCss, '.delete::before {')).toContain('inset: -4px');
  });

  it('names the delete action "Remover {label}" and calls onDelete without activating the chip', () => {
    const onDelete = vi.fn();
    const onClick = vi.fn();
    render(
      <ChipClickable label="Placa ABC" showDeleteAction onDelete={onDelete} onClick={onClick} />,
    );
    const del = screen.getByRole('button', { name: 'Remover Placa ABC' });
    fireEvent.click(del);
    expect(onDelete).toHaveBeenCalledTimes(1);
    expect(onClick).not.toHaveBeenCalled();
  });

  it('delete is a real sibling <button>, never nested inside the chip <button>', () => {
    const ref = createRef<HTMLButtonElement>();
    const { container } = render(
      <ChipClickable
        ref={ref}
        className="consumer"
        style={{ marginTop: 3 }}
        label="Placa"
        showDeleteAction
        onDelete={() => undefined}
      />,
    );
    const wrapper = container.firstElementChild as HTMLElement;
    expect(wrapper.tagName).toBe('SPAN');
    expect(wrapper).toHaveAttribute('data-part', 'chip');
    // className/style go to the wrapper (the visual chip); ref stays on the chip <button>.
    expect(wrapper).toHaveClass('consumer', chipClickableStyles.root);
    expect(wrapper.style.marginTop).toBe('3px');
    const main = screen.getByRole('button', { name: 'Placa' });
    const del = screen.getByRole('button', { name: 'Remover Placa' });
    expect(ref.current).toBe(main);
    expect(del.tagName).toBe('BUTTON');
    expect(del).toHaveAttribute('type', 'button');
    expect(main.parentElement).toBe(wrapper);
    expect(del.parentElement).toBe(wrapper);
    expect(container.querySelector('button button')).toBeNull();
  });

  it('without delete the chip stays a single <button> with ref + className (unchanged API)', () => {
    const ref = createRef<HTMLButtonElement>();
    const { container } = render(<ChipClickable ref={ref} className="consumer" label="Solo" />);
    const btn = screen.getByRole('button', { name: 'Solo' });
    expect(container.firstElementChild).toBe(btn);
    expect(ref.current).toBe(btn);
    expect(btn).toHaveClass('consumer', chipClickableStyles.root);
  });

  it('disables both buttons when the chip is disabled', () => {
    const onDelete = vi.fn();
    render(<ChipClickable label="Off" disabled showDeleteAction onDelete={onDelete} />);
    expect(screen.getByRole('button', { name: 'Off' })).toBeDisabled();
    const del = screen.getByRole('button', { name: 'Remover Off' });
    expect(del).toBeDisabled();
    fireEvent.click(del);
    expect(onDelete).not.toHaveBeenCalled();
  });

  it('Delete / Backspace on the focused chip triggers onDelete', () => {
    const onDelete = vi.fn();
    render(<ChipClickable label="Tag" showDeleteAction onDelete={onDelete} />);
    const chip = screen.getByRole('button', { name: /^Tag/ });
    fireEvent.keyDown(chip, { key: 'Delete' });
    fireEvent.keyDown(chip, { key: 'Backspace' });
    fireEvent.keyDown(chip, { key: 'Enter' });
    expect(onDelete).toHaveBeenCalledTimes(2);
  });
});

describe('Banner emphasis', () => {
  it('defaults to primary', () => {
    render(<Banner status="success" message="Saved" />);
    const banner = screen.getByRole('status');
    expect(banner).toHaveAttribute('data-emphasis', 'primary');
    expect(banner).toHaveClass(bannerStyles['emphasis-primary']);
  });

  it.each(['success', 'warning', 'info', 'danger'] as const)(
    'renders secondary for status=%s',
    (status) => {
      render(<Banner status={status} emphasis="secondary" message={status} />);
      const banner = screen.getByText(status).closest('[data-status]')!;
      expect(banner).toHaveAttribute('data-emphasis', 'secondary');
      expect(banner).toHaveClass(bannerStyles['emphasis-secondary']);
      expect(banner).toHaveClass(bannerStyles[`status-${status}`]);
    },
  );

  it('danger action is intent=primary (text/primary) on both fills — Figma, 2026-11-24', () => {
    render(
      <>
        <Banner status="danger" emphasis="primary" showAction actionLabel="Primary fill" />
        <Banner status="danger" emphasis="secondary" showAction actionLabel="Secondary fill" />
      </>,
    );
    expect(screen.getByRole('button', { name: 'Primary fill' })).toHaveAttribute(
      'data-intent',
      'primary',
    );
    expect(screen.getByRole('button', { name: 'Secondary fill' })).toHaveAttribute(
      'data-intent',
      'primary',
    );
  });
});
