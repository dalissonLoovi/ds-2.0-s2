import type { AnchorHTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './Link.module.css';

export type LinkSize = 'lg' | 'md' | 'sm';
export type LinkState = 'default' | 'hover' | 'focus' | 'active' | 'visited' | 'disabled';
export type LinkAppearance = 'default' | 'inverse';

export type LinkProps = Omit<AnchorHTMLAttributes<HTMLAnchorElement>, 'href'> & {
  href?: string;
  size?: LinkSize;
  state?: LinkState;
  appearance?: LinkAppearance;
  label?: string;
  inline?: boolean;
  showIcon?: boolean;
  trailingIcon?: DsIconName | IconComponent | ReactNode;
  disabled?: boolean;
};

export function Link({
  href = '#',
  size = 'md',
  state = 'default',
  appearance = 'default',
  label = 'Link',
  inline = false,
  showIcon = true,
  trailingIcon = 'arrow-narrow-right-outline',
  disabled = false,
  className,
  children,
  onClick,
  ...rest
}: LinkProps) {
  const isDisabled = disabled || state === 'disabled';
  const showTrailing = !inline && showIcon;
  const Icon =
    typeof trailingIcon === 'string' || typeof trailingIcon === 'function'
      ? resolveIcon(trailingIcon as DsIconName | IconComponent)
      : null;

  return (
    <a
      className={cx(
        styles.root,
        styles[`size-${size}`],
        styles[`appearance-${appearance}`],
        state !== 'default' && styles[`state-${state}`],
        inline && styles.inline,
        isDisabled && styles.disabled,
        className,
      )}
      href={href}
      aria-disabled={isDisabled || undefined}
      tabIndex={isDisabled ? -1 : undefined}
      data-size={size}
      data-state={isDisabled ? 'disabled' : state}
      data-appearance={appearance}
      data-inline={inline || undefined}
      onClick={(event) => {
        if (isDisabled) {
          event.preventDefault();
          return;
        }
        onClick?.(event);
      }}
      {...rest}
    >
      <span className={styles.label}>{children ?? label}</span>
      {showTrailing &&
        (Icon ? (
          <Icon size={size === 'sm' ? 14 : 16} aria-hidden className={styles.icon} />
        ) : (
          (trailingIcon as ReactNode)
        ))}
    </a>
  );
}
