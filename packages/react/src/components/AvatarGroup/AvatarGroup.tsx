import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { Avatar, type AvatarSize } from '../Avatar/Avatar';
import styles from './AvatarGroup.module.css';

export type AvatarGroupProps = HTMLAttributes<HTMLDivElement> & {
  size?: AvatarSize;
  avatars?: Array<{ src?: string; initials?: string; alt?: string }>;
  overflowCount?: number;
  label?: string;
};

const DEFAULTS = [{ initials: 'AL' }, { initials: 'BR' }, { initials: 'CM' }];

export function AvatarGroup({
  size = 'md',
  avatars = DEFAULTS,
  overflowCount = 2,
  label = 'People',
  className,
  ...rest
}: AvatarGroupProps) {
  return (
    <div
      className={cx(styles.root, styles[`size-${size}`], className)}
      role="group"
      aria-label={label}
      data-size={size}
      {...rest}
    >
      {avatars.map((item, index) => (
        <Avatar
          key={`${item.initials}-${index}`}
          size={size}
          content={item.src ? 'image' : 'initials'}
          src={item.src}
          initials={item.initials}
          alt=""
          className={styles.stack}
        />
      ))}
      {overflowCount > 0 && (
        <span className={cx(styles.overflow, styles.stack)} aria-hidden>
          +{overflowCount}
        </span>
      )}
    </div>
  );
}
