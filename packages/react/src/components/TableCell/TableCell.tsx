import type { HTMLAttributes, ReactNode, TdHTMLAttributes, ThHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './TableCell.module.css';

export type TableCellType = 'header' | 'primary' | 'secondary' | 'tertiary' | 'slot';
export type TableCellState = 'default' | 'hover' | 'pressed' | 'selected';

export type TableCellProps = HTMLAttributes<HTMLTableCellElement> & {
  type?: TableCellType;
  state?: TableCellState;
  header?: string;
  label?: string;
  description?: string;
  children?: ReactNode;
};

export function TableCell({
  type = 'primary',
  state = 'default',
  header,
  label = 'Cell',
  description,
  children,
  className,
  ...rest
}: TableCellProps) {
  const isHeader = type === 'header';
  const Tag = isHeader ? 'th' : 'td';
  const text = isHeader ? (header ?? label) : label;

  return (
    <Tag
      className={cx(styles.root, styles[`type-${type}`], styles[`state-${state}`], className)}
      scope={isHeader ? 'col' : undefined}
      data-type={type}
      data-state={state}
      {...(rest as TdHTMLAttributes<HTMLTableCellElement> & ThHTMLAttributes<HTMLTableCellElement>)}
    >
      {type === 'slot' ? (
        children
      ) : (
        <>
          <span className={styles.label}>{text}</span>
          {description && !isHeader && <span className={styles.description}>{description}</span>}
        </>
      )}
    </Tag>
  );
}
