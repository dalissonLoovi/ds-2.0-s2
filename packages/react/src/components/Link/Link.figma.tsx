import figma from '@figma/code-connect';
import { Link } from './Link';

/**
 * Code Connect — Link
 * Figma node: 3820:13913
 */
figma.connect(
  Link,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3820-13913',
  {
    props: {
      size: figma.enum('size', {
        lg: 'lg',
        md: 'md',
        sm: 'sm',
      }),
      state: figma.enum('state', {
        default: 'default',
        hover: 'hover',
        focus: 'focus',
        active: 'active',
        visited: 'visited',
        disabled: 'disabled',
      }),
      appearance: figma.enum('appearance', {
        default: 'default',
        inverse: 'inverse',
      }),
      label: figma.string('label'),
      inline: figma.boolean('inline'),
      showIcon: figma.boolean('showIcon'),
    },
    example: ({ size, state, appearance, label, inline, showIcon }) => (
      <Link
        size={size}
        state={state}
        appearance={appearance}
        label={label}
        inline={inline}
        showIcon={showIcon}
      />
    ),
  },
);
