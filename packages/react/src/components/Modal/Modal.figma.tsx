import figma from '@figma/code-connect';
import { Modal } from './Modal';

/**
 * Code Connect — Modal
 * Figma `showFooter` (BOOLEAN) → React `showFooter` (built-in footer: primary solid +
 * secondary text; size lg on web, md + vertical full width on mobile). Labels/handlers
 * map to primaryActionLabel/onPrimaryAction and secondaryActionLabel/onSecondaryAction.
 * A custom `footer` ReactNode still overrides the built-in actions.
 */
figma.connect(
  Modal,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3306-4278',
  {
    props: {
      title: figma.string('title'),
      label: figma.string('label'),
      showLabel: figma.boolean('showLabel'),
      showCloseAction: figma.boolean('showCloseAction'),
      showFooter: figma.boolean('showFooter'),
      platform: figma.enum('platform', {
        web: 'web',
        mobile: 'mobile',
        'mobile-landscape': 'mobile-landscape',
      }),
    },
    example: (props) => (
      <Modal
        {...props}
        open
        primaryActionLabel="Confirmar"
        secondaryActionLabel="Cancelar"
        onPrimaryAction={() => {}}
        onSecondaryAction={() => {}}
      >
        Slot content
      </Modal>
    ),
  },
);
