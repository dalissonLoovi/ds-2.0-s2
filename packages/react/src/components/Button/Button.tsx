import {
  forwardRef,
  type ButtonHTMLAttributes,
  type ReactNode,
} from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './Button.module.css';

export type ButtonVariant = 'solid' | 'outline' | 'text';
export type ButtonSize = 'sm' | 'md' | 'lg';
export type ButtonIntent = 'primary' | 'success' | 'danger' | 'secondary';
export type ButtonAppearance = 'default' | 'inverse';
export type ButtonState =
  | 'default'
  | 'hover'
  | 'focus'
  | 'pressed'
  | 'selected'
  | 'loading';

export type ButtonProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'disabled'> & {
  variant?: ButtonVariant;
  size?: ButtonSize;
  intent?: ButtonIntent;
  /**
   * Surface appearance. `inverse` repaints label, icons and outline stroke with
   * `text/on-color` for dark/brand surfaces (e.g. the action of Alert `appearance="inverse"`).
   *
   * Only takes effect for `variant="outline" | "text"` with `intent="primary"`;
   * it is ignored (falls back to `default`) for `solid` and for other intents.
   * The effective value is exposed as `data-appearance`.
   * @default 'default'
   */
  appearance?: ButtonAppearance;
  /** Visual/demo state; prefer controlled loading/disabled for runtime. */
  state?: ButtonState;
  disabled?: boolean;
  loading?: boolean;
  label?: string;
  showLabel?: boolean;
  showIcon?: boolean;
  showTrailingIcon?: boolean;
  icon?: DsIconName | IconComponent | ReactNode;
  trailingIcon?: DsIconName | IconComponent | ReactNode;
};

function renderIconSlot(
  icon: ButtonProps['icon'],
  size: number,
  className: string,
): ReactNode {
  if (icon == null) return null;
  if (typeof icon === 'string' || typeof icon === 'function') {
    const Comp = resolveIcon(icon as DsIconName | IconComponent);
    return Comp ? <Comp className={className} size={size} aria-hidden /> : null;
  }
  return <span className={className}>{icon}</span>;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  {
    variant = 'solid',
    size = 'md',
    intent = 'primary',
    appearance = 'default',
    state = 'default',
    disabled = false,
    loading = false,
    label = 'Label',
    showLabel = true,
    showIcon = false,
    showTrailingIcon = false,
    icon = 'plus-outline',
    trailingIcon = 'chevron-right-outline',
    className,
    type = 'button',
    children,
    'aria-label': ariaLabel,
    ...rest
  },
  ref,
) {
  const isLoading = loading || state === 'loading';
  const visibleLabel = showLabel && !isLoading;
  const labelText = children ?? label;
  const resolvedAriaLabel = ariaLabel ?? (isLoading || !showLabel ? String(labelText) : undefined);

  const effectiveAppearance: ButtonAppearance =
    appearance === 'inverse' && variant !== 'solid' && intent === 'primary' ? 'inverse' : 'default';
  // outline|text + danger: label uses text/danger (AA); icons keep color/actions/danger.
  const dangerLabel = variant !== 'solid' && intent === 'danger';

  const iconSize = size === 'sm' ? 16 : size === 'lg' ? 24 : 20;

  return (
    <button
      ref={ref}
      type={type}
      className={cx(
        styles.root,
        styles[`variant-${variant}`],
        styles[`size-${size}`],
        styles[`intent-${intent}`],
        effectiveAppearance === 'inverse' && styles['appearance-inverse'],
        isLoading && styles.stateLoading,
        state !== 'default' && !isLoading && styles[`state-${state}`],
        className,
      )}
      disabled={disabled || isLoading}
      aria-busy={isLoading || undefined}
      aria-disabled={disabled || undefined}
      aria-label={resolvedAriaLabel}
      data-variant={variant}
      data-size={size}
      data-intent={intent}
      data-appearance={effectiveAppearance}
      data-state={isLoading ? 'loading' : state}
      {...rest}
    >
      {isLoading ? (
        <span className={styles.spinnerSlot} aria-hidden data-testid="button-spinner">
          {renderIconSlot('loader-outline', iconSize, styles.spinnerIcon)}
        </span>
      ) : (
        <>
          {showIcon && renderIconSlot(icon, iconSize, styles.icon)}
          {visibleLabel && <span className={cx(styles.label, dangerLabel && styles.labelDanger)}>{labelText}</span>}
          {showTrailingIcon && renderIconSlot(trailingIcon, iconSize, styles.icon)}
        </>
      )}
    </button>
  );
});

Button.displayName = 'Button';
