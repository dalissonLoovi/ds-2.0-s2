import { forwardRef, type InputHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { FieldFrame, fieldFrameStyles } from '../_shared/FieldFrame';
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
  className?: string,
): ReactNode {
  const resolved = icon ?? fallback;
  if (typeof resolved === 'string' || typeof resolved === 'function') {
    const Comp = resolveIcon(resolved as DsIconName | IconComponent);
    return Comp ? (
      <Comp size={20} aria-hidden className={cx(fieldFrameStyles.icon, className)} />
    ) : null;
  }
  return resolved as ReactNode;
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
  const labelFloated =
    content === 'value' || content === 'placeholder' || state === 'focus';
  const restingControl = content === 'label' && !labelFloated;

  const inputPlaceholder =
    content === 'placeholder' ? (placeholder ?? 'Placeholder') : placeholder;

  const trailingSlot =
    isError || trailingIcon ? (
      <>
        {isError && slotIcon('alert-circle-outline', 'alert-circle-outline')}
        {!isError && trailingIcon && slotIcon(trailing, 'x-outline')}
      </>
    ) : undefined;

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
      leading={leadingIcon ? slotIcon(leading, 'search-outline') : undefined}
      trailing={trailingSlot}
    >
      <input
        ref={ref}
        id={inputId}
        className={cx(
          fieldFrameStyles.controlBase,
          restingControl && fieldFrameStyles.controlResting,
          styles.control,
        )}
        disabled={isDisabled}
        placeholder={labelFloated ? inputPlaceholder : undefined}
        value={value}
        defaultValue={
          defaultValue ?? (content === 'value' && value === undefined ? 'Value' : undefined)
        }
        aria-invalid={isError || undefined}
        aria-describedby={showSupportingText ? supportId : undefined}
        {...rest}
      />
    </FieldFrame>
  );
});

Input.displayName = 'Input';
