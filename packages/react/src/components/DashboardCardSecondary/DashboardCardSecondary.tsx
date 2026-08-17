import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './DashboardCardSecondary.module.css';

export type DashboardCardSecondaryType = 'web' | 'mobile';
export type DashboardCardSecondaryGrowth = 'up' | 'down';

export type DashboardCardSecondaryProps = HTMLAttributes<HTMLElement> & {
  type?: DashboardCardSecondaryType;
  growth?: DashboardCardSecondaryGrowth;
  icon?: DsIconName | IconComponent;
  showIcon?: boolean;
  title?: string;
  value?: string;
  showInfo?: boolean;
  showDescription?: boolean;
  percentage?: string;
  percentageDescription?: string;
};

export function DashboardCardSecondary({
  type = 'web',
  growth = 'up',
  icon = 'file-description-outline',
  showIcon = true,
  title = 'Title',
  value = '0',
  showInfo = true,
  showDescription = true,
  percentage = '0%',
  percentageDescription = 'vs last period',
  className,
  ...rest
}: DashboardCardSecondaryProps) {
  const web = type === 'web';
  const Leading = typeof icon === 'string' || typeof icon === 'function' ? resolveIcon(icon) : null;
  const Info = resolveIcon('info-circle-outline');
  const Growth = resolveIcon(
    growth === 'up' ? 'circle-arrow-up-right-filled' : 'circle-arrow-down-right-filled',
  );

  return (
    <article
      className={cx(styles.root, styles[`type-${type}`], styles[`growth-${growth}`], className)}
      data-type={type}
      data-growth={growth}
      {...rest}
    >
      <div className={styles.titleRow}>
        {web && showIcon && Leading ? <Leading size={20} aria-hidden className={styles.leadIcon} /> : null}
        <p className={styles.title}>{title}</p>
        {showInfo && Info ? <Info size={16} aria-hidden className={styles.info} /> : null}
      </div>
      <div className={styles.valuesRow}>
        <p className={styles.value}>{value}</p>
        <div className={styles.percentual}>
          {Growth ? <Growth size={16} aria-hidden className={styles.growthIcon} /> : null}
          <span className={styles.percentage}>{percentage}</span>
          {showDescription && <span className={styles.description}>{percentageDescription}</span>}
        </div>
      </div>
    </article>
  );
}
