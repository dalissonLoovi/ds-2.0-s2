import { forwardRef, type InputHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './Input.module.css';

export type InputState = 'default' | 'hover' | 'focus' | 'error' | 'disabled';
export type InputContent = 'value' | 'placeholder' | 'label';
export type InputAppearance = 'default' | 'inverse';

export type InputProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'size' | 'disabled'> & {
  state?: InputState;
  content?: InputContent;
  appearance?: InputAppearance;
  label?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  leadingIcon?: boolean;
  trailingIcon?: boolean;
  leading?: DsIconName | IconComponent | ReactNode;
  trailing?: DsIconName | IconComponent | ReactNode;
  disabled?: boolean;
};

function slotIcon(
  icon: InputProps['leading'],
  fallback: DsIconName,
): ReactNode {
  const resolved = icon ?? fallback;
  if (typeof resolved === 'string' || typeof resolved === 'function') {
    const Comp = resolveIcon(resolved as DsIconName | IconComponent);
    return Comp ? <Comp size={20} aria-hidden className={styles.icon} /> : null;
  }
  return resolved;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(function Input(
  {
    state = 'default',
    content = 'placeholder',
    appearance = 'default',
    label = 'Label',
    supportingText = 'Supporting text',
    showSupportingText = true,
    leadingIcon = false,
    trailingIcon = false,
    leading,
    trailing,
    disabled = false,
    className,
    id,
    value,
    placeholder,
    defaultValue,
    ...rest
  },
  ref,
) {
  const isDisabled = disabled || state === 'disabled';
  const isError = state === 'error';
  const inputId = id ?? 'ds-input';
  const supportId = `${inputId}-support`;

  const showValue = content === 'value' || value != null || defaultValue != null;
  const inputPlaceholder =
    content === 'placeholder' ? (placeholder ?? 'Placeholder') : placeholder;

  return (
    <div
      className={cx(
        styles.root,
        styles[`appearance-${appearance}`],
        styles[`state-${state}`],
        className,
      )}
      data-state={state}
      data-appearance={appearance}
    >
      <label className={styles.label} htmlFor={inputId}>
        {label}
      </label>
      <div className={styles.field}>
        {leadingIcon && slotIcon(leading, 'search-outline')}
        <input
          ref={ref}
          id={inputId}
          className={styles.control}
          disabled={isDisabled}
          placeholder={inputPlaceholder}
          value={showValue && value !== undefined ? value : value}
          defaultValue={defaultValue ?? (content === 'value' && value === undefined ? 'Value' : undefined)}
          {...rest}
          aria-invalid={isError ? true : undefined}
          aria-describedby={showSupportingText ? supportId : undefined}
        />
        {trailingIcon &&
          slotIcon(trailing, isError ? 'alert-circle-outline' : 'x-outline')}
      </div>
      {showSupportingText && (
        <p id={supportId} className={cx(styles.support, isError && styles.supportError)}>
          {supportingText}
        </p>
      )}
    </div>
  );
});

Input.displayName = 'Input';
