import type { Preview } from '@storybook/react';

const preview: Preview = {
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
    options: {
      storySort: {
        order: [
          'Introduction',
          'Foundations',
          ['Global rules', 'Feedback'],
          'Components',
          'Changelog',
        ],
      },
    },
    docs: {
      toc: true,
    },
  },
};

export default preview;
