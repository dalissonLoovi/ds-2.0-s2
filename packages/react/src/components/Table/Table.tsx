import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { TableRow } from '../TableRow/TableRow';
import styles from './Table.module.css';

export type TableColumns = '3' | '4' | '5' | '6' | '7' | '8' | '9';

export type TableProps = HTMLAttributes<HTMLTableElement> & {
  columns?: TableColumns;
  showHeader?: boolean;
  children?: ReactNode;
};

export function Table({
  columns = '3',
  showHeader = true,
  children,
  className,
  ...rest
}: TableProps) {
  return (
    <table className={cx(styles.root, className)} data-columns={columns} {...rest}>
      {showHeader && (
        <thead>
          <TableRow type="header" cellCount={columns} />
        </thead>
      )}
      <tbody>
        {children ?? (
          <>
            <TableRow type="body" cellCount={columns} />
            <TableRow type="body" cellCount={columns} />
            <TableRow type="body" cellCount={columns} />
          </>
        )}
      </tbody>
    </table>
  );
}
