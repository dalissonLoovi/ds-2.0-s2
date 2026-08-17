import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './FeatureStepsItem.module.css';

export type FeatureStepsItemProps = HTMLAttributes<HTMLLIElement> & {
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  headline?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  showConnector?: boolean;
};

export function FeatureStepsItem({
  leadingIcon = 'square-check-outline',
  headline = 'Label',
  supportingText = 'Description',
  showSupportingText = true,
  showConnector = true,
  className,
  ...rest
}: FeatureStepsItemProps) {
  const Icon =
    typeof leadingIcon === 'string' || typeof leadingIcon === 'function'
      ? resolveIcon(leadingIcon as DsIconName | IconComponent)
      : null;

  return (
    <li className={cx(styles.root, className)} {...rest}>
      <div className={styles.indicator} aria-hidden>
        <span className={styles.badge}>{Icon ? <Icon size={24} /> : (leadingIcon as ReactNode)}</span>
        {showConnector && <span className={styles.connector} />}
      </div>
      <div className={styles.content}>
        <p className={styles.headline}>{headline}</p>
        {showSupportingText && <p className={styles.supporting}>{supportingText}</p>}
      </div>
    </li>
  );
}
