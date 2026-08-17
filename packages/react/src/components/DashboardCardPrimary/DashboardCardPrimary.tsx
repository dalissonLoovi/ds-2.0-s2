import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './DashboardCardPrimary.module.css';

export type DashboardCardPrimaryType = 'web' | 'mobile';

export type DashboardCardPrimaryProps = HTMLAttributes<HTMLElement> & {
  type?: DashboardCardPrimaryType;
  title?: string;
  primaryValue?: string;
  label1?: string;
  label2?: string;
  description1?: string;
  description2?: string;
  showInfo?: boolean;
};

export function DashboardCardPrimary({
  type = 'web',
  title = 'Title',
  primaryValue = 'R$ 0',
  label1 = 'Label',
  label2 = 'Label',
  description1 = '0',
  description2 = '0',
  showInfo = true,
  className,
  ...rest
}: DashboardCardPrimaryProps) {
  const Info = resolveIcon('info-circle-outline');
  const Dollar = resolveIcon('currency-dollar-outline');
  const web = type === 'web';

  return (
    <article
      className={cx(styles.root, styles[`type-${type}`], className)}
      data-type={type}
      {...rest}
    >
      {web ? (
        <>
          <div className={styles.titleRow}>
            <p className={styles.title}>{title}</p>
            {showInfo && Info ? <Info size={16} aria-hidden className={styles.info} /> : null}
          </div>
          <div className={styles.content}>
            <span className={styles.chart} aria-hidden />
            <p className={styles.primary}>{primaryValue}</p>
            <div className={styles.metrics}>
              <div>
                <p className={styles.metricLabel}>{label1}</p>
                <p className={styles.metricValue}>{description1}</p>
              </div>
              <div>
                <p className={styles.metricLabel}>{label2}</p>
                <p className={styles.metricValue}>{description2}</p>
              </div>
            </div>
          </div>
        </>
      ) : (
        <>
          <div className={styles.mainCol}>
            <div className={styles.chartWrap}>
              <span className={styles.chart} aria-hidden />
              {Dollar ? <Dollar size={16} aria-hidden className={styles.leadingIcon} /> : null}
            </div>
            <p className={styles.primary}>{primaryValue}</p>
            <p className={styles.title}>{title}</p>
          </div>
          <div className={styles.metrics}>
            <div>
              <p className={styles.metricLabel}>{label1}</p>
              <p className={styles.metricValue}>{description1}</p>
            </div>
            <div>
              <p className={styles.metricLabel}>{label2}</p>
              <p className={styles.metricValue}>{description2}</p>
            </div>
          </div>
        </>
      )}
    </article>
  );
}
