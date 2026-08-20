import { useMemo, type HTMLAttributes, type KeyboardEvent } from 'react';
import { cx } from '../../utils/cx';
import { TabItem, type TabItemAppearance, type TabItemPlatform } from '../TabItem/TabItem';
import styles from './TabsPrimary.module.css';

export type TabsPrimaryItemCount = '2' | '3' | '4' | '5';
export type TabsPrimaryAlignment = 'left' | 'center';

export type TabsPrimaryProps = Omit<HTMLAttributes<HTMLDivElement>, 'onSelect'> & {
  itemCount?: TabsPrimaryItemCount;
  platform?: TabItemPlatform;
  alignment?: TabsPrimaryAlignment;
  appearance?: TabItemAppearance;
  selectedIndex?: number;
  labels?: string[];
  onSelect?: (index: number) => void;
};

const DEFAULT_LABELS = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'];

export function TabsPrimary({
  itemCount = '3',
  platform = 'web',
  alignment = 'left',
  appearance = 'default',
  selectedIndex = 0,
  labels,
  onSelect,
  className,
  onKeyDown,
  ...rest
}: TabsPrimaryProps) {
  const count = Number(itemCount);
  const inverse = appearance === 'inverse' && platform === 'mobile';
  const items = useMemo(
    () => Array.from({ length: count }, (_, i) => labels?.[i] ?? DEFAULT_LABELS[i]),
    [count, labels],
  );

  const handleKey = (event: KeyboardEvent<HTMLDivElement>) => {
    if (event.key === 'ArrowRight' || event.key === 'ArrowLeft') {
      event.preventDefault();
      const dir = event.key === 'ArrowRight' ? 1 : -1;
      onSelect?.((selectedIndex + dir + count) % count);
    }
    onKeyDown?.(event);
  };

  return (
    <div
      className={cx(
        styles.root,
        styles[`alignment-${alignment}`],
        inverse && styles.inverse,
        className,
      )}
      role="tablist"
      data-item-count={itemCount}
      data-platform={platform}
      data-appearance={inverse ? 'inverse' : 'default'}
      onKeyDown={handleKey}
      {...rest}
    >
      {items.map((label, index) => (
        <TabItem
          key={label}
          variant="primary"
          platform={platform}
          appearance={inverse ? 'inverse' : 'default'}
          state={index === selectedIndex ? 'selected' : 'default'}
          label={label}
          onClick={() => onSelect?.(index)}
        />
      ))}
    </div>
  );
}
