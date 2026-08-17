import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import { Checkbox } from '../Checkbox/Checkbox';
import { RadioButton } from '../RadioButton/RadioButton';
import { Switch } from '../Switch/Switch';
import { DividerHorizontal } from '../DividerHorizontal/DividerHorizontal';
import { ListItemStateLayer, type ListItemStateLayerState } from '../ListItemStateLayer/ListItemStateLayer';
import { ListItemLeadingMonogram } from '../ListItemLeadingMonogram/ListItemLeadingMonogram';
import { ListItemImageThumbnail } from '../ListItemImageThumbnail/ListItemImageThumbnail';
import { ListItemVideoThumbnail } from '../ListItemVideoThumbnail/ListItemVideoThumbnail';
import styles from './ListItem.module.css';

export type ListItemCondition = '1-line' | '2-line' | '3-line';
export type ListItemLeading =
  | 'none'
  | 'monogram'
  | 'icon'
  | 'image'
  | 'video'
  | 'checkbox'
  | 'radio'
  | 'switch';
export type ListItemTrailing = 'none' | 'icon' | 'checkbox' | 'radio' | 'switch';

export type ListItemProps = HTMLAttributes<HTMLLIElement> & {
  condition?: ListItemCondition;
  leading?: ListItemLeading;
  trailing?: ListItemTrailing;
  showOverline?: boolean;
  showSupportingText?: boolean;
  headline?: string;
  overline?: string;
  supportingText?: string;
  trailingSupportingText?: string;
  showTrailingSupportingText?: boolean;
  showDivider?: boolean;
  stateLayer?: ListItemStateLayerState;
  href?: string;
  as?: 'li' | 'div';
  children?: ReactNode;
};

function leadingSlot(leading: ListItemLeading) {
  const User = resolveIcon('user-outline');
  switch (leading) {
    case 'monogram':
      return <ListItemLeadingMonogram initial="A" />;
    case 'icon':
      return User ? <User size={20} aria-hidden className={styles.leadIcon} /> : null;
    case 'image':
      return <ListItemImageThumbnail />;
    case 'video':
      return <ListItemVideoThumbnail />;
    case 'checkbox':
      return <Checkbox showLabel={false} showContent={false} aria-label="Select" />;
    case 'radio':
      return <RadioButton showLabel={false} showContent={false} aria-label="Select" />;
    case 'switch':
      return <Switch size="md" aria-label="Toggle" />;
    default:
      return null;
  }
}

function trailingSlot(trailing: ListItemTrailing) {
  const Chevron = resolveIcon('chevron-right-outline');
  switch (trailing) {
    case 'icon':
      return Chevron ? <Chevron size={20} aria-hidden /> : null;
    case 'checkbox':
      return <Checkbox showLabel={false} showContent={false} aria-label="Select" />;
    case 'radio':
      return <RadioButton showLabel={false} showContent={false} aria-label="Select" />;
    case 'switch':
      return <Switch size="md" aria-label="Toggle" />;
    default:
      return null;
  }
}

export function ListItem({
  condition = '3-line',
  leading = 'none',
  trailing = 'none',
  showOverline = false,
  showSupportingText = true,
  headline = 'Headline',
  overline = 'Overline',
  supportingText = 'Supporting text',
  trailingSupportingText = 'Meta',
  showTrailingSupportingText = false,
  showDivider = false,
  stateLayer = 'default',
  href,
  as = 'li',
  className,
  children,
  ...rest
}: ListItemProps) {
  const inner = (
    <>
      <ListItemStateLayer state={stateLayer} />
      {leading !== 'none' && <span className={styles.leading}>{leadingSlot(leading)}</span>}
      <span className={styles.content}>
        {showOverline && <span className={styles.overline}>{overline}</span>}
        <span className={styles.headline}>{headline}</span>
        {showSupportingText && condition !== '1-line' && (
          <span className={styles.supporting}>{supportingText}</span>
        )}
        {children}
      </span>
      {showTrailingSupportingText && <span className={styles.meta}>{trailingSupportingText}</span>}
      {trailing !== 'none' && <span className={styles.trailing}>{trailingSlot(trailing)}</span>}
    </>
  );

  const rootClass = cx(styles.root, styles[`condition-${condition}`], className);
  const content = (
    <>
      {href ? (
        <a className={styles.row} href={href}>
          {inner}
        </a>
      ) : (
        <div className={styles.row}>{inner}</div>
      )}
      {showDivider && <DividerHorizontal variant="inset" />}
    </>
  );

  if (as === 'div') {
    return (
      <div
        className={rootClass}
        data-condition={condition}
        data-leading={leading}
        data-trailing={trailing}
      >
        {content}
      </div>
    );
  }

  return (
    <li
      className={rootClass}
      data-condition={condition}
      data-leading={leading}
      data-trailing={trailing}
      {...rest}
    >
      {content}
    </li>
  );
}
