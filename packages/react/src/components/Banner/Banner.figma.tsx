import figma from '@figma/code-connect';
import { Banner } from './Banner';

/**
 * Code Connect — Banner
 * Figma node: 3098:2629
 */
figma.connect(
  Banner,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3098-2629',
  {
    props: {
      status: figma.enum('status', {
        success: 'success',
        warning: 'warning',
        info: 'info',
        danger: 'danger',
      }),
      emphasis: figma.enum('emphasis', { primary: 'primary', secondary: 'secondary' }),
    },
    example: (props) => <Banner {...props} />,
  },
);
