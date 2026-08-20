import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { BreadcrumbItem } from '../BreadcrumbItem/BreadcrumbItem';
import styles from './Breadcrumb.module.css';

export type BreadcrumbSize = 'md' | 'sm';

export type BreadcrumbCrumb = {
  label: string;
  href?: string;
  current?: boolean;
};

export type BreadcrumbProps = HTMLAttributes<HTMLElement> & {
  size?: BreadcrumbSize;
  showIcon?: boolean;
  icon?: DsIconName | IconComponent | ReactNode;
  items?: BreadcrumbCrumb[];
};

const DEFAULT_ITEMS: BreadcrumbCrumb[] = [
  { label: 'Home', href: '#' },
  { label: 'Section', href: '#' },
  { label: 'Current', current: true },
];

export function Breadcrumb({
  size = 'md',
  showIcon = true,
  icon = 'home-outline',
  items = DEFAULT_ITEMS,
  className,
  ...rest
}: BreadcrumbProps) {
  const HomeIcon =
    typeof icon === 'string' || typeof icon === 'function'
      ? resolveIcon(icon as DsIconName | IconComponent)
      : null;

  return (
    <nav className={cx(styles.root, styles[`size-${size}`], className)} aria-label="Breadcrumb" {...rest}>
      <ol className={styles.list}>
        {showIcon && (
          <li className={styles.home}>
            <a href={items[0]?.href ?? '#'} aria-label={items[0]?.label ?? 'Home'}>
              {HomeIcon ? <HomeIcon size={16} aria-hidden /> : (icon as ReactNode)}
            </a>
            <span aria-hidden className={styles.slash}>
              /
            </span>
          </li>
        )}
        {items.map((item, index) => (
          <BreadcrumbItem
            key={`${item.label}-${index}`}
            size={size}
            type="link"
            state={item.current ? 'current' : 'default'}
            label={item.label}
            href={item.href}
            showSlash={!item.current}
          />
        ))}
      </ol>
    </nav>
  );
}
