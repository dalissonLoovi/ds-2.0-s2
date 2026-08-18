import { forwardRef, useId, type ButtonHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { FieldFrame } from '../_shared/FieldFrame';
import styles from './InputSelect.module.css';

export type InputSelectState = 'default' | 'hover' | 'focus' | 'error' | 'disabled';
export type InputSelectContent = 'value' | 'placeholder' | 'label';
export type InputSelectAppearance = 'default' | 'inverse';

export type InputSelectProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'disabled' | 'type'> & {
  state?: InputSelectState;
  content?: InputSelectContent;
  appearance?: InputSelectAppearance;
  label?: string;
  value?: string;
  placeholder?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  leadingIcon?: boolean;
  leading?: DsIconName | IconComponent | ReactNode;
  trailing?: DsIconName | IconComponent | ReactNode;
  expanded?: boolean;
  disabled?: boolean;
  listboxId?: string;
};

function slotIcon(icon: InputSelectProps['leading'], fallback: DsIconName) {
  const resolved = icon ?? fallback;
  if (typeof resolved === 'string' || typeof resolved === 'function') {
    const Comp = resolveIcon(resolved as DsIconName | IconComponent);
    return Comp ? <Comp size={20} aria-hidden className={styles.icon} /> : null;
  }
  return resolved;
}

export const InputSelect = forwardRef<HTMLButtonElement, InputSelectProps>(function InputSelect(
  {
    state = 'default',
    content = 'placeholder',
    appearance = 'default',
    label = 'Label',
    value,
    placeholder = 'Placeholder',
    supportingText = 'Supporting text',
    showSupportingText = true,
    leadingIcon = false,
    leading,
    trailing,
    expanded = false,
    disabled = false,
    className,
    id,
    listboxId,
    ...rest
  },
  ref,
) {
  const autoId = useId();
  const inputId = id ?? autoId;
  const supportId = `${inputId}-support`;
  const isDisabled = disabled || state === 'disabled';
  const isError = state === 'error';
  const isFocus = state === 'focus' || expanded;
  const display =
    content === 'value' || value
      ? (value ?? 'Value')
      : content === 'label'
        ? label
        : placeholder;

  return (
    <FieldFrame
      appearance={appearance}
      state={state}
      label={label}
      htmlFor={inputId}
      supportingText={supportingText}
      showSupportingText={showSupportingText}
      supportId={supportId}
      className={className}
      fieldClassName={styles.fieldPad}
    >
      <button
        ref={ref}
        id={inputId}
        type="button"
        className={styles.trigger}
        disabled={isDisabled}
        aria-haspopup="listbox"
        aria-expanded={expanded}
        aria-controls={expanded ? listboxId : undefined}
        aria-invalid={isError || undefined}
        aria-describedby={showSupportingText ? supportId : undefined}
        data-content={content}
        {...rest}
      >
        {leadingIcon && slotIcon(leading, 'search-outline')}
        <span className={cx(styles.value, content !== 'value' && !value && styles.placeholder)}>
          {display}
        </span>
        {isError && slotIcon('alert-circle-outline', 'alert-circle-outline')}
        {slotIcon(
          trailing,
          isFocus ? 'chevron-up-outline' : 'chevron-down-outline',
        )}
      </button>
    </FieldFrame>
  );
});

InputSelect.displayName = 'InputSelect';
