import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import styles from './SectionHeader.module.css';

export type SectionHeaderEmphasis = 'primary' | 'secondary';

export type SectionHeaderProps = HTMLAttributes<HTMLElement> & {
  emphasis?: SectionHeaderEmphasis;
  showAction?: boolean;
  title?: string;
  actionLabel?: string;
  onAction?: () => void;
};

export function SectionHeader({
  emphasis = 'primary',
  showAction = false,
  title = 'Section',
  actionLabel = 'See all',
  onAction,
  className,
  ...rest
}: SectionHeaderProps) {
  const TitleTag = emphasis === 'primary' ? 'h2' : 'h3';

  return (
    <header
      className={cx(styles.root, styles[`emphasis-${emphasis}`], className)}
      data-emphasis={emphasis}
      data-show-action={showAction}
      {...rest}
    >
      <TitleTag className={styles.title}>{title}</TitleTag>
      {showAction && (
        <Button
          variant="text"
          size="sm"
          intent="primary"
          showLabel={false}
          showIcon
          icon="arrow-narrow-right-outline"
          aria-label={actionLabel}
          onClick={onAction}
        />
      )}
    </header>
  );
}
