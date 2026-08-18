import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { Avatar } from '../Avatar/Avatar';
import { CardElevatedItem, type CardElevatedItemState } from '../CardElevatedItem/CardElevatedItem';
import { CardFilledItem } from '../CardFilledItem/CardFilledItem';
import { CardOutlinedItem } from '../CardOutlinedItem/CardOutlinedItem';
import styles from './CardHorizontal.module.css';

export type CardHorizontalStyle = 'outlined' | 'elevated' | 'filled';
export type CardHorizontalLayout = 'media-and-text' | 'slot';
export type CardHorizontalSurfaceState = CardElevatedItemState;

export type CardHorizontalProps = Omit<HTMLAttributes<HTMLElement>, 'style'> & {
  /** Figma variant `style` — renamed to avoid clashing with CSS `style`. */
  cardStyle?: CardHorizontalStyle;
  layout?: CardHorizontalLayout;
  headerText?: string;
  subheadText?: string;
  mediaSrc?: string;
  mediaAlt?: string;
  surfaceState?: CardHorizontalSurfaceState;
  showFocusIndicator?: boolean;
  children?: ReactNode;
};

function Surface({
  cardStyle,
  state,
  showFocusIndicator,
  className,
}: {
  cardStyle: CardHorizontalStyle;
  state: CardHorizontalSurfaceState;
  showFocusIndicator: boolean;
  className?: string;
}) {
  const shared = { state, showFocusIndicator, className, 'aria-hidden': true as const };
  if (cardStyle === 'elevated') return <CardElevatedItem {...shared} />;
  if (cardStyle === 'filled') return <CardFilledItem {...shared} />;
  return <CardOutlinedItem {...shared} />;
}

export function CardHorizontal({
  cardStyle = 'outlined',
  layout = 'media-and-text',
  headerText = 'Header',
  subheadText = 'Subhead',
  mediaSrc,
  mediaAlt = '',
  surfaceState = 'enabled',
  showFocusIndicator = true,
  className,
  children,
  ...rest
}: CardHorizontalProps) {
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
            <div className={styles.body}>
              <Avatar size="sm" content="initials" initials="AL" />
              <div className={styles.text}>
                <p className={styles.header}>{headerText}</p>
                <p className={styles.subhead}>{subheadText}</p>
              </div>
            </div>
            <div className={styles.media}>
              {mediaSrc ? <img src={mediaSrc} alt={mediaAlt} /> : <span aria-hidden />}
            </div>
          </>
        )}
      </div>
    </article>
  );
}
