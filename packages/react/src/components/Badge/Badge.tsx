import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './Badge.module.css';

export type BadgeSize = 'sm' | 'lg';
export type BadgeContent = 'dot' | 'count' | 'overflow';

export type BadgeProps = HTMLAttributes<HTMLSpanElement> & {
  size?: BadgeSize;
  content?: BadgeContent;
  count?: number | string;
  overflowLabel?: string;
  /** Hide from AT when adjacent text already explains the badge. */
  decorative?: boolean;
};

export function Badge({
  size = 'sm',
  content = 'count',
  count = 1,
  overflowLabel = '999+',
  decorative = false,
  className,
  ...rest
}: BadgeProps) {
  const label =
    content === 'dot'
      ? 'Notification'
      : content === 'overflow'
        ? overflowLabel
        : String(count);

  return (
    <span
      className={cx(
        styles.root,
        styles[`size-${size}`],
        styles[`content-${content}`],
        className,
      )}
      data-size={size}
      data-content={content}
      aria-hidden={decorative || undefined}
      aria-label={decorative ? undefined : label}
      {...rest}
    >
      {content === 'dot' ? null : content === 'overflow' ? overflowLabel : count}
    </span>
  );
}
