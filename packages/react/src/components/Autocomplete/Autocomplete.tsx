import { forwardRef, useId, type InputHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import { FieldFrame } from '../_shared/FieldFrame';
import styles from './Autocomplete.module.css';

export type AutocompleteState = 'default' | 'hover' | 'focus' | 'error' | 'disabled';
export type AutocompleteContent = 'empty' | 'query' | 'selected';
export type AutocompleteAppearance = 'default' | 'inverse';

export type AutocompleteProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'disabled' | 'size'> & {
  state?: AutocompleteState;
  content?: AutocompleteContent;
  expanded?: boolean;
  appearance?: AutocompleteAppearance;
  label?: string;
  query?: string;
  selectedValue?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  showLeadingIcon?: boolean;
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  showClearAction?: boolean;
  loading?: boolean;
  listboxId?: string;
  disabled?: boolean;
  onClear?: () => void;
};

function slotIcon(icon: AutocompleteProps['leadingIcon'], fallback: DsIconName) {
  const resolved = icon ?? fallback;
  if (typeof resolved === 'string' || typeof resolved === 'function') {
    const Comp = resolveIcon(resolved as DsIconName | IconComponent);
    return Comp ? <Comp size={20} aria-hidden className={styles.icon} /> : null;
  }
  return resolved;
}

export const Autocomplete = forwardRef<HTMLInputElement, AutocompleteProps>(function Autocomplete(
  {
    state = 'default',
    content = 'empty',
    expanded = false,
    appearance = 'default',
    label = 'Label',
    placeholder = 'Placeholder',
    query,
    selectedValue,
    value,
    defaultValue,
    supportingText = 'Supporting text',
    showSupportingText = true,
    showLeadingIcon = true,
    leadingIcon,
    showClearAction = true,
    loading = false,
    listboxId,
    disabled = false,
    className,
    id,
    onClear,
    ...rest
  },
  ref,
) {
  const autoId = useId();
  const inputId = id ?? autoId;
  const supportId = `${inputId}-support`;
  const isDisabled = disabled || state === 'disabled';
  const isError = state === 'error';
  const isExpanded = expanded && !isDisabled;
  const Loader = resolveIcon('loader-outline');

  const resolvedValue =
    value ??
    (content === 'selected'
      ? (selectedValue ?? 'Selected')
      : content === 'query'
        ? (query ?? 'Query')
        : query);

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
      {showLeadingIcon && slotIcon(leadingIcon, 'search-outline')}
      <input
        ref={ref}
        id={inputId}
        className={styles.control}
        role="combobox"
        disabled={isDisabled}
        placeholder={content === 'empty' ? placeholder : placeholder}
        value={resolvedValue}
        defaultValue={defaultValue}
        aria-autocomplete="list"
        aria-expanded={isExpanded}
        aria-controls={isExpanded ? listboxId : undefined}
        aria-invalid={isError || undefined}
        aria-describedby={showSupportingText ? supportId : undefined}
        {...rest}
      />
      {loading
        ? Loader && <Loader size={20} aria-hidden className={cx(styles.icon, styles.spinner)} />
        : showClearAction &&
          content !== 'empty' && (
            <Button
              variant="text"
              size="sm"
              intent="primary"
              showLabel={false}
              showIcon
              icon="x-outline"
              aria-label="Clear"
              disabled={isDisabled}
              onClick={onClear}
            />
          )}
    </FieldFrame>
  );
});

Autocomplete.displayName = 'Autocomplete';
