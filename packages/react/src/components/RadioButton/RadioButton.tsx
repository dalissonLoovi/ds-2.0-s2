import { forwardRef, useId, type InputHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './RadioButton.module.css';

export type RadioButtonState = 'default' | 'hover' | 'focus' | 'disabled';

export type RadioButtonProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'type' | 'size'> & {
  state?: RadioButtonState;
  checked?: boolean;
  label?: string;
  showLabel?: boolean;
  description?: string;
  showDescription?: boolean;
  showContent?: boolean;
};

export const RadioButton = forwardRef<HTMLInputElement, RadioButtonProps>(function RadioButton(
  {
    state = 'default',
    checked,
    defaultChecked,
    label = 'Label',
    showLabel = true,
    description = 'Description',
    showDescription = false,
    showContent = true,
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
        isDisabled && styles.disabled,
        className,
      )}
      data-state={isDisabled ? 'disabled' : state}
      data-checked={checked === undefined ? undefined : String(checked)}
    >
      <span className={styles.controlWrap}>
        <input
          ref={ref}
          id={inputId}
          type="radio"
          className={styles.input}
          disabled={isDisabled}
          checked={checked}
          defaultChecked={defaultChecked}
          aria-describedby={showContent && showDescription ? descId : undefined}
          {...rest}
        />
        <span className={styles.radio} aria-hidden>
          <span className={styles.dot} />
        </span>
      </span>
      {showContent && (showLabel || showDescription) && (
        <span className={styles.content}>
          {showLabel && <span className={styles.label}>{label}</span>}
          {showDescription && (
            <span id={descId} className={styles.description}>
              {description}
            </span>
          )}
        </span>
      )}
    </label>
  );
});

RadioButton.displayName = 'RadioButton';
