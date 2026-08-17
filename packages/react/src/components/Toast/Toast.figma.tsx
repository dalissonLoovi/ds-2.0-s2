import figma from '@figma/code-connect';
import { Toast } from './Toast';

figma.connect(
  Toast,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3550-4107',
  {
    props: {
      message: figma.string('message'),
      status: figma.enum('status', {
        system: 'system',
        info: 'info',
        success: 'success',
        danger: 'danger',
        warning: 'warning',
      }),
      showAction: figma.boolean('showAction'),
      dismissible: figma.boolean('dismissible'),
    },
    example: (props) => <Toast {...props} />,
  },
);
