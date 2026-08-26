import type { Preview } from '@storybook/react';
import React from 'react';
import '@ds/tokens';
import './preview.css';

const preview: Preview = {
  globalTypes: {
    productTheme: {
      name: 'Product theme',
      description: 'product-theme collection mode',
      defaultValue: 'escritorio-virtual',
      toolbar: {
        icon: 'paintbrush',
        items: [
          { value: 'escritorio-virtual', title: 'Escritório Virtual' },
          { value: 'site-loovi', title: 'Site Loovi' },
          { value: 'app-cliente', title: 'App Cliente' },
        ],
        dynamicTitle: true,
      },
    },
  },
  decorators: [
    (Story, context) =>
      React.createElement(
        'div',
        { 'data-product-theme': context.globals.productTheme },
        React.createElement(Story),
      ),
  ],
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
