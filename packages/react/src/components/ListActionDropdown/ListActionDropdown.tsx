import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { DividerHorizontal } from '../DividerHorizontal/DividerHorizontal';
import { ListActionDropdownItem } from '../ListActionDropdownItem/ListActionDropdownItem';
import styles from './ListActionDropdown.module.css';

export type ListActionDropdownProps = HTMLAttributes<HTMLDivElement> & {
  showScroll?: boolean;
  showDivider?: boolean;
  children?: ReactNode;
};

export function ListActionDropdown({
  showScroll = false,
  showDivider = false,
  children,
  className,
  ...rest
}: ListActionDropdownProps) {
  return (
    <div
      className={cx(styles.root, showScroll && styles.scroll, className)}
      role="menu"
      data-show-scroll={showScroll}
      data-show-divider={showDivider}
      {...rest}
    >
      {children ?? (
        <>
          <ListActionDropdownItem label="Edit" icon="edit-outline" />
          <ListActionDropdownItem label="Copy" icon="copy-outline" />
          <ListActionDropdownItem label="Delete" icon="trash-outline" />
        </>
      )}
      {showDivider && <DividerHorizontal variant="full-width" />}
    </div>
  );
}
