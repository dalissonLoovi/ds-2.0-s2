import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import styles from './ModalHeader.module.css';

export type ModalHeaderLayout = 'desktop' | 'mobile';
export type ModalHeaderAlignment = 'start' | 'center';

export type ModalHeaderProps = HTMLAttributes<HTMLElement> & {
  layout?: ModalHeaderLayout;
  alignment?: ModalHeaderAlignment;
  title?: string;
  label?: string;
  showLabel?: boolean;
  showCloseAction?: boolean;
  onClose?: () => void;
  titleId?: string;
};

export function ModalHeader({
  layout = 'desktop',
  alignment = 'start',
  title = 'Title',
  label = 'Label',
  showLabel = false,
  showCloseAction = true,
  onClose,
  titleId,
  className,
  ...rest
}: ModalHeaderProps) {
  return (
    <header
      className={cx(
        styles.root,
        styles[`layout-${layout}`],
        styles[`alignment-${alignment}`],
        className,
      )}
      data-layout={layout}
      data-alignment={alignment}
      {...rest}
    >
      {alignment === 'center' && <span className={styles.leadingSpacer} aria-hidden />}
      <div className={styles.heading}>
        {showLabel && <p className={styles.label}>{label}</p>}
        <h2 id={titleId} className={styles.title}>
          {title}
        </h2>
      </div>
      <div className={styles.trailing}>
        {showCloseAction && (
          <span className={styles.closeWrap}>
            <Button
              variant="text"
              size="sm"
              intent="primary"
              showLabel={false}
              showIcon
              icon="x-outline"
              aria-label="Fechar modal"
              onClick={onClose}
            />
          </span>
        )}
      </div>
    </header>
  );
}
