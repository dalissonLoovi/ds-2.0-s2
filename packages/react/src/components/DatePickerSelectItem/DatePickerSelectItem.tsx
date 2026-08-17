import { forwardRef, type ButtonHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './DatePickerSelectItem.module.css';

export type DatePickerSelectItemUnit = 'day' | 'month' | 'year';
export type DatePickerSelectItemState = 'default' | 'hover' | 'focus' | 'disabled';

export type DatePickerSelectItemProps = Omit<
  ButtonHTMLAttributes<HTMLButtonElement>,
  'disabled' | 'type' | 'value'
> & {
  unit?: DatePickerSelectItemUnit;
  state?: DatePickerSelectItemState;
  expanded?: boolean;
  value?: string;
  disabled?: boolean;
  listboxId?: string;
};

const UNIT_LABEL: Record<DatePickerSelectItemUnit, string> = {
  day: 'Day',
  month: 'Month',
  year: 'Year',
};

export const DatePickerSelectItem = forwardRef<HTMLButtonElement, DatePickerSelectItemProps>(
  function DatePickerSelectItem(
    {
      unit = 'day',
      state = 'default',
      expanded = false,
      value = 'Value',
      disabled = false,
      className,
      listboxId,
      'aria-label': ariaLabel,
      ...rest
    },
    ref,
  ) {
    const isDisabled = disabled || state === 'disabled';
    const Chevron = resolveIcon(expanded ? 'chevron-up-outline' : 'chevron-down-outline');

    return (
      <button
        ref={ref}
        type="button"
        className={cx(
          styles.root,
          styles[`state-${state}`],
          isDisabled && styles.disabled,
          className,
        )}
        disabled={isDisabled}
        aria-haspopup="listbox"
        aria-expanded={expanded}
        aria-controls={expanded ? listboxId : undefined}
        aria-label={ariaLabel ?? `${UNIT_LABEL[unit]} ${value}`}
        data-unit={unit}
        data-state={isDisabled ? 'disabled' : state}
        data-expanded={expanded}
        {...rest}
      >
        <span className={styles.value}>{value}</span>
        {Chevron && <Chevron size={16} aria-hidden className={styles.chevron} />}
      </button>
    );
  },
);

DatePickerSelectItem.displayName = 'DatePickerSelectItem';
