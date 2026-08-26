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
      data-state={isLoading ? 'loading' : state}
      {...rest}
    >
      {isLoading ? (
        renderIconSlot('loader-outline', iconSize, cx(styles.icon, styles.spinner))
      ) : (
        <>
          {showIcon && renderIconSlot(icon, iconSize, styles.icon)}
          {visibleLabel && <span className={styles.label}>{labelText}</span>}
          {showTrailingIcon && renderIconSlot(trailingIcon, iconSize, styles.icon)}
        </>
      )}
    </button>
  );
});

Button.displayName = 'Button';
