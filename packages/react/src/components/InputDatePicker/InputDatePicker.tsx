import { forwardRef, useId, type ButtonHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { FieldFrame, fieldFrameStyles } from '../_shared/FieldFrame';
import styles from './InputDatePicker.module.css';

export type InputDatePickerState = 'default' | 'hover' | 'focus' | 'error' | 'disabled';
export type InputDatePickerContent = 'value' | 'placeholder' | 'label';
export type InputDatePickerAppearance = 'default' | 'inverse';

export type InputDatePickerProps = Omit<
  ButtonHTMLAttributes<HTMLButtonElement>,
  'disabled' | 'type'
> & {
  state?: InputDatePickerState;
  content?: InputDatePickerContent;
  appearance?: InputDatePickerAppearance;
  label?: string;
  value?: string;
  placeholder?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  leadingIcon?: boolean;
  leading?: DsIconName | IconComponent | ReactNode;
  trailing?: DsIconName | IconComponent | ReactNode;
  disabled?: boolean;
  expanded?: boolean;
};

function slotIcon(icon: InputDatePickerProps['leading'], fallback: DsIconName) {
  const resolved = icon ?? fallback;
  if (typeof resolved === 'string' || typeof resolved === 'function') {
    const Comp = resolveIcon(resolved as DsIconName | IconComponent);
    return Comp ? <Comp size={20} aria-hidden className={fieldFrameStyles.icon} /> : null;
  }
  return resolved;
}

export const InputDatePicker = forwardRef<HTMLButtonElement, InputDatePickerProps>(
  function InputDatePicker(
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
      disabled = false,
      expanded = false,
      className,
      id,
      ...rest
    },
    ref,
  ) {
    const autoId = useId();
    const inputId = id ?? autoId;
    const supportId = `${inputId}-support`;
    const isDisabled = disabled || state === 'disabled';
    const isError = state === 'error';
    const labelFloated =
      content === 'value' || content === 'placeholder' || state === 'focus' || expanded;
    const displayText =
      content === 'value' || value
        ? (value ?? 'Value')
        : content === 'placeholder'
          ? placeholder
          : null;

    return (
      <FieldFrame
        appearance={appearance}
        state={state}
        content={content}
        labelFloated={labelFloated}
        label={label}
        htmlFor={inputId}
        supportingText={supportingText}
        showSupportingText={showSupportingText}
        supportId={supportId}
        className={className}
        fieldClassName={styles.fieldPad}
        leading={leadingIcon ? slotIcon(leading, 'calendar-outline') : undefined}
        trailing={
          <>
            {isError && slotIcon('alert-circle-outline', 'alert-circle-outline')}
            {slotIcon(trailing, 'calendar-outline')}
          </>
        }
      >
        <button
          ref={ref}
          id={inputId}
          type="button"
          className={styles.trigger}
          disabled={isDisabled}
          aria-haspopup="dialog"
          aria-expanded={expanded}
          aria-invalid={isError || undefined}
          aria-describedby={showSupportingText ? supportId : undefined}
          {...rest}
        >
          {displayText != null && (
            <span
              className={cx(
                fieldFrameStyles.controlBase,
                styles.value,
                content === 'placeholder' && styles.placeholder,
              )}
            >
              {displayText}
            </span>
          )}
        </button>
      </FieldFrame>
    );
  },
);

InputDatePicker.displayName = 'InputDatePicker';
