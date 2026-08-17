import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TooltipRich.module.css';

export type TooltipRichProps = HTMLAttributes<HTMLDivElement> & {
  placement?: 'top-center' | 'top-left' | 'top-right' | 'bottom-center' | 'bottom-left' | 'bottom-right';
  label?: string;
  children?: ReactNode;
};

export function TooltipRich({
  placement = 'top-center',
  label = 'TooltipRich',
  children,
  className,
  ...rest
}: TooltipRichProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-placement={placement}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TooltipRich · DS React</p>
    </div>
  );
}
