import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { ListItem } from '../ListItem/ListItem';
import styles from './List.module.css';

export type ListType = 'plain' | 'dropdown';

export type ListProps = HTMLAttributes<HTMLUListElement> & {
  type?: ListType;
  showScroll?: boolean;
  children?: ReactNode;
};

export function List({
  type = 'dropdown',
  showScroll = false,
  children,
  className,
  ...rest
}: ListProps) {
  const menu = type === 'dropdown';

  return (
    <ul
      className={cx(styles.root, menu && styles.dropdown, showScroll && styles.scroll, className)}
      role={menu ? 'menu' : 'list'}
      data-type={type}
      data-show-scroll={showScroll}
      {...rest}
    >
      {children ?? (
        <>
          <ListItem headline="Headline 1" />
          <ListItem headline="Headline 2" />
          <ListItem headline="Headline 3" />
        </>
      )}
    </ul>
  );
}
