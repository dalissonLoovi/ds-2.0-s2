import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import { DividerHorizontal } from '../DividerHorizontal/DividerHorizontal';
import { ListItem } from '../ListItem/ListItem';
import styles from './SearchViewModal.module.css';

export type SearchViewModalContent = 'value' | 'placeholder';

export type SearchViewModalProps = HTMLAttributes<HTMLDivElement> & {
  content?: SearchViewModalContent;
  showResults?: boolean;
  query?: string;
  placeholder?: string;
  showBack?: boolean;
  showClear?: boolean;
  backIcon?: DsIconName | IconComponent;
  clearIcon?: DsIconName | IconComponent;
  onBack?: () => void;
  onClear?: () => void;
  onQueryChange?: (value: string) => void;
  children?: ReactNode;
};

const DEFAULT_RESULTS = ['Ana Lima', 'Bruno Costa', 'Carla Dias', 'Diego Alves', 'Eva Martins'];

export function SearchViewModal({
  content = 'placeholder',
  showResults = true,
  query = 'Query',
  placeholder = 'Search',
  showBack = true,
  showClear,
  backIcon = 'arrow-narrow-left-outline',
  clearIcon = 'x-outline',
  onBack,
  onClear,
  onQueryChange,
  children,
  className,
  ...rest
}: SearchViewModalProps) {
  const clearVisible = showClear ?? content === 'value';
  const display = content === 'value' ? query : '';

  return (
    <div className={cx(styles.root, className)} role="search" data-content={content} {...rest}>
      <div className={styles.header}>
        {showBack && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon={backIcon}
            aria-label="Back"
            onClick={onBack}
          />
        )}
        <input
          className={styles.field}
          value={display}
          placeholder={placeholder}
          aria-label={placeholder}
          onChange={(event) => onQueryChange?.(event.target.value)}
        />
        {clearVisible && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon={clearIcon}
            aria-label="Clear"
            onClick={onClear}
          />
        )}
      </div>
      {showResults && (
        <>
          <DividerHorizontal variant="full-width" />
          <ul className={styles.results}>
            {children ??
              DEFAULT_RESULTS.map((name) => (
                <ListItem
                  key={name}
                  condition="2-line"
                  leading="monogram"
                  headline={name}
                  supportingText="Supporting text"
                />
              ))}
          </ul>
        </>
      )}
    </div>
  );
}
