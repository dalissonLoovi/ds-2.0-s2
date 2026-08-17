import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { TableCell } from '../TableCell/TableCell';
import { TableExpandCell } from '../TableExpandCell/TableExpandCell';
import styles from './TableRow.module.css';

export type TableRowType = 'header' | 'body';
export type TableRowCellCount = '3' | '4' | '5' | '6' | '7' | '8' | '9';
export type TableRowState = 'default' | 'hover' | 'pressed' | 'selected' | 'focus';

export type TableRowProps = HTMLAttributes<HTMLTableRowElement> & {
  type?: TableRowType;
  cellCount?: TableRowCellCount;
  state?: TableRowState;
  showExpandCell?: boolean;
  expanded?: boolean;
  cells?: string[];
  children?: ReactNode;
};

export function TableRow({
  type = 'body',
  cellCount = '3',
  state = 'default',
  showExpandCell = false,
  expanded = false,
  cells,
  children,
  className,
  ...rest
}: TableRowProps) {
  const count = Number(cellCount);
  const labels = Array.from({ length: count }, (_, i) => cells?.[i] ?? (type === 'header' ? `Col ${i + 1}` : `Cell ${i + 1}`));
  const header = type === 'header';

  return (
    <tr
      className={cx(styles.root, styles[`type-${type}`], styles[`state-${state}`], className)}
      data-type={type}
      data-cell-count={cellCount}
      data-state={state}
      {...rest}
    >
      {showExpandCell && (
        <TableExpandCell type={header ? 'header' : 'body'} showChevron={!header} expanded={expanded} />
      )}
      {children ??
        labels.map((label, index) => (
          <TableCell
            key={`${label}-${index}`}
            type={header ? 'header' : index === 0 ? 'primary' : 'secondary'}
            header={header ? label : undefined}
            label={label}
          />
        ))}
    </tr>
  );
}
