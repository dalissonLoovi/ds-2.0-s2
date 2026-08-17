import { forwardRef, useId, type InputHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import styles from './SearchBar.module.css';

export type SearchBarState = 'default' | 'hover' | 'focus' | 'pressed' | 'disabled';
export type SearchBarContent = 'placeholder' | 'value';

export type SearchBarProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'disabled' | 'size'> & {
  state?: SearchBarState;
  content?: SearchBarContent;
  query?: string;
  showLeadingAction?: boolean;
  showFirstTrailingAction?: boolean;
  showSecondTrailingAction?: boolean;
  showProfileAction?: boolean;
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  firstTrailingIcon?: DsIconName | IconComponent | ReactNode;
  secondTrailingIcon?: DsIconName | IconComponent | ReactNode;
  profileAvatar?: ReactNode;
  disabled?: boolean;
  onLeadingAction?: () => void;
  onFirstTrailingAction?: () => void;
  onSecondTrailingAction?: () => void;
  onProfileAction?: () => void;
};

function actionIcon(icon: SearchBarProps['leadingIcon'], fallback: DsIconName) {
  const resolved = icon ?? fallback;
  if (typeof resolved === 'string' || typeof resolved === 'function') {
    return resolved as DsIconName | IconComponent;
  }
  return fallback;
}

export const SearchBar = forwardRef<HTMLInputElement, SearchBarProps>(function SearchBar(
  {
    state = 'default',
    content = 'placeholder',
    placeholder = 'Search',
    query,
    value,
    defaultValue,
    showLeadingAction = true,
    showFirstTrailingAction = true,
    showSecondTrailingAction = false,
    showProfileAction = false,
    leadingIcon = 'search-outline',
    firstTrailingIcon = 'x-outline',
    secondTrailingIcon = 'plus-outline',
    profileAvatar,
    disabled = false,
    className,
    id,
    onLeadingAction,
    onFirstTrailingAction,
    onSecondTrailingAction,
    onProfileAction,
    ...rest
  },
  ref,
) {
  const autoId = useId();
  const inputId = id ?? autoId;
  const isDisabled = disabled || state === 'disabled';
  const showValue = content === 'value' || query != null || value != null;

  return (
    <div
      className={cx(styles.root, styles[`state-${state}`], isDisabled && styles.disabled, className)}
      role="search"
      data-state={isDisabled ? 'disabled' : state}
    >
      <div className={styles.pill}>
        {showLeadingAction && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon={actionIcon(leadingIcon, 'search-outline')}
            aria-label="Search"
            disabled={isDisabled}
            onClick={onLeadingAction}
          />
        )}
        <input
          ref={ref}
          id={inputId}
          className={styles.control}
          disabled={isDisabled}
          placeholder={placeholder}
          value={showValue ? (value ?? query) : value}
          defaultValue={
            defaultValue ??
            (content === 'value' && value === undefined && query === undefined ? 'Query' : undefined)
          }
          {...rest}
        />
        {showFirstTrailingAction && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon={actionIcon(firstTrailingIcon, 'x-outline')}
            aria-label="Clear"
            disabled={isDisabled}
            onClick={onFirstTrailingAction}
          />
        )}
        {showSecondTrailingAction && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon={actionIcon(secondTrailingIcon, 'plus-outline')}
            aria-label="More"
            disabled={isDisabled}
            onClick={onSecondTrailingAction}
          />
        )}
        {showProfileAction && (
          <button
            type="button"
            className={styles.profile}
            aria-label="Profile"
            disabled={isDisabled}
            onClick={onProfileAction}
          >
            {profileAvatar ?? <span className={styles.avatarFallback} aria-hidden />}
          </button>
        )}
      </div>
    </div>
  );
});

SearchBar.displayName = 'SearchBar';
