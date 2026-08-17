import { useMemo, type HTMLAttributes, type KeyboardEvent } from 'react';
import { cx } from '../../utils/cx';
import { TabItem, type TabItemPlatform } from '../TabItem/TabItem';
import styles from './TabsSegmented.module.css';

export type TabsSegmentedItemCount = '2' | '3' | '4' | '5';
export type TabsSegmentedAlignment = 'left' | 'center';

export type TabsSegmentedProps = Omit<HTMLAttributes<HTMLDivElement>, 'onSelect'> & {
  itemCount?: TabsSegmentedItemCount;
  platform?: TabItemPlatform;
  alignment?: TabsSegmentedAlignment;
  selectedIndex?: number;
  labels?: string[];
  onSelect?: (index: number) => void;
};

const DEFAULT_LABELS = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'];

export function TabsSegmented({
  itemCount = '3',
  platform = 'web',
  alignment = 'left',
  selectedIndex = 0,
  labels,
  onSelect,
  className,
  onKeyDown,
  ...rest
}: TabsSegmentedProps) {
  const count = Number(itemCount);
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
      className={cx(styles.root, styles[`alignment-${alignment}`], className)}
      role="tablist"
      data-item-count={itemCount}
      data-platform={platform}
      onKeyDown={handleKey}
      {...rest}
    >
      {items.map((label, index) => (
        <TabItem
          key={label}
          variant="segmented"
          platform={platform}
          state={index === selectedIndex ? 'selected' : 'default'}
          label={label}
          onClick={() => onSelect?.(index)}
        />
      ))}
    </div>
  );
}
