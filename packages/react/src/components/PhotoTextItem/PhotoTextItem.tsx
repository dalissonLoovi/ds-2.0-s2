import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './PhotoTextItem.module.css';

export type PhotoTextItemProps = HTMLAttributes<HTMLDivElement> & {
  showSupportingText?: boolean;
  label?: string;
  supportingText?: string;
};

export function PhotoTextItem({
  showSupportingText = false,
  label = 'Label',
  supportingText = 'Supporting text',
  className,
  ...rest
}: PhotoTextItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-show-supporting-text={showSupportingText}
      {...rest}
    >
      <div className={styles.content}>
        <p className={styles.label}>{label}</p>
        {showSupportingText && <p className={styles.supporting}>{supportingText}</p>}
      </div>
    </div>
  );
}
