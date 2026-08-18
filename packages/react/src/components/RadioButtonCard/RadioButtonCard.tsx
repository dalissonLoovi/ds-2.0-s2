import { forwardRef, useId, type InputHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './RadioButtonCard.module.css';

export type RadioButtonCardState = 'default' | 'hover' | 'focus' | 'disabled';

export type RadioButtonCardProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'type' | 'size'> & {
  state?: RadioButtonCardState;
  checked?: boolean;
  label?: string;
  description?: string;
  showDescription?: boolean;
};

export const RadioButtonCard = forwardRef<HTMLInputElement, RadioButtonCardProps>(
  function RadioButtonCard(
    {
      state = 'default',
      checked,
      defaultChecked,
      label = 'Label',
      description = 'Description',
      showDescription = true,
      disabled = false,
      className,
      id,
      ...rest
    },
    ref,
  ) {
    const autoId = useId();
    const inputId = id ?? autoId;
    const descId = `${inputId}-desc`;
    const isDisabled = disabled || state === 'disabled';

    return (
      <label
        className={cx(
          styles.root,
          styles[`state-${state}`],
          (checked || defaultChecked) && styles.checked,
          isDisabled && styles.disabled,
          className,
        )}
        data-state={isDisabled ? 'disabled' : state}
        data-checked={checked === undefined ? undefined : String(checked)}
      >
        <span className={styles.stateLayer} aria-hidden />
        <span className={styles.controlWrap}>
          <input
            ref={ref}
            id={inputId}
            type="radio"
            className={styles.input}
            disabled={isDisabled}
            checked={checked}
            defaultChecked={defaultChecked}
            aria-describedby={showDescription ? descId : undefined}
            {...rest}
          />
          <span className={styles.radio} aria-hidden>
            <span className={styles.dot} />
          </span>
        </span>
        <span className={styles.content}>
          <span className={styles.label}>{label}</span>
          {showDescription && (
            <span id={descId} className={styles.description}>
              {description}
            </span>
          )}
        </span>
      </label>
    );
  },
);

RadioButtonCard.displayName = 'RadioButtonCard';
