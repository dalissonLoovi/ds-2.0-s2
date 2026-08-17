import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './PaginationSelectMenu.module.css';

export type PaginationSelectMenuProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function PaginationSelectMenu({

  label = 'PaginationSelectMenu',
  children,
  className,
  ...rest
}: PaginationSelectMenuProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>PaginationSelectMenu · DS React</p>
    </div>
  );
}
