import type { AnchorHTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { Badge } from '../Badge/Badge';
import styles from './NavigationRailExpandedItem.module.css';

export type NavigationRailExpandedItemAppearance = 'default' | 'inverse';
export type NavigationRailExpandedItemState = 'default' | 'hover' | 'focus' | 'pressed';
export type NavigationRailExpandedItemHierarchy = 'default' | 'nav-tree';
export type NavigationRailExpandedItemBadge = 'none' | 'count' | 'dot';

export type NavigationRailExpandedItemProps = Omit<
  AnchorHTMLAttributes<HTMLAnchorElement>,
  'href'
> & {
  href?: string;
  icon?: DsIconName | IconComponent | ReactNode;
  label?: string;
  appearance?: NavigationRailExpandedItemAppearance;
  state?: NavigationRailExpandedItemState;
  hierarchy?: NavigationRailExpandedItemHierarchy;
  badge?: NavigationRailExpandedItemBadge;
  selected?: boolean;
  count?: number | string;
  overflowLabel?: string;
};

export function NavigationRailExpandedItem({
  href = '#',
  icon = 'home-outline',
  label = 'Label',
  appearance = 'default',
  state = 'default',
  hierarchy = 'default',
  badge = 'none',
  selected = false,
  count = 1,
  overflowLabel = '99+',
  className,
  ...rest
}: NavigationRailExpandedItemProps) {
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
        styles[`hierarchy-${hierarchy}`],
        selected && styles.selected,
        className,
      )}
      href={href}
      aria-current={selected ? 'page' : undefined}
      data-appearance={appearance}
      data-state={state}
      data-hierarchy={hierarchy}
      data-selected={selected}
      {...rest}
    >
      <span className={styles.icon} aria-hidden>
        {Icon ? <Icon size={20} /> : (icon as ReactNode)}
      </span>
      <span className={styles.label}>{label}</span>
      {badge !== 'none' && (
        <Badge
          size="sm"
          content={badge === 'dot' ? 'dot' : Number(count) > 99 ? 'overflow' : 'count'}
          count={count}
          overflowLabel={overflowLabel}
        />
      )}
    </a>
  );
}
