import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemLeadingPaymentMark.module.css';

export type ListItemLeadingPaymentMarkProps = HTMLAttributes<HTMLSpanElement> & {
  /** kebab-case slug matching payment-method/{brand} */
  brand?: string | null;
  paymentMethodMark?: ReactNode;
};

/** Internal — ListItem leading=payment-mark slot (payment-method/* INSTANCE_SWAP). */
export function ListItemLeadingPaymentMark({
  brand = 'visa',
  paymentMethodMark,
  className,
  ...rest
}: ListItemLeadingPaymentMarkProps) {
  if (paymentMethodMark != null) {
    return <span className={cx(styles.root, className)}>{paymentMethodMark}</span>;
  }

  return (
    <span
      className={cx(styles.root, className)}
      data-brand={brand ?? undefined}
      aria-hidden
      {...rest}
    />
  );
}
