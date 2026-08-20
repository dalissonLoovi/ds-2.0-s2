import type { HTMLAttributes, MouseEventHandler } from 'react';
import { cx } from '../../utils/cx';
import styles from './BreadcrumbItem.module.css';

export type BreadcrumbItemSize = 'sm' | 'md';
export type BreadcrumbItemType = 'link' | 'overflow';
export type BreadcrumbItemState =
  | 'default'
  | 'hover'
  | 'focus'
  | 'pressed'
  | 'current'
  | 'skeleton'
  | 'open';

export type BreadcrumbItemProps = HTMLAttributes<HTMLElement> & {
  label?: string;
  size?: BreadcrumbItemSize;
  type?: BreadcrumbItemType;
  state?: BreadcrumbItemState;
  showSlash?: boolean;
  href?: string;
};

export function BreadcrumbItem({
  label = 'Page',
  size = 'md',
  type = 'link',
  state = 'default',
  showSlash = true,
  href = '#',
  className,
  onClick,
  ...rest
}: BreadcrumbItemProps) {
  const current = state === 'current';
  const skeleton = state === 'skeleton';
  const overflow = type === 'overflow';
  const open = state === 'open';
  const content = skeleton ? <span className={styles.skeleton} aria-hidden /> : label;
  const classes = cx(
    styles.root,
    styles[`size-${size}`],
    styles[`state-${state}`],
    current && styles.current,
    className,
  );

  return (
    <li className={styles.item} {...rest}>
      {overflow ? (
        <button
          type="button"
          className={classes}
          aria-expanded={open || undefined}
          aria-label="More breadcrumb items"
          disabled={skeleton}
          onClick={onClick as MouseEventHandler<HTMLButtonElement>}
        >
          {content || '…'}
        </button>
      ) : current || skeleton ? (
        <span className={classes} aria-current={current ? 'page' : undefined} aria-hidden={skeleton || undefined}>
          {content}
        </span>
      ) : (
        <a className={classes} href={href} onClick={onClick as MouseEventHandler<HTMLAnchorElement>}>
          {content}
        </a>
      )}
      {showSlash && !current && !skeleton && (
        <span className={styles.slash} aria-hidden>
          /
        </span>
      )}
    </li>
  );
}
