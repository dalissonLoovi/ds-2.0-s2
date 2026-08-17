import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Tooltip.module.css';

export type TooltipProps = HTMLAttributes<HTMLDivElement> & {
  placement?: 'top-center' | 'top-left' | 'top-right' | 'bottom-center' | 'bottom-left' | 'bottom-right';
  label?: string;
  children?: ReactNode;
};

export function Tooltip({
  placement = 'top-center',
  label = 'Tooltip',
  children,
  className,
  ...rest
}: TooltipProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-placement={placement}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Tooltip · DS React</p>
    </div>
  );
}
