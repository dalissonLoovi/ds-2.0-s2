import { forwardRef, useId, type InputHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './Checkbox.module.css';

export type CheckboxState = 'default' | 'focus' | 'disabled';
export type CheckboxChecked = boolean | 'mixed';

export type CheckboxProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'checked' | 'type' | 'size'> & {
  state?: CheckboxState;
  checked?: CheckboxChecked;
  defaultChecked?: boolean;
  label?: string;
  showLabel?: boolean;
  description?: string;
  showDescription?: boolean;
  showContent?: boolean;
};

export const Checkbox = forwardRef<HTMLInputElement, CheckboxProps>(function Checkbox(
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
    onChange,
    ...rest
  },
  ref,
) {
  const autoId = useId();
  const inputId = id ?? autoId;
  const descId = `${inputId}-desc`;
  const isDisabled = disabled || state === 'disabled';
  const isMixed = checked === 'mixed';
  const isChecked = checked === true;

  const CheckIcon = resolveIcon(isMixed ? 'minus-outline' : 'check-outline');

  return (
    <label
      className={cx(
        styles.root,
        styles[`state-${state}`],
        isDisabled && styles.disabled,
        className,
      )}
      data-state={isDisabled ? 'disabled' : state}
      data-checked={isMixed ? 'mixed' : String(Boolean(isChecked || (checked === undefined && defaultChecked)))}
    >
      <span className={styles.controlWrap}>
        <input
          ref={ref}
          id={inputId}
          type="checkbox"
          className={styles.input}
          disabled={isDisabled}
          checked={isMixed ? false : checked === undefined ? undefined : Boolean(isChecked)}
          defaultChecked={checked === undefined ? defaultChecked : undefined}
          aria-checked={isMixed ? 'mixed' : undefined}
          aria-describedby={showContent && showDescription ? descId : undefined}
          onChange={onChange}
          {...rest}
        />
        <span className={cx(styles.box, (isChecked || isMixed) && styles.boxChecked)} aria-hidden>
          {(isChecked || isMixed) && CheckIcon && <CheckIcon size={14} />}
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

Checkbox.displayName = 'Checkbox';
