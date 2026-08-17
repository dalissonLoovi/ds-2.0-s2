import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import styles from './OfferProductCard.module.css';

export type OfferProductCardState = 'default';

export type OfferProductCardProps = HTMLAttributes<HTMLElement> & {
  state?: OfferProductCardState;
  title?: string;
  description?: string;
  price?: string;
  pricePeriod?: string;
  icon?: DsIconName | IconComponent;
  ctaLabel?: string;
  onCta?: () => void;
};

export function OfferProductCard({
  state = 'default',
  title = 'Title',
  description = 'Description',
  price = 'R$ 0,00',
  pricePeriod = '/mês',
  icon = 'package-outline',
  ctaLabel = 'Label',
  onCta,
  className,
  ...rest
}: OfferProductCardProps) {
  const Icon = typeof icon === 'string' || typeof icon === 'function' ? resolveIcon(icon) : null;

  return (
    <article
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <span className={styles.iconContainer} aria-hidden>
        {Icon ? <Icon size={24} /> : null}
      </span>
      <div className={styles.text}>
        <p className={styles.title}>{title}</p>
        <p className={styles.description}>{description}</p>
      </div>
      <p className={styles.priceRow}>
        <span className={styles.price}>{price}</span>
        <span className={styles.period}>{pricePeriod}</span>
      </p>
      <Button variant="solid" size="sm" intent="primary" label={ctaLabel} onClick={onCta} />
    </article>
  );
}
