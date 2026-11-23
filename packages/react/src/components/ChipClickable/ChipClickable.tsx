import { forwardRef, type ButtonHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './ChipClickable.module.css';

export type ChipClickableSize = 'sm' | 'md';
export type ChipClickableState = 'default' | 'hover' | 'pressed' | 'selected' | 'disabled';
export type ChipClickableIntent =
  | 'info'
  | 'system'
  | 'success'
  | 'warning'
  | 'danger'
  | 'outline'
  | 'soft'
  | 'brand';
export type ChipClickableWidth = 'hug' | 'fill';
/** Seed axis — only affects status intents (info, system, success, warning, danger). */
export type ChipClickableEmphasis = 'primary' | 'secondary';
/**
 * @deprecated Legacy emphasis values (renamed 2026-11-23): `strong` → `primary`, `soft` → `secondary`.
 * Still accepted for backwards compatibility; will be removed in a future major.
 */
export type ChipClickableLegacyEmphasis = 'strong' | 'soft';

const LEGACY_EMPHASIS: Record<ChipClickableLegacyEmphasis, ChipClickableEmphasis> = {
  strong: 'primary',
  soft: 'secondary',
};

/** Normalizes deprecated `strong` / `soft` to `primary` / `secondary`. */
export function normalizeChipClickableEmphasis(
  emphasis: ChipClickableEmphasis | ChipClickableLegacyEmphasis,
): ChipClickableEmphasis {
  return (LEGACY_EMPHASIS as Record<string, ChipClickableEmphasis>)[emphasis] ?? emphasis;
}

export type ChipClickableProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'disabled'> & {
  size?: ChipClickableSize;
  state?: ChipClickableState;
  intent?: ChipClickableIntent;
  width?: ChipClickableWidth;
  /**
   * `secondary` (default since 2026-11-23) = color/background-feedback-secondary/{intent} (soft fill);
   * `primary` (opt-in) = color/background-feedback-primary/{intent} (danger → interactive/error-surface).
   * Ignored by outline / soft / brand. `strong` / `soft` are deprecated aliases.
   */
  emphasis?: ChipClickableEmphasis | ChipClickableLegacyEmphasis;
  label?: string;
  showLeadingIcon?: boolean;
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  showDeleteAction?: boolean;
  showAvatar?: boolean;
  disabled?: boolean;
  selected?: boolean;
  onDelete?: () => void;
};

const STATUS_INTENTS = new Set<ChipClickableIntent>(['info', 'system', 'success', 'warning', 'danger']);

export const ChipClickable = forwardRef<HTMLButtonElement, ChipClickableProps>(
  function ChipClickable(
    {
      size = 'md',
      state = 'default',
      intent = 'outline',
      width = 'hug',
      emphasis: emphasisProp = 'secondary',
      label = 'Label',
      showLeadingIcon = false,
      leadingIcon = 'plus-outline',
      showDeleteAction = false,
      showAvatar = false,
      disabled = false,
      selected = false,
      onDelete,
      onKeyDown,
      className,
      style,
      type = 'button',
      ...rest
    },
    ref,
  ) {
    const isDisabled = disabled || state === 'disabled';
    const isSelected = selected || state === 'selected';
    const isStatus = STATUS_INTENTS.has(intent);
    const emphasis = normalizeChipClickableEmphasis(emphasisProp);
    const Icon =
      typeof leadingIcon === 'string' || typeof leadingIcon === 'function'
        ? resolveIcon(leadingIcon as DsIconName | IconComponent)
        : null;
    const DeleteIcon = resolveIcon('x-outline');
    const leadingNode =
      showLeadingIcon &&
      (Icon ? (
        <Icon size={size === 'sm' ? 20 : 24} aria-hidden className={styles.icon} />
      ) : (
        (leadingIcon as ReactNode)
      ));

    /*
     * Structure (least-breaking choice, 2026-11-23):
     * - showDeleteAction=false (the common case): unchanged — a single <button> that receives
     *   `ref`, `className`, `style` and every other prop.
     * - showDeleteAction=true: a nested interactive control inside <button> is invalid, so the
     *   chip becomes a <span data-part="chip"> wrapper (the visual chip: chip classes + consumer
     *   `className` / `style`, since that is what consumers style today) holding two SIBLING
     *   buttons — the main chip action (keeps `ref`, `type`, aria-pressed, handlers and the rest
     *   of the props, so ref.current is always the chip <button>) and the delete <button>.
     *   The main action's ::after is stretched over the whole wrapper so the full chip stays clickable.
     */
    const chipClasses = cx(
      styles.root,
      styles[`size-${size}`],
      styles[`intent-${intent}`],
      styles[`width-${width}`],
      isStatus && styles.status,
      isStatus && styles[`emphasis-${emphasis}`],
      isSelected && styles.selected,
      showAvatar && styles.hasAvatar,
      className,
    );
    const handleKeyDown: ChipClickableProps['onKeyDown'] = (e) => {
      onKeyDown?.(e);
      if (
        !e.defaultPrevented &&
        showDeleteAction &&
        onDelete &&
        (e.key === 'Delete' || e.key === 'Backspace')
      ) {
        e.preventDefault();
        onDelete();
      }
    };
    const content = (
      <>
        {showAvatar && <span className={styles.avatar} aria-hidden />}
        {leadingNode}
        <span className={styles.label}>{label}</span>
      </>
    );
    const dataAttrs = {
      'data-intent': intent,
      'data-emphasis': isStatus ? emphasis : undefined,
      'data-state': state,
    };

    if (!showDeleteAction || !DeleteIcon) {
      return (
        <button
          ref={ref}
          type={type}
          className={chipClasses}
          style={style}
          disabled={isDisabled}
          aria-pressed={isSelected || undefined}
          {...dataAttrs}
          onKeyDown={handleKeyDown}
          {...rest}
        >
          {content}
        </button>
      );
    }

    return (
      <span
        className={cx(chipClasses, styles.withDelete, isDisabled && styles.isDisabled)}
        style={style}
        data-part="chip"
        {...dataAttrs}
      >
        <button
          ref={ref}
          type={type}
          className={styles.mainAction}
          disabled={isDisabled}
          aria-pressed={isSelected || undefined}
          onKeyDown={handleKeyDown}
          {...rest}
        >
          {content}
        </button>
        {/*
         * deleteAction: real sibling <button>, 16×16 visually (Figma); `.delete::before` extends
         * the hit area to 24×24 (WCAG 2.5.8) without changing the chip size.
         */}
        <button
          type="button"
          className={styles.delete}
          aria-label={`Remover ${label}`}
          data-part="delete-action"
          disabled={isDisabled}
          onClick={() => onDelete?.()}
        >
          <DeleteIcon size={16} aria-hidden />
        </button>
      </span>
    );
  },
);

ChipClickable.displayName = 'ChipClickable';
