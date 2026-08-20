import type { AnchorHTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { Badge } from '../Badge/Badge';
import styles from './NavigationRailCompactItem.module.css';

export type NavigationRailCompactItemAppearance = 'default' | 'inverse';
export type NavigationRailCompactItemState = 'default' | 'hover' | 'focus' | 'pressed';
export type NavigationRailCompactItemBadge = 'none' | 'count' | 'dot';

export type NavigationRailCompactItemProps = Omit<
  AnchorHTMLAttributes<HTMLAnchorElement>,
  'href'
> & {
  href?: string;
  icon?: DsIconName | IconComponent | ReactNode;
  label?: string;
  appearance?: NavigationRailCompactItemAppearance;
  state?: NavigationRailCompactItemState;
  badge?: NavigationRailCompactItemBadge;
  selected?: boolean;
  showLabel?: boolean;
  count?: number | string;
  overflowLabel?: string;
};

export function NavigationRailCompactItem({
  href = '#',
  icon = 'home-outline',
  label = 'Label',
  appearance = 'default',
  state = 'default',
  badge = 'none',
  selected = false,
  showLabel = true,
  count = 1,
  overflowLabel = '99+',
  className,
  ...rest
}: NavigationRailCompactItemProps) {
  const Icon =
    typeof icon === 'string' || typeof icon === 'function'
      ? resolveIcon(icon as DsIconName | IconComponent)
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
      aria-label={showLabel ? undefined : label}
      data-appearance={appearance}
      data-state={state}
      data-selected={selected}
      {...rest}
    >
      <span className={styles.iconWrap}>
        {Icon ? <Icon size={24} aria-hidden /> : <span aria-hidden>{icon as ReactNode}</span>}
        {badge !== 'none' && (
          <Badge
            className={styles.badge}
            size="sm"
            content={badge === 'dot' ? 'dot' : Number(count) > 99 ? 'overflow' : 'count'}
            count={count}
            overflowLabel={overflowLabel}
          />
        )}
      </span>
      {showLabel && <span className={styles.label}>{label}</span>}
    </a>
  );
}
