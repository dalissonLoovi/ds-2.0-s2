import figma from '@figma/code-connect';
import { Modal } from './Modal';

figma.connect(
  Modal,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3306-4278',
  {
    props: {
      title: figma.string('title'),
      label: figma.string('label'),
      showLabel: figma.boolean('showLabel'),
      showCloseAction: figma.boolean('showCloseAction'),
      platform: figma.enum('platform', {
        web: 'web',
        mobile: 'mobile',
        'mobile-landscape': 'mobile-landscape',
      }),
    },
    example: (props) => (
      <Modal {...props} open>
        Slot content
      </Modal>
    ),
  },
);
