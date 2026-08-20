import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import { PaginationItem } from '../PaginationItem/PaginationItem';
import styles from './Pagination.module.css';

export type PaginationPosition = 'start' | 'middle' | 'end';
export type PaginationSize = 'lg' | 'sm';

export type PaginationProps = HTMLAttributes<HTMLElement> & {
  position?: PaginationPosition;
  size?: PaginationSize;
  currentPage?: number;
  totalPages?: number;
  onPageChange?: (page: number) => void;
};

function pageItems(current: number, total: number): Array<number | 'overflow'> {
  if (total <= 5) {
    return Array.from({ length: total }, (_, i) => i + 1);
  }
  const items: Array<number | 'overflow'> = [1];
  if (current > 3) items.push('overflow');
  const start = Math.max(2, current - 1);
  const end = Math.min(total - 1, current + 1);
  for (let p = start; p <= end; p += 1) items.push(p);
  if (current < total - 2) items.push('overflow');
  items.push(total);
  return items;
}

export function Pagination({
  position = 'start',
  size = 'lg',
  currentPage,
  totalPages = 10,
  className,
  onPageChange,
  ...rest
}: PaginationProps) {
  const current =
    currentPage ?? (position === 'end' ? totalPages : position === 'middle' ? Math.ceil(totalPages / 2) : 1);
  const prevDisabled = position === 'start' || current <= 1;
  const nextDisabled = position === 'end' || current >= totalPages;
  const buttonSize = size === 'sm' ? 'sm' : 'md';

  return (
    <nav
      className={cx(styles.root, styles[`size-${size}`], className)}
      aria-label="Pagination"
      data-position={position}
      data-size={size}
      {...rest}
    >
      <Button
        variant="text"
        size={buttonSize}
        intent="primary"
        showLabel={false}
        showIcon
        icon="chevron-left-outline"
        disabled={prevDisabled}
        aria-label="Previous page"
        onClick={() => onPageChange?.(current - 1)}
      />
      {pageItems(current, totalPages).map((item, index) =>
        item === 'overflow' ? (
          <PaginationItem key={`ov-${index}`} content="overflow" />
        ) : (
          <PaginationItem
            key={item}
            content="number"
            label={String(item)}
            selected={item === current}
            onClick={() => onPageChange?.(item)}
          />
        ),
      )}
      <Button
        variant="text"
        size={buttonSize}
        intent="primary"
        showLabel={false}
        showIcon
        icon="chevron-right-outline"
        disabled={nextDisabled}
        aria-label="Next page"
        onClick={() => onPageChange?.(current + 1)}
      />
    </nav>
  );
}
