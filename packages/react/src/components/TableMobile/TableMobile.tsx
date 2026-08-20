import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { TableMobileCell } from '../TableMobileCell/TableMobileCell';
import styles from './TableMobile.module.css';

export type TableMobileState = 'default' | 'hover' | 'pressed';
export type TableMobileColumnCount = '2' | '3' | '4' | '5' | '6';

export type TableMobileProps = HTMLAttributes<HTMLElement> & {
  state?: TableMobileState;
  interactive?: boolean;
  showTag?: boolean;
  columnCount?: TableMobileColumnCount;
  title?: string;
  subtitle?: string;
  href?: string;
};

export function TableMobile({
  state = 'default',
  interactive = false,
  showTag = true,
  columnCount = '4',
  title = 'Title',
  subtitle = 'Subtitle',
  href,
  className,
  ...rest
}: TableMobileProps) {
  const count = Number(columnCount);
  const classNames = cx(
    styles.root,
    styles[`state-${state}`],
    interactive && styles.interactive,
    className,
  );
  const inner: ReactNode = (
    <>
      <div className={styles.main}>
        <TableMobileCell type="primary" label={title} />
        <TableMobileCell type="secondary" label={subtitle} />
      </div>
      {showTag && <TableMobileCell type="tag" label="Status" />}
      {count >= 4 && <TableMobileCell type="secondary" label="Meta" />}
      {interactive && <TableMobileCell type="icon" label="Open" />}
    </>
  );

  if (interactive && href) {
    return (
      <a
        className={classNames}
        href={href}
        data-state={state}
        data-interactive={interactive}
        data-column-count={columnCount}
        {...rest}
      >
        {inner}
      </a>
    );
  }

  if (interactive) {
    return (
      <button
        type="button"
        className={classNames}
        data-state={state}
        data-interactive={interactive}
        data-column-count={columnCount}
        {...rest}
      >
        {inner}
      </button>
    );
  }

  return (
    <div
      className={classNames}
      data-state={state}
      data-interactive={interactive}
      data-column-count={columnCount}
      {...rest}
    >
      {inner}
    </div>
  );
}
