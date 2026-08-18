import fs from 'node:fs';
import path from 'node:path';
import { describe, expect, it } from 'vitest';

const TOKENS_CSS = path.resolve(__dirname, '../../../tokens/dist/tokens.css');

describe('typography foundation', () => {
  it('emits Poppins as --font-family-base and @font-face', () => {
    const css = fs.readFileSync(TOKENS_CSS, 'utf8');
    expect(css).toContain('--font-family-base:');
    expect(css).toContain('font-family: "Poppins"');
    expect(css).toContain('src: url("./fonts/poppins-latin-400-normal.woff2")');
    expect(css).toContain('--typography-body-medium-medium:');
  });
});
