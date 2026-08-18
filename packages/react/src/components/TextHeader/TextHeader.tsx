import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './TextHeader.module.css';

export type TextHeaderSize = 'large' | 'medium' | 'small';
export type TextHeaderAlignment = 'left' | 'center';

export type TextHeaderProps = HTMLAttributes<HTMLElement> & {
  size?: TextHeaderSize;
  alignment?: TextHeaderAlignment;
  title?: string;
  description?: string;
  showDescription?: boolean;
  inverse?: boolean;
};

const TITLE_TAG = { large: 'h1', medium: 'h2', small: 'h3' } as const;

export function TextHeader({
  size = 'large',
  alignment = 'left',
  title = 'Title',
  description = 'Description',
  showDescription = true,
  inverse = false,
  className,
  ...rest
}: TextHeaderProps) {
  const TitleTag = TITLE_TAG[size];

  return (
    <header
      className={cx(
        styles.root,
        styles[`size-${size}`],
        styles[`alignment-${alignment}`],
        inverse && styles.inverse,
        className,
      )}
      data-size={size}
      data-alignment={alignment}
      {...rest}
    >
      <TitleTag className={styles.title}>{title}</TitleTag>
      {showDescription && <p className={styles.description}>{description}</p>}
    </header>
  );
}
