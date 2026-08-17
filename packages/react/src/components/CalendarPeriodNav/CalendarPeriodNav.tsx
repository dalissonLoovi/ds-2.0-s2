import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import styles from './CalendarPeriodNav.module.css';

export type CalendarPeriodNavAppearance = 'default' | 'inverse';

export type CalendarPeriodNavProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: CalendarPeriodNavAppearance;
  previousDisabled?: boolean;
  nextDisabled?: boolean;
  periodLabel?: string;
  onPrevious?: () => void;
  onNext?: () => void;
  onPeriodAction?: () => void;
};

export function CalendarPeriodNav({
  appearance = 'default',
  previousDisabled = false,
  nextDisabled = false,
  periodLabel = 'Abril 2025',
  onPrevious,
  onNext,
  onPeriodAction,
  className,
  ...rest
}: CalendarPeriodNavProps) {
  const Chevron = resolveIcon('chevron-down-outline');

  return (
    <div
      className={cx(styles.root, styles[`appearance-${appearance}`], className)}
      role="toolbar"
      aria-label="Period navigation"
      data-appearance={appearance}
      data-previous-disabled={previousDisabled}
      data-next-disabled={nextDisabled}
      {...rest}
    >
      <Button
        variant="text"
        size="sm"
        intent="primary"
        showLabel={false}
        showIcon
        icon="chevron-left-outline"
        aria-label="Previous period"
        disabled={previousDisabled}
        onClick={onPrevious}
      />
      <button
        type="button"
        className={styles.period}
        aria-haspopup="dialog"
        aria-label={periodLabel}
        onClick={onPeriodAction}
      >
        <span className={styles.label}>{periodLabel}</span>
        <span className={styles.expand} aria-hidden>
          {Chevron ? <Chevron size={16} /> : null}
        </span>
      </button>
      <Button
        variant="text"
        size="sm"
        intent="primary"
        showLabel={false}
        showIcon
        icon="chevron-right-outline"
        aria-label="Next period"
        disabled={nextDisabled}
        onClick={onNext}
      />
    </div>
  );
}
