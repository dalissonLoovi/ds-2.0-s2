import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import styles from './BottomSheetHeader.module.css';

export type BottomSheetHeaderAppearance = 'default';

export type BottomSheetHeaderProps = HTMLAttributes<HTMLElement> & {
  appearance?: BottomSheetHeaderAppearance;
  title?: string;
  showLabel?: boolean;
  showOptionsAction?: boolean;
  showLeadingAction?: boolean;
  showCloseAction?: boolean;
  onOptions?: () => void;
  onLeadingAction?: () => void;
  onClose?: () => void;
  titleId?: string;
};

export function BottomSheetHeader({
  appearance = 'default',
  title = 'Title',
  showLabel = true,
  showOptionsAction = false,
  showLeadingAction = false,
  showCloseAction = true,
  onOptions,
  onLeadingAction,
  onClose,
  titleId,
  className,
  ...rest
}: BottomSheetHeaderProps) {
  return (
    <header
      className={cx(styles.root, styles[`appearance-${appearance}`], className)}
      data-appearance={appearance}
      {...rest}
    >
      <div className={styles.leading}>
        {showLeadingAction && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon="arrow-left-outline"
            aria-label="Ação"
            onClick={onLeadingAction}
          />
        )}
        {showOptionsAction && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon="dots-vertical-outline"
            aria-label="Opções"
            onClick={onOptions}
          />
        )}
      </div>
      <div className={styles.titleSlot}>
        {showLabel && (
          <h2 id={titleId} className={styles.title}>
            {title}
          </h2>
        )}
      </div>
      <div className={styles.trailing}>
        {showCloseAction && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon="x-outline"
            aria-label="Fechar"
            onClick={onClose}
          />
        )}
      </div>
    </header>
  );
}
