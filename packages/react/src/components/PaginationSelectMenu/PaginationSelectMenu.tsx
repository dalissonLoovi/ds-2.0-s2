import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { PaginationSelectMenuItem } from '../PaginationSelectMenuItem/PaginationSelectMenuItem';
import styles from './PaginationSelectMenu.module.css';

export type PaginationSelectMenuProps = HTMLAttributes<HTMLDivElement> & {
  showScroll?: boolean;
  children?: ReactNode;
};

const DEMO = ['10', '20', '30', '40', '50'];

export function PaginationSelectMenu({
  showScroll = false,
  children,
  className,
  ...rest
}: PaginationSelectMenuProps) {
  return (
    <div
      className={cx(styles.root, showScroll && styles.scroll, className)}
      role="listbox"
      data-show-scroll={showScroll}
      {...rest}
    >
      {children ??
        DEMO.map((value, index) => (
          <PaginationSelectMenuItem key={value} label={value} state={index === 0 ? 'selected' : 'default'} />
        ))}
    </div>
  );
}
