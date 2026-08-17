import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { DatePickerSelectItem } from '../DatePickerSelectItem/DatePickerSelectItem';
import styles from './DatePickerSelect.module.css';

export type DatePickerSelectFormat =
  | 'day-month-year'
  | 'day-month'
  | 'month-year'
  | 'year';
export type DatePickerSelectState = 'default' | 'hover' | 'focus' | 'disabled';

export type DatePickerSelectProps = HTMLAttributes<HTMLDivElement> & {
  format?: DatePickerSelectFormat;
  state?: DatePickerSelectState;
  dayValue?: string;
  monthValue?: string;
  yearValue?: string;
  disabled?: boolean;
  onDayClick?: () => void;
  onMonthClick?: () => void;
  onYearClick?: () => void;
};

export function DatePickerSelect({
  format = 'day-month-year',
  state = 'default',
  dayValue = '01',
  monthValue = 'Jan',
  yearValue = '2026',
  disabled = false,
  className,
  onDayClick,
  onMonthClick,
  onYearClick,
  ...rest
}: DatePickerSelectProps) {
  const isDisabled = disabled || state === 'disabled';
  const itemState = isDisabled ? 'disabled' : state === 'focus' ? 'focus' : 'default';
  const showDay = format === 'day-month-year' || format === 'day-month';
  const showMonth = format !== 'year';
  const showYear = format === 'day-month-year' || format === 'month-year' || format === 'year';

  return (
    <div
      className={cx(styles.root, styles[`state-${state}`], className)}
      role="group"
      aria-disabled={isDisabled || undefined}
      data-format={format}
      data-state={isDisabled ? 'disabled' : state}
      {...rest}
    >
      {showDay && (
        <DatePickerSelectItem
          unit="day"
          state={itemState}
          value={dayValue}
          disabled={isDisabled}
          expanded={false}
          onClick={onDayClick}
        />
      )}
      {showMonth && (
        <DatePickerSelectItem
          unit="month"
          state={itemState}
          value={monthValue}
          disabled={isDisabled}
          expanded={false}
          onClick={onMonthClick}
        />
      )}
      {showYear && (
        <DatePickerSelectItem
          unit="year"
          state={itemState}
          value={yearValue}
          disabled={isDisabled}
          expanded={false}
          onClick={onYearClick}
        />
      )}
    </div>
  );
}
