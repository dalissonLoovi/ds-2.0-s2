import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { FeatureStepsItem } from '../FeatureStepsItem/FeatureStepsItem';
import styles from './FeatureSteps.module.css';

export type FeatureStepsProps = HTMLAttributes<HTMLUListElement> & {
  children?: ReactNode;
};

export function FeatureSteps({ children, className, ...rest }: FeatureStepsProps) {
  return (
    <ul className={cx(styles.root, className)} {...rest}>
      {children ?? (
        <>
          <FeatureStepsItem
            leadingIcon="square-check-outline"
            headline="Permissões"
            supportingText="Libere câmera e arquivos para continuar."
          />
          <FeatureStepsItem
            leadingIcon="car-outline"
            headline="Confirmar Veículo"
            supportingText="Confira placa e modelo do veículo."
          />
          <FeatureStepsItem
            leadingIcon="camera-outline"
            headline="Enviar fotos e documentos"
            supportingText="Capture os documentos pedidos."
            showConnector={false}
          />
        </>
      )}
    </ul>
  );
}
