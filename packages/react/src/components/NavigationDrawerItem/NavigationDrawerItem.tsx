import type { AnchorHTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { Badge } from '../Badge/Badge';
import styles from './NavigationDrawerItem.module.css';

export type NavigationDrawerItemAppearance = 'default' | 'inverse';
export type NavigationDrawerItemState = 'default' | 'hover' | 'focus' | 'pressed';

export type NavigationDrawerItemProps = Omit<AnchorHTMLAttributes<HTMLAnchorElement>, 'href'> & {
  href?: string;
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  showLeadingIcon?: boolean;
  showBadge?: boolean;
  badgeLabel?: string;
  label?: string;
  appearance?: NavigationDrawerItemAppearance;
  state?: NavigationDrawerItemState;
  selected?: boolean;
};

export function NavigationDrawerItem({
  href = '#',
  leadingIcon = 'home-outline',
  showLeadingIcon = true,
  showBadge = false,
  badgeLabel = '3',
  label = 'Label',
  appearance = 'default',
  state = 'default',
  selected = false,
  className,
  ...rest
}: NavigationDrawerItemProps) {
  const Icon =
    typeof leadingIcon === 'string' || typeof leadingIcon === 'function'
      ? resolveIcon(leadingIcon as DsIconName | IconComponent)
      : null;

  return (
    <a
      className={cx(
        styles.root,
        styles[`appearance-${appearance}`],
        styles[`state-${state}`],
        selected && styles.selected,
        className,
      )}
      href={href}
      aria-current={selected ? 'page' : undefined}
      data-appearance={appearance}
      data-state={state}
      data-selected={selected}
      {...rest}
    >
      {showLeadingIcon && (
        <span className={styles.icon} aria-hidden>
          {Icon ? <Icon size={20} /> : (leadingIcon as ReactNode)}
        </span>
      )}
      <span className={styles.label}>{label}</span>
      {showBadge && (
        <Badge size="sm" content="count" count={badgeLabel} aria-label={`${badgeLabel} notifications`} />
      )}
    </a>
  );
}
