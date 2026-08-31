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
import { ListItemLeadingPaymentMark } from '../ListItemLeadingPaymentMark/ListItemLeadingPaymentMark';
import { ListItemLeadingIllustration } from '../ListItemLeadingIllustration/ListItemLeadingIllustration';
import { ListItemTrailingIllustration } from '../ListItemTrailingIllustration/ListItemTrailingIllustration';
import styles from './ListItem.module.css';

export type ListItemCondition = '1-line' | '2-line' | '3-line';
export type ListItemLeading =
  | 'none'
  | 'monogram'
  | 'icon'
  | 'image'
  | 'video'
  | 'payment-mark'
  | 'illustration'
  | 'checkbox'
  | 'radio'
  | 'switch';
/** Trailing slot: none | icon | illustration | checkbox | radio | switch */
export type ListItemTrailing = 'none' | 'icon' | 'illustration' | 'checkbox' | 'radio' | 'switch';

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
  /** kebab-case slug for leading=payment-mark demo (payment-method/{brand}) */
  paymentMethodBrand?: string | null;
  paymentMethodMark?: ReactNode;
  /** Asset slug for leading=illustration (any illustration/* from Ilustrações e animações; default demo sedan) */
  leadingIllustrationAsset?: string | null;
  /** React node from illustrations library — maps to Figma leadingIllustration INSTANCE_SWAP */
  leadingIllustration?: ReactNode;
  /** Asset slug for trailing=illustration (any illustration/*; default demo sedan) */
  trailingIllustrationAsset?: string | null;
  /** React node from illustrations library — maps to Figma trailingIllustration INSTANCE_SWAP */
  trailingIllustration?: ReactNode;
  /**
   * @deprecated Prefer leadingIllustrationAsset / trailingIllustrationAsset (separate sides).
   * When set, fills both sides that do not have a side-specific asset. Default demo base: sedan.
   */
  illustrationAsset?: string | null;
  /** @deprecated Prefer leadingIllustration / trailingIllustration */
  illustration?: ReactNode;
  children?: ReactNode;
};

function leadingSlot(
  leading: ListItemLeading,
  paymentMethodBrand?: string | null,
  paymentMethodMark?: ReactNode,
  leadingIllustrationAsset?: string | null,
  leadingIllustration?: ReactNode,
) {
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
    case 'payment-mark':
      return (
        <ListItemLeadingPaymentMark brand={paymentMethodBrand} paymentMethodMark={paymentMethodMark} />
      );
    case 'illustration':
      return (
        <ListItemLeadingIllustration
          illustrationAsset={leadingIllustrationAsset}
          illustration={leadingIllustration}
        />
      );
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

function trailingSlot(
  trailing: ListItemTrailing,
  trailingIllustrationAsset?: string | null,
  trailingIllustration?: ReactNode,
) {
  const Chevron = resolveIcon('chevron-right-outline');
  switch (trailing) {
    case 'icon':
      return Chevron ? <Chevron size={20} aria-hidden /> : null;
    case 'illustration':
      return (
        <ListItemTrailingIllustration
          illustrationAsset={trailingIllustrationAsset}
          illustration={trailingIllustration}
        />
      );
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
  paymentMethodBrand = 'visa',
  paymentMethodMark,
  leadingIllustrationAsset,
  leadingIllustration,
  trailingIllustrationAsset,
  trailingIllustration,
  illustrationAsset = 'sedan',
  illustration,
  className,
  children,
  ...rest
}: ListItemProps) {
  const leadAsset = leadingIllustrationAsset ?? illustrationAsset;
  const trailAsset = trailingIllustrationAsset ?? illustrationAsset;
  const leadNode = leadingIllustration ?? illustration;
  const trailNode = trailingIllustration ?? illustration;

  const inner = (
    <>
      <ListItemStateLayer state={stateLayer} />
      {leading !== 'none' && (
        <span className={styles.leading}>
          {leadingSlot(leading, paymentMethodBrand, paymentMethodMark, leadAsset, leadNode)}
        </span>
      )}
      <span className={styles.content}>
        {showOverline && <span className={styles.overline}>{overline}</span>}
        <span className={styles.headline}>{headline}</span>
        {showSupportingText && condition !== '1-line' && (
          <span className={styles.supporting}>{supportingText}</span>
        )}
        {children}
      </span>
      {showTrailingSupportingText && <span className={styles.meta}>{trailingSupportingText}</span>}
      {trailing !== 'none' && (
        <span className={styles.trailing}>
          {trailingSlot(trailing, trailAsset, trailNode)}
        </span>
      )}
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
