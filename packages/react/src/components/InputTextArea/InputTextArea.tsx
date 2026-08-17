import { forwardRef, useId, type ReactNode, type TextareaHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { FieldFrame } from '../_shared/FieldFrame';
import styles from './InputTextArea.module.css';

export type InputTextAreaState = 'default' | 'hover' | 'focus' | 'error' | 'disabled';
export type InputTextAreaContent = 'value' | 'placeholder' | 'label';
export type InputTextAreaAppearance = 'default' | 'inverse';

export type InputTextAreaProps = Omit<TextareaHTMLAttributes<HTMLTextAreaElement>, 'disabled'> & {
  state?: InputTextAreaState;
  content?: InputTextAreaContent;
  appearance?: InputTextAreaAppearance;
  label?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  countText?: string;
  showCount?: boolean;
  leadingIcon?: boolean;
  trailingIcon?: boolean;
  leading?: DsIconName | IconComponent | ReactNode;
  trailing?: DsIconName | IconComponent | ReactNode;
  showResizeHandle?: boolean;
  disabled?: boolean;
};

function slotIcon(icon: InputTextAreaProps['leading'], fallback: DsIconName) {
  const resolved = icon ?? fallback;
  if (typeof resolved === 'string' || typeof resolved === 'function') {
    const Comp = resolveIcon(resolved as DsIconName | IconComponent);
    return Comp ? <Comp size={20} aria-hidden className={styles.icon} /> : null;
  }
  return resolved;
}

export const InputTextArea = forwardRef<HTMLTextAreaElement, InputTextAreaProps>(
  function InputTextArea(
    {
      state = 'default',
      content = 'placeholder',
      appearance = 'default',
      label = 'Label',
      supportingText = 'Supporting text',
      showSupportingText = true,
      countText = '0/200',
      showCount = true,
      leadingIcon = false,
      trailingIcon = false,
      leading,
      trailing,
      showResizeHandle = true,
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
    const autoId = useId();
    const inputId = id ?? autoId;
    const supportId = `${inputId}-support`;
    const isDisabled = disabled || state === 'disabled';
    const isError = state === 'error';
    const inputPlaceholder =
      content === 'placeholder' ? (placeholder ?? 'Placeholder') : placeholder;

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
        fieldClassName={cx(styles.field, showResizeHandle && styles.resizable)}
        trailingMeta={showCount ? <span className={styles.count}>{countText}</span> : null}
      >
        {leadingIcon && slotIcon(leading, 'search-outline')}
        <textarea
          ref={ref}
          id={inputId}
          className={styles.control}
          disabled={isDisabled}
          placeholder={inputPlaceholder}
          value={value}
          defaultValue={
            defaultValue ?? (content === 'value' && value === undefined ? 'Value' : undefined)
          }
          aria-invalid={isError || undefined}
          aria-describedby={showSupportingText || showCount ? supportId : undefined}
          {...rest}
        />
        {trailingIcon &&
          slotIcon(trailing, isError ? 'alert-circle-outline' : 'x-outline')}
      </FieldFrame>
    );
  },
);

InputTextArea.displayName = 'InputTextArea';
