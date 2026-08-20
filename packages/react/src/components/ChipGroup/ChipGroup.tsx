import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { ChipClickable } from '../ChipClickable/ChipClickable';
import styles from './ChipGroup.module.css';

export type ChipGroupType = 'input' | 'assistive' | 'filter' | 'suggestion';
export type ChipGroupLayout = 'single-row-scrollable' | 'multi-row-wrap';

export type ChipGroupProps = HTMLAttributes<HTMLDivElement> & {
  type?: ChipGroupType;
  layout?: ChipGroupLayout;
  label?: string;
  children?: ReactNode;
};

const DEMO = ['Chip 01', 'Chip 02', 'Chip 03', 'Chip 04', 'Chip 05', 'Chip 06', 'Chip 07', 'Chip 08', 'Chip 09'];

export function ChipGroup({
  type = 'input',
  layout = 'single-row-scrollable',
  label = 'Chip group',
  children,
  className,
  ...rest
}: ChipGroupProps) {
  return (
    <div
      className={cx(styles.root, styles[`layout-${layout}`], className)}
      role="group"
      aria-label={label}
      data-type={type}
      data-layout={layout}
      {...rest}
    >
      {children ??
        DEMO.map((chip, index) => (
          <ChipClickable
            key={chip}
            size="sm"
            intent="outline"
            width="hug"
            label={chip}
            selected={type === 'filter' && index === 0}
            state={type === 'filter' && index === 0 ? 'selected' : 'default'}
            showAvatar={false}
            showDeleteAction={false}
          />
        ))}
    </div>
  );
}
