import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { ChipTag } from '../ChipTag/ChipTag';
import styles from './VehicleSummaryCard.module.css';

export type VehicleSummaryCardAppearance = 'default' | 'secondary';
export type VehicleSummaryCardStatus = 'active' | 'inactive';

export type VehicleSummaryCardProps = HTMLAttributes<HTMLElement> & {
  appearance?: VehicleSummaryCardAppearance;
  status?: VehicleSummaryCardStatus;
  brandModel?: string;
  model?: string;
  title?: string;
  plate?: string;
  showStatus?: boolean;
  href?: string;
};

export function VehicleSummaryCard({
  appearance = 'default',
  status = 'active',
  brandModel = 'Marca',
  model = 'Modelo',
  title = 'Palio 1.0 ECONOMY Fiat • 2009',
  plate = 'ABC1D23',
  showStatus = true,
  href,
  className,
  ...rest
}: VehicleSummaryCardProps) {
  const secondary = appearance === 'secondary';
  const statusLabel = status === 'active' ? 'Ativo' : 'Inativo';
  const inner = (
    <>
      <span className={styles.illustration} aria-hidden />
      <div className={styles.copy}>
        {secondary ? (
          <p className={styles.title}>{title}</p>
        ) : (
          <p className={styles.nameRow}>
            <span>{brandModel}</span> <span>{model}</span>
          </p>
        )}
        <p className={styles.plate}>{plate}</p>
      </div>
      {!secondary && showStatus && (
        <>
          <span className={styles.spacer} aria-hidden />
          <ChipTag
            size="sm"
            intent="outline"
            emphasis="strong"
            width="hug"
            label={statusLabel}
            showLeadingIcon
            leadingIcon="circle-dot-filled"
            className={cx(styles.chip, status === 'active' ? styles.chipActive : styles.chipInactive)}
          />
        </>
      )}
    </>
  );

  const classNames = cx(
    styles.root,
    styles[`appearance-${appearance}`],
    !secondary && styles.clickable,
    className,
  );

  if (!secondary && href) {
    return (
      <a className={classNames} href={href} data-appearance={appearance} data-status={status} {...rest}>
        {inner}
      </a>
    );
  }

  return (
    <div className={classNames} data-appearance={appearance} data-status={status} {...rest}>
      {inner}
    </div>
  );
}
