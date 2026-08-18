import { forwardRef, useId, useState, type InputHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import { FieldFrame } from '../_shared/FieldFrame';
import styles from './InputPassword.module.css';

export type InputPasswordState = 'default' | 'hover' | 'focus' | 'error' | 'disabled';
export type InputPasswordContent = 'value' | 'placeholder' | 'label';
export type InputPasswordAppearance = 'default' | 'inverse';
export type InputPasswordVisibility = 'hidden' | 'visible';

export type InputPasswordProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'type' | 'disabled' | 'size'> & {
  state?: InputPasswordState;
  content?: InputPasswordContent;
  appearance?: InputPasswordAppearance;
  visibility?: InputPasswordVisibility;
  label?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  leadingIcon?: boolean;
  leading?: DsIconName | IconComponent | ReactNode;
  disabled?: boolean;
  onVisibilityChange?: (visibility: InputPasswordVisibility) => void;
};

function slotIcon(icon: InputPasswordProps['leading'], fallback: DsIconName) {
  const resolved = icon ?? fallback;
  if (typeof resolved === 'string' || typeof resolved === 'function') {
    const Comp = resolveIcon(resolved as DsIconName | IconComponent);
    return Comp ? <Comp size={20} aria-hidden className={styles.icon} /> : null;
  }
  return resolved;
}

export const InputPassword = forwardRef<HTMLInputElement, InputPasswordProps>(
  function InputPassword(
    {
      state = 'default',
      content = 'placeholder',
      appearance = 'default',
      visibility: visibilityProp,
      label = 'Label',
      supportingText = 'Supporting text',
      showSupportingText = true,
      leadingIcon = true,
      leading,
      disabled = false,
      className,
      id,
      value,
      placeholder,
      defaultValue,
      onVisibilityChange,
      ...rest
    },
    ref,
  ) {
    const autoId = useId();
    const inputId = id ?? autoId;
    const supportId = `${inputId}-support`;
    const isDisabled = disabled || state === 'disabled';
    const isError = state === 'error';
    const [uncontrolledVisibility, setUncontrolledVisibility] =
      useState<InputPasswordVisibility>('hidden');
    const visibility = visibilityProp ?? uncontrolledVisibility;
    const visible = visibility === 'visible';

    const toggleVisibility = () => {
      const next: InputPasswordVisibility = visible ? 'hidden' : 'visible';
      if (visibilityProp === undefined) setUncontrolledVisibility(next);
      onVisibilityChange?.(next);
    };

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
      >
        {leadingIcon && slotIcon(leading, 'lock-outline')}
        <input
          ref={ref}
          id={inputId}
          className={styles.control}
          type={visible ? 'text' : 'password'}
          disabled={isDisabled}
          placeholder={
            content === 'placeholder' ? (placeholder ?? 'Placeholder') : placeholder
          }
          value={value}
          defaultValue={
            defaultValue ?? (content === 'value' && value === undefined ? 'Value' : undefined)
          }
          aria-invalid={isError || undefined}
          aria-describedby={showSupportingText ? supportId : undefined}
          autoComplete="current-password"
          {...rest}
        />
        {isError && slotIcon('alert-circle-outline', 'alert-circle-outline')}
        <Button
          variant="text"
          size="sm"
          intent="primary"
          showLabel={false}
          showIcon
          icon={visible ? 'eye-outline' : 'eye-closed-outline'}
          aria-label={visible ? 'Ocultar senha' : 'Mostrar senha'}
          disabled={isDisabled}
          onClick={toggleVisibility}
          className={styles.visibility}
        />
      </FieldFrame>
    );
  },
);

InputPassword.displayName = 'InputPassword';
