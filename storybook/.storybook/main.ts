import type { StorybookConfig } from '@storybook/react-vite';
import { mergeConfig } from 'vite';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const dirname = path.dirname(fileURLToPath(import.meta.url));

function pagesBase(): string | undefined {
  if (process.env.GITHUB_PAGES !== 'true') return undefined;
  // In GitHub Actions: owner/repo → /repo/
  const repo = process.env.GITHUB_REPOSITORY?.split('/')[1];
  if (repo) return `/${repo}/`;
  if (process.env.STORYBOOK_BASE_PATH) return process.env.STORYBOOK_BASE_PATH;
  return '/';
}

const config: StorybookConfig = {
  stories: ['../src/**/*.mdx', '../src/**/*.stories.@(js|jsx|mjs|ts|tsx)'],
  addons: [
    '@storybook/addon-essentials',
    '@storybook/addon-links',
    '@storybook/addon-a11y',
  ],
  framework: {
    name: '@storybook/react-vite',
    options: {},
  },
  docs: {
    autodocs: false,
  },
  async viteFinal(config) {
    const base = pagesBase();
    return mergeConfig(config, {
      ...(base ? { base } : {}),
      resolve: {
        alias: {
          '@docs': path.resolve(dirname, '../src'),
        },
      },
    });
  },
};

export default config;
