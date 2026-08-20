import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { Avatar } from '../Avatar/Avatar';
import { Button } from '../Button/Button';
import { CardElevatedItem, type CardElevatedItemState } from '../CardElevatedItem/CardElevatedItem';
import { CardFilledItem } from '../CardFilledItem/CardFilledItem';
import { CardOutlinedItem } from '../CardOutlinedItem/CardOutlinedItem';
import styles from './CardStacked.module.css';

export type CardStackedStyle = 'outlined' | 'elevated' | 'filled';
export type CardStackedLayout = 'media-and-text' | 'slot';
export type CardStackedSurfaceState = CardElevatedItemState;

export type CardStackedProps = Omit<HTMLAttributes<HTMLElement>, 'style'> & {
  /** Figma variant `style` — renamed to avoid clashing with CSS `style`. */
  cardStyle?: CardStackedStyle;
  layout?: CardStackedLayout;
  headerText?: string;
  subheadText?: string;
  titleText?: string;
  subtitleText?: string;
  supportingText?: string;
  showSecondaryAction?: boolean;
  primaryActionLabel?: string;
  secondaryActionLabel?: string;
  mediaSrc?: string;
  mediaAlt?: string;
  surfaceState?: CardStackedSurfaceState;
  showFocusIndicator?: boolean;
  children?: ReactNode;
};

function Surface({
  cardStyle,
  state,
  showFocusIndicator,
  className,
}: {
  cardStyle: CardStackedStyle;
  state: CardStackedSurfaceState;
  showFocusIndicator: boolean;
  className?: string;
}) {
  const shared = { state, showFocusIndicator, className, 'aria-hidden': true as const };
  if (cardStyle === 'elevated') return <CardElevatedItem {...shared} />;
  if (cardStyle === 'filled') return <CardFilledItem {...shared} />;
  return <CardOutlinedItem {...shared} />;
}

export function CardStacked({
  cardStyle = 'outlined',
  layout = 'media-and-text',
  headerText = 'Header',
  subheadText = 'Subhead',
  titleText = 'Title',
  subtitleText = 'Subtitle',
  supportingText = 'Supporting text',
  showSecondaryAction = true,
  primaryActionLabel = 'Action',
  secondaryActionLabel = 'Action',
  mediaSrc,
  mediaAlt = '',
  surfaceState = 'enabled',
  showFocusIndicator = true,
  className,
  children,
  ...rest
}: CardStackedProps) {
  return (
    <article
      className={cx(styles.root, className)}
      data-style={cardStyle}
      data-layout={layout}
      {...rest}
    >
      <Surface
        cardStyle={cardStyle}
        state={surfaceState}
        showFocusIndicator={showFocusIndicator}
        className={styles.background}
      />
      <div className={styles.content}>
        {layout === 'slot' ? (
          <div className={styles.slot}>{children}</div>
        ) : (
          <>
            <div className={styles.headerRow}>
              <div className={styles.leading}>
                <Avatar size="md" content="initials" initials="AL" />
                <div className={styles.headerText}>
                  <p className={styles.header}>{headerText}</p>
                  <p className={styles.subhead}>{subheadText}</p>
                </div>
              </div>
              <Button
                variant="text"
                size="sm"
                intent="primary"
                showLabel={false}
                showIcon
                icon="dots-vertical-outline"
                aria-label="More"
              />
            </div>
            <div className={styles.media}>
              {mediaSrc ? <img src={mediaSrc} alt={mediaAlt} /> : <span aria-hidden />}
            </div>
            <div className={styles.body}>
              <div className={styles.headline}>
                <p className={styles.title}>{titleText}</p>
                <p className={styles.subtitle}>{subtitleText}</p>
              </div>
              <p className={styles.supporting}>{supportingText}</p>
              <div className={styles.actions}>
                {showSecondaryAction && (
                  <Button variant="outline" size="sm" intent="primary" label={secondaryActionLabel} />
                )}
                <Button variant="solid" size="sm" intent="primary" label={primaryActionLabel} />
              </div>
            </div>
          </>
        )}
      </div>
    </article>
  );
}
