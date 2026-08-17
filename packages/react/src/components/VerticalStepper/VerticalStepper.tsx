import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { VerticalStepperItem } from '../VerticalStepperItem/VerticalStepperItem';
import styles from './VerticalStepper.module.css';

export type VerticalStepperProps = HTMLAttributes<HTMLUListElement> & {
  children?: ReactNode;
};

export function VerticalStepper({ children, className, ...rest }: VerticalStepperProps) {
  return (
    <ol className={cx(styles.root, className)} {...rest}>
      {children ?? (
        <>
          <VerticalStepperItem status="completed" headline="Dados pessoais" supportingText="Concluído" />
          <VerticalStepperItem status="current" headline="Endereço" supportingText="Em andamento" />
          <VerticalStepperItem status="pending" headline="Documentos" supportingText="Próxima etapa" />
          <VerticalStepperItem
            status="pending"
            headline="Confirmação"
            supportingText="Finalizar cadastro"
            showConnector={false}
          />
        </>
      )}
    </ol>
  );
}
