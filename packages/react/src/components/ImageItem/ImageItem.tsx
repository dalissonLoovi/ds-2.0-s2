import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { PhotoTextItem } from '../PhotoTextItem/PhotoTextItem';
import styles from './ImageItem.module.css';

export type ImageItemAspectRatio = '1-1' | '4-3' | '3-2' | '16-9' | '2-1';
export type ImageItemOrientation = 'portrait' | 'landscape';

export type ImageItemProps = HTMLAttributes<HTMLElement> & {
  aspectRatio?: ImageItemAspectRatio;
  orientation?: ImageItemOrientation;
  verticalResize?: boolean;
  showOrientationItem?: boolean;
  showPhotoTextItem?: boolean;
  src?: string;
  alt?: string;
  overlayLabel?: string;
  overlaySupportingText?: string;
  showOverlaySupportingText?: boolean;
};

const RATIO: Record<ImageItemAspectRatio, string> = {
  '1-1': '1 / 1',
  '4-3': '4 / 3',
  '3-2': '3 / 2',
  '16-9': '16 / 9',
  '2-1': '2 / 1',
};

function cssRatio(aspectRatio: ImageItemAspectRatio, orientation: ImageItemOrientation) {
  const [w, h] = RATIO[aspectRatio].split(' / ').map(Number);
  if (orientation === 'portrait' && w !== h) return `${h} / ${w}`;
  return RATIO[aspectRatio];
}

export function ImageItem({
  aspectRatio = '1-1',
  orientation = 'landscape',
  verticalResize = false,
  showOrientationItem = false,
  showPhotoTextItem = false,
  src,
  alt = '',
  overlayLabel = 'Label',
  overlaySupportingText = 'Supporting text',
  showOverlaySupportingText = false,
  className,
  style,
  ...rest
}: ImageItemProps) {
  const ratio = cssRatio(aspectRatio, orientation);

  return (
    <figure
      className={cx(
        styles.root,
        verticalResize ? styles.verticalResize : styles.lockWidth,
        className,
      )}
      data-aspect-ratio={aspectRatio}
      data-orientation={orientation}
      data-vertical-resize={verticalResize}
      style={{ ...style, aspectRatio: ratio }}
      {...rest}
    >
      <span className={styles.imageSurface}>
        {src ? <img src={src} alt={alt} /> : <span className={styles.placeholder} aria-hidden />}
      </span>
      {showPhotoTextItem && (
        <div className={styles.photoTextSlot}>
          <PhotoTextItem
            label={overlayLabel}
            supportingText={overlaySupportingText}
            showSupportingText={showOverlaySupportingText}
          />
        </div>
      )}
      {showOrientationItem && (
        <span className={styles.orientation} aria-hidden>
          {orientation}
        </span>
      )}
    </figure>
  );
}
