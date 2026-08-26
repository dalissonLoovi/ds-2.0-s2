import { forwardRef, useId, type InputHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { FieldFrame } from '../_shared/FieldFrame';
import { SelectCountry } from '../SelectCountry/SelectCountry';
import styles from './InputNumber.module.css';

export type InputNumberState = 'default' | 'hover' | 'focus' | 'error' | 'disabled';
export type InputNumberContent = 'value' | 'placeholder' | 'label';
export type InputNumberAppearance = 'default' | 'inverse';

export type InputNumberProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'type' | 'disabled' | 'size'> & {
  state?: InputNumberState;
  content?: InputNumberContent;
  appearance?: InputNumberAppearance;
  label?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  leadingIcon?: boolean;
  trailingIcon?: boolean;
  leading?: DsIconName | IconComponent | ReactNode;
  trailing?: DsIconName | IconComponent | ReactNode;
  showSelectCountry?: boolean;
  showPaymentMethodMark?: boolean;
  /** kebab-case slug matching payment-method/{brand}; hidden when null/undefined */
  paymentMethodBrand?: string | null;
  paymentMethodMark?: ReactNode;
  countryFlag?: ReactNode;
  countryCode?: string;
  onCountryClick?: () => void;
  disabled?: boolean;
};

function slotIcon(icon: InputNumberProps['leading'], fallback: DsIconName) {
  const resolved = icon ?? fallback;
  if (typeof resolved === 'string' || typeof resolved === 'function') {
    const Comp = resolveIcon(resolved as DsIconName | IconComponent);
    return Comp ? <Comp size={20} aria-hidden className={styles.icon} /> : null;
  }
  return resolved;
}

export const InputNumber = forwardRef<HTMLInputElement, InputNumberProps>(function InputNumber(
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
    showSelectCountry = false,
    showPaymentMethodMark = false,
    paymentMethodBrand = null,
    paymentMethodMark,
    countryFlag,
    countryCode = 'BR',
    onCountryClick,
    disabled = false,
    className,
    id,
    value,
    placeholder,
    defaultValue,
    autoComplete,
    ...rest
  },
  ref,
) {
  const autoId = useId();
  const inputId = id ?? autoId;
  const supportId = `${inputId}-support`;
  const isDisabled = disabled || state === 'disabled';
  const isError = state === 'error';
  const showCountry = showSelectCountry && !showPaymentMethodMark;
  const showMark =
    showPaymentMethodMark && !showSelectCountry && (paymentMethodMark != null || paymentMethodBrand != null);

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
      fieldClassName={showCountry ? styles.withCountry : undefined}
    >
      {showCountry && (
        <>
          <SelectCountry
            size="sm"
            state={isDisabled ? 'disabled' : state === 'focus' ? 'focus' : 'default'}
            countryFlag={countryFlag}
            countryCode={countryCode}
            disabled={isDisabled}
            onClick={onCountryClick}
          />
          <span className={styles.divider} aria-hidden />
        </>
      )}
      {!showCountry && leadingIcon && slotIcon(leading, 'search-outline')}
      <input
        ref={ref}
        id={inputId}
        className={styles.control}
        type="text"
        inputMode="numeric"
        autoComplete={autoComplete ?? (showPaymentMethodMark ? 'cc-number' : undefined)}
        disabled={isDisabled}
        placeholder={content === 'placeholder' ? (placeholder ?? 'Placeholder') : placeholder}
        value={value}
        defaultValue={
          defaultValue ?? (content === 'value' && value === undefined ? 'Value' : undefined)
        }
        aria-invalid={isError || undefined}
        aria-describedby={showSupportingText ? supportId : undefined}
        {...rest}
      />
      {showMark &&
        (paymentMethodMark ?? (
          <span
            className={styles.paymentMark}
            data-brand={paymentMethodBrand ?? undefined}
            aria-hidden
          />
        ))}
      {trailingIcon && slotIcon(trailing, isError ? 'alert-circle-outline' : 'x-outline')}
      {!trailingIcon && isError && slotIcon('alert-circle-outline', 'alert-circle-outline')}
    </FieldFrame>
  );
});

InputNumber.displayName = 'InputNumber';
