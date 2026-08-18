import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import styles from './ReferralDiscountCard.module.css';

export type ReferralDiscountCardMode = 'status' | 'simulator' | 'fleet';

export type ReferralDiscountCardProps = HTMLAttributes<HTMLElement> & {
  mode?: ReferralDiscountCardMode;
  title?: string;
  promoTitle?: string;
  fleetTitle?: string;
  fleetDescription?: string;
  description?: string;
  referralCount?: string;
  discountPercent?: string;
  savingsAmount?: string;
  savingsCaption?: string;
  simulatorTitle?: string;
  projectedDiscount?: string;
  discountAmount?: string;
  ctaLabel?: string;
  progress?: number;
  onInvite?: () => void;
};

function Track({ progress }: { progress: number }) {
  const Filled = resolveIcon('circle-filled');
  const Current = resolveIcon('circle-dot-filled');
  const Empty = resolveIcon('circle-outline');
  const clamped = Math.min(10, Math.max(0, progress));

  return (
    <ol className={styles.track} aria-hidden>
      {Array.from({ length: 10 }, (_, index) => {
        const step = index + 1;
        const Icon = step < clamped ? Filled : step === clamped ? Current : Empty;
        return (
          <li key={step} className={cx(styles.tick, step <= clamped && styles.tickActive)}>
            {Icon ? <Icon size={12} /> : null}
          </li>
        );
      })}
    </ol>
  );
}

export function ReferralDiscountCard({
  mode = 'status',
  title = 'Descontômetro',
  promoTitle = 'Simule seu desconto',
  fleetTitle = 'Indique amigos e ganhe desconto',
  fleetDescription = 'Convide a equipe e acompanhe o desconto da frota.',
  description = 'Veja o desconto projetado para as próximas indicações.',
  referralCount = '2 indicações',
  discountPercent = '10%',
  savingsAmount = 'R$ 120',
  savingsCaption = 'economia atual',
  simulatorTitle = 'Projeção',
  projectedDiscount = '20%',
  discountAmount = 'R$ 240',
  ctaLabel = 'Convidar',
  progress = 2,
  onInvite,
  className,
  ...rest
}: ReferralDiscountCardProps) {
  const heading = mode === 'fleet' ? fleetTitle : mode === 'simulator' ? promoTitle : title;
  const showTrack = mode !== 'fleet';

  return (
    <article className={cx(styles.root, styles[`mode-${mode}`], className)} data-mode={mode} {...rest}>
      {(mode === 'simulator' || mode === 'fleet') && <span className={styles.blur} aria-hidden />}
      <h2 className={styles.heading}>{heading}</h2>
      {mode === 'status' && (
        <p className={styles.meta}>
          {referralCount} · {discountPercent}
        </p>
      )}
      {mode === 'simulator' && (
        <>
          <p className={styles.description}>{description}</p>
          <p className={styles.simulatorTitle}>{simulatorTitle}</p>
        </>
      )}
      {showTrack && <Track progress={progress} />}
      <div className={styles.footer}>
        {mode === 'status' && (
          <div>
            <p className={styles.savings}>{savingsAmount}</p>
            <p className={styles.caption}>{savingsCaption}</p>
          </div>
        )}
        {mode === 'simulator' && (
          <div>
            <p className={styles.savings}>{projectedDiscount}</p>
            <p className={styles.caption}>{discountAmount}</p>
          </div>
        )}
        {mode === 'fleet' && <p className={styles.description}>{fleetDescription}</p>}
        <Button variant="solid" size="md" intent="secondary" label={ctaLabel} onClick={onInvite} />
      </div>
    </article>
  );
}
