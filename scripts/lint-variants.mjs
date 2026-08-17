/**
 * Fail CI when React variant unions diverge from seed JSON variants.
 * Handwritten W0 components are checked; scaffolds are skipped until polished.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const JSON_PATH = path.join(ROOT, 'design-system-tokens.storybook.updated.v2.json');

const CHECK = {
  Button: {
    file: 'packages/react/src/components/Button/Button.tsx',
    axes: {
      variant: ['solid', 'outline', 'text'],
      size: ['sm', 'md', 'lg'],
      intent: ['primary', 'success', 'danger', 'secondary'],
      state: ['default', 'hover', 'focus', 'pressed', 'selected', 'loading'],
    },
  },
  Input: {
    file: 'packages/react/src/components/Input/Input.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
      content: ['value', 'placeholder', 'label'],
      appearance: ['default', 'inverse'],
    },
  },
  ChipTag: {
    file: 'packages/react/src/components/ChipTag/ChipTag.tsx',
    axes: {
      size: ['sm', 'md'],
      intent: ['info', 'system', 'success', 'warning', 'danger', 'outline'],
      width: ['hug', 'fill'],
      state: ['default', 'disabled'],
      emphasis: ['strong', 'soft'],
    },
  },
  ChipClickable: {
    file: 'packages/react/src/components/ChipClickable/ChipClickable.tsx',
    axes: {
      size: ['sm', 'md'],
      state: ['default', 'hover', 'pressed', 'selected', 'disabled'],
      intent: ['info', 'system', 'success', 'warning', 'danger', 'outline', 'soft'],
      width: ['hug', 'fill'],
    },
  },
  Alert: {
    file: 'packages/react/src/components/Alert/Alert.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      status: ['system', 'info', 'success', 'danger', 'warning'],
    },
  },
  Toast: {
    file: 'packages/react/src/components/Toast/Toast.tsx',
    axes: {
      status: ['system', 'info', 'success', 'danger', 'warning'],
    },
  },
  Modal: {
    file: 'packages/react/src/components/Modal/Modal.tsx',
    axes: {
      platform: ['web', 'mobile', 'mobile-landscape'],
    },
  },
};

function main() {
  const data = JSON.parse(fs.readFileSync(JSON_PATH, 'utf8'));
  const components = data.storybook?.components || {};
  const errors = [];

  for (const [name, cfg] of Object.entries(CHECK)) {
    const seed = components[name];
    if (!seed) {
      errors.push(`${name}: missing from seed JSON`);
      continue;
    }
    if (!fs.existsSync(path.join(ROOT, cfg.file))) {
      errors.push(`${name}: missing source ${cfg.file}`);
      continue;
    }
    for (const [axis, expected] of Object.entries(cfg.axes)) {
      const actual = seed.variants?.[axis] || [];
      const missing = expected.filter((v) => !actual.includes(v));
      const extra = actual.filter((v) => !expected.includes(v));
      if (missing.length || extra.length) {
        errors.push(
          `${name}.${axis}: react=[${expected}] seed=[${actual}] missing=${missing} extra=${extra}`,
        );
      }
    }
  }

  if (errors.length) {
    console.error('lint-variants failed:\n' + errors.map((e) => ` - ${e}`).join('\n'));
    process.exit(1);
  }
  console.log(`lint-variants: ok (${Object.keys(CHECK).length} components)`);
}

main();
