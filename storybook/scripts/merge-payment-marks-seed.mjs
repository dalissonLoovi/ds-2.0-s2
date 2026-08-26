import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const JSON_PATH = path.join(__dirname, '..', '..', 'design-system-tokens.storybook.updated.v2.json');
const SEED_PATH = path.join(__dirname, '..', 'payment-method-marks.seed.json');

const data = JSON.parse(fs.readFileSync(JSON_PATH, 'utf8'));
const seed = JSON.parse(fs.readFileSync(SEED_PATH, 'utf8'));

data.storybook.paymentMethodMarks = seed.paymentMethodMarks;
data.storybook.components.PaymentMethodMark = seed.PaymentMethodMark;

if (!data.storybook.recentUpdates.some((u) => u.id === 'payment-method-marks-docs')) {
  data.storybook.recentUpdates.unshift({
    id: 'payment-method-marks-docs',
    date: '2026-08-26',
    summary:
      'Payment Method Marks library: DS naming (payment-method/{brand}), type|showBackground props, h=40px; 25 marks in seed + Foundations page; governance vs Icons/BrandLogo.',
  });
}

fs.writeFileSync(JSON_PATH, `${JSON.stringify(data, null, 4)}\n`);
console.log('Merged payment method marks seed into', JSON_PATH);
