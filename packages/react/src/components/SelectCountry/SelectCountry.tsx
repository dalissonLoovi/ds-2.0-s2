import { forwardRef, type ButtonHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './SelectCountry.module.css';

export type SelectCountryState = 'default' | 'hover' | 'focus' | 'disabled';
export type SelectCountrySize = 'sm' | 'md';

export type SelectCountryProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'disabled' | 'type'> & {
  state?: SelectCountryState;
  size?: SelectCountrySize;
  expanded?: boolean;
  countryFlag?: ReactNode;
  countryCode?: string;
  disabled?: boolean;
  listboxId?: string;
};

export const SelectCountry = forwardRef<HTMLButtonElement, SelectCountryProps>(
  function SelectCountry(
    {
      state = 'default',
      size = 'sm',
      expanded = false,
      countryFlag,
      countryCode = 'BR',
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
          styles[`size-${size}`],
          styles[`state-${state}`],
          isDisabled && styles.disabled,
          className,
        )}
        disabled={isDisabled}
        aria-haspopup="listbox"
        aria-expanded={expanded}
        aria-controls={expanded ? listboxId : undefined}
        aria-label={ariaLabel ?? `Country ${countryCode}`}
        data-state={isDisabled ? 'disabled' : state}
        data-size={size}
        data-expanded={expanded}
        {...rest}
      >
        <span className={styles.flag} aria-hidden>
          {countryFlag ?? <span className={styles.flagFallback}>{countryCode}</span>}
        </span>
        {Chevron && <Chevron size={16} aria-hidden className={styles.chevron} />}
      </button>
    );
  },
);

SelectCountry.displayName = 'SelectCountry';
