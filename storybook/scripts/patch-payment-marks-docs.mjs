import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const JSON_PATH = path.join(__dirname, '..', '..', 'design-system-tokens.storybook.updated.v2.json');

const sets = [
  { slug: 'alelo', label: 'Alelo', id: '7:592', key: '0d6cec85b12b0d27d70aebb76409ae9e2c11ca83', hasLogo: false },
  { slug: 'amazon-pay', label: 'Amazon Pay', id: '7:301', key: '7edb3097df30a1bc85bc5fc5da3baaa9d0723a39', hasLogo: true },
  { slug: 'amex', label: 'American Express', id: '7:64', key: '3148ce6413e3080f58aaac1086cea565242470f1', hasLogo: true },
  { slug: 'apple-pay', label: 'Apple Pay', id: '7:270', key: 'caa9089a22b5a38576f80b1b9d731eebb2c2958f', hasLogo: false },
  { slug: 'ben', label: 'Ben', id: '7:569', key: '8b86b51fbae89f06347c632513f5dda88b8eba3f', hasLogo: false },
  { slug: 'bitcoin', label: 'Bitcoin', id: '7:352', key: '9509eb84e3a09e47cbdbeda5e6a23ea5c4178086', hasLogo: true },
  { slug: 'bitcoin-cash', label: 'Bitcoin Cash', id: '7:386', key: 'a10f9118dbbce7cedd956e5b2eb7f1b2ab7b34bc', hasLogo: true },
  { slug: 'cartao-luiza', label: 'Cartão Luiza', id: '7:438', key: '4a3f41c68e4e8753a66c56501203634aa7e7a268', hasLogo: false },
  { slug: 'diners-club', label: 'Diners Club', id: '7:108', key: 'fa8d8d3389f8526354f6d6e9f00728e6aa434e3b', hasLogo: true },
  { slug: 'elo', label: 'Elo', id: '7:101', key: '5ce8e03f428a01dee09edc525eaf358f569dbe22', hasLogo: false },
  { slug: 'google-pay', label: 'Google Pay', id: '7:237', key: '4bda8077e0f93e78083461d5146aaef9e07da8f0', hasLogo: false },
  { slug: 'hiper', label: 'Hiper', id: '7:423', key: '9158838743eb0dce496c624fff83e865fe487565', hasLogo: false },
  { slug: 'hipercard', label: 'Hipercard', id: '7:19', key: '137471d8a539856f82bf6391841b533a3cb2fc17', hasLogo: false },
  { slug: 'ifood-beneficios', label: 'iFood Benefícios', id: '7:618', key: '48be936b9918a470a49e00ed88ea81297dd2ecab', hasLogo: false },
  { slug: 'mastercard', label: 'Mastercard', id: '7:24', key: 'c3973308d88458ad2a74717cdfcafded352befde', hasLogo: true },
  { slug: 'paypal', label: 'PayPal', id: '7:334', key: '2be38fe8e1e48d871bfa536905d688cb2737a241', hasLogo: true },
  { slug: 'pix', label: 'Pix', id: '7:195', key: '1c59134779e03e7ac6a90c5c6e6c2408a4e9df02', hasLogo: true },
  { slug: 'pluxee', label: 'Pluxee', id: '7:578', key: '4bbbcbbd5096d44df5e2eb0f2d64443382d85705', hasLogo: true },
  { slug: 'samsung-pay', label: 'Samsung Pay', id: '7:289', key: '78f4a19e5d5e6e71a4d6008012f115f206fc394c', hasLogo: true },
  { slug: 'shopee-pay', label: 'Shopee Pay', id: '7:413', key: 'bd8c57b14212a797f221e2a7b4216214a3253334', hasLogo: true },
  { slug: 'sodexo', label: 'Sodexo', id: '7:645', key: '1991b41240a703e0da974f64a3f19eb21f5f6c36', hasLogo: false },
  { slug: 'ticket', label: 'Ticket', id: '7:609', key: '4d7df376353d23ad0b90da846b34b8f9adc9614e', hasLogo: false },
  { slug: 'verde-card', label: 'VerdeCard', id: '7:457', key: 'd7bedfe4476348241ba4fdb4d0185a055b8a90e2', hasLogo: false },
  { slug: 'visa', label: 'Visa', id: '7:49', key: '4e06974a46a6a3284b0eb257b19be8fff88aef0a', hasLogo: false },
  { slug: 'vr', label: 'VR', id: '7:628', key: 'c82cbe8e9b32c26cd54039a5185f3954aa1b9946', hasLogo: false },
];

function sparseFor(hasLogo) {
  if (!hasLogo) return 'type=logo not published';
  return 'type=logo uses showBackground=false only';
}

function assetDesc(label, slug, hasLogo) {
  const sparse = sparseFor(hasLogo);
  return [
    `AI-READY COMPONENT: ${label} payment method brand mark for checkout, saved cards, wallets, and payment history.`,
    `Props: type=logo|icon; showBackground=true|false (sparse: ${sparse}).`,
    'Canonical height=40px for all variants. type=logo = horizontal lockup (proportional width, h=40); type=icon = 40×40 badge; showBackground=false = transparent root (mark only); showBackground=true = brand-colored 40×40 badge fill on root (official brand color — not a white tile; fixed fills, do not remap to text/* or color/*).',
    'Not DS Icons. INSTANCE_SWAP among payment-method/* only.',
    `Accessibility: decorative when adjacent label names the method (aria-hidden); else aria-label="${label}".`,
    `React mapping: PaymentMethodMark(brand="${slug}", type, showBackground).`,
  ].join(' ');
}

const assets = Object.fromEntries(
  sets.map((b) => [
    b.slug,
    {
      nodeId: b.id,
      name: `payment-method/${b.slug}`,
      componentKey: b.key,
      description: assetDesc(b.label, b.slug, b.hasLogo),
      variantsPublished: {
        type: b.hasLogo ? ['logo', 'icon'] : ['icon'],
        showBackground: ['true', 'false'],
      },
    },
  ]),
);

const data = JSON.parse(fs.readFileSync(JSON_PATH, 'utf8'));

data.meta.governance.paymentMethodMarks = {
  summary:
    'Dedicated published library for card networks, wallets, and meal/voucher marks — parallel to BrandLogo, never mixed into UI icon libraries (*-outline/*-filled).',
  nameContract: 'payment-method/{brand}',
  fileKey: 'f7HDa2A0uqtcVEOJ1YhPx6',
  figmaUrl: 'https://www.figma.com/design/f7HDa2A0uqtcVEOJ1YhPx6/-DS--Payment-Method-Marks',
  strategy:
    'Publish [DS] Payment Method Marks as a Figma library; consume in S2 via INSTANCE_SWAP on payment slots — swap only among payment-method/* marks.',
  libraryStatus: 'published and enabled in S2 (2026-08-26)',
  canonicalHeightPx: 40,
  vsBrandLogo: 'BrandLogo = Loovi product identity; payment-method/* = third-party payment network or wallet marks.',
  vsIcons:
    'Not DS Icons — fixed brand colors, rectangular badge geometry, trademark artwork; do not remap fills to text/* tokens.',
  doNot: [
    'Add payment marks to DS Icons (*-outline/*-filled) or Hugeicons/Tabler libraries',
    'Remap brand fills to text/* or color/* semantic tokens',
    'INSTANCE_SWAP payment marks with DS Icons or BrandLogo',
    'Use as Button leadingIcon, Toast/Alert statusIcon, or navigation chrome',
  ],
};

data.meta.storybookUpdatedAt = '2026-08-26T20:00:00.000Z';
data.meta.storybookRevision = '2026-08-26-payment-method-marks-audit-apply';
data.meta.changelog.unshift({
  date: '2026-08-26',
  type: 'storybook-payment-method-marks-audit-apply',
  summary:
    'Payment Method Marks audit apply: fixed 11 logo variant prop errors; showBackground=true = brand-colored badge (not white tile); layer hygiene; ListItem leading=payment-mark + ListItemLeadingPaymentMark INSTANCE_SWAP; figmaNodeUrl slug fix.',
});

data.storybook.updatedAt = '2026-08-26T20:00:00-03:00';
data.storybook.globalRules.paymentMethodMarks =
  'Third-party payment marks live in published library [DS] Payment Method Marks (see Foundations/Payment method marks and meta.governance.paymentMethodMarks) — not DS Icons and not BrandLogo.';

data.storybook.paymentMethodMarks = {
  summary:
    'Payment network and wallet brand marks (not DS Icons). Published from file [DS] Payment Method Marks. Naming: payment-method/{brand}. All variants canonical height=40px. Brand fills are fixed — intentional exception to semantic UI token binding (parallel to BrandLogo vs Icons).',
  colorPolicy:
    'Brand/trademark fills are fixed official colors — do not remap to text/*, color/*, or feedback/* tokens. showBackground=true applies the official brand color as a 40×40 badge fill on the component root (not a white tile). showBackground=false keeps the root transparent (mark artwork only).',
  fileKey: 'f7HDa2A0uqtcVEOJ1YhPx6',
  figmaUrl: 'https://www.figma.com/design/f7HDa2A0uqtcVEOJ1YhPx6/-DS--Payment-Method-Marks',
  page: { name: 'Components', nodeId: '0:1' },
  section: { name: 'payment-method / cards', nodeId: '7:18' },
  naming: 'payment-method/{brand}',
  canonicalHeightPx: 40,
  variantContract: {
    type: ['logo', 'icon'],
    showBackground: ['true', 'false'],
    notes:
      'type=logo = horizontal lockup (~86×40); type=icon = 40×40 badge; sparse matrix per brand (some omit type=logo). When type=logo is published it uses showBackground=false only.',
  },
  families: {
    cards: {
      sectionNodeId: '7:18',
      description:
        'AI-READY MARK FAMILY: payment-method/* — card networks, digital wallets, meal/voucher cards curated for BR checkout and payment history. Each brand is a COMPONENT_SET with type and showBackground variants. Consume via INSTANCE_SWAP in S2 payment slots. Not DS Icons (*-outline/*-filled).',
      canonicalHeightPx: 40,
      role: 'checkout / saved card / payment history brand badge',
      members: sets.map((b) => b.slug),
      assets,
      consumers: [
        'ListItem leading=payment-mark via ListItemLeadingPaymentMark (paymentMethodMark INSTANCE_SWAP → payment-method/*)',
        'S2 payment-method INSTANCE_SWAP slots (checkout, saved cards, payment history)',
      ],
      rules: {
        composition: 'One COMPONENT_SET per brand; swap by brand + type + showBackground',
        colorException: 'Fixed brand fills OK — do not force semantic UI tokens',
        vsBrandLogo: 'BrandLogo = Loovi identity only',
        vsIcons: 'Not DS Icons — different contract (*-outline/*-filled) and color model',
        sizing: 'Canonical height=40px for every published variant',
        library: 'Publish [DS] Payment Method Marks; enable Library in S2 file',
      },
      accessibility:
        'Decorative when adjacent copy names the payment method (aria-hidden); otherwise aria-label with brand name.',
      status: 'documented',
    },
  },
};

data.storybook.components.PaymentMethodMark = {
  nodeId: '7:18',
  figmaFileKey: 'f7HDa2A0uqtcVEOJ1YhPx6',
  figmaUrl:
    'https://www.figma.com/design/f7HDa2A0uqtcVEOJ1YhPx6/-DS--Payment-Method-Marks?node-id=7-18',
  description:
    'AI-READY COMPONENT: PaymentMethodMark is the contract for third-party payment network and wallet brand marks published in library [DS] Payment Method Marks. Each brand is a separate COMPONENT_SET named payment-method/{brand}. Props: type=logo|icon; showBackground=true|false (sparse matrix per brand — some omit type=logo; when type=logo is published it uses showBackground=false only). Canonical height=40px for all variants. type=logo = horizontal lockup (proportional width, h=40); type=icon = 40×40 badge; showBackground=false = transparent root (mark only); showBackground=true = brand-colored 40×40 badge fill on root (official brand color — not a white tile). Brand fills are fixed — do not remap to text/* or color/* tokens. Not DS Icons (*-outline/*-filled) and not BrandLogo. Consume in [DS] 2.0 - S2 via INSTANCE_SWAP only among payment-method/* marks (e.g. ListItem leading=payment-mark). Accessibility: decorative when adjacent label names the method (aria-hidden); else aria-label with brand name. React mapping: PaymentMethodMark(brand, type, showBackground). Code Connect is not configured.',
  variants: {
    type: ['logo', 'icon'],
    showBackground: ['true', 'false'],
  },
  props: {
    brand: 'kebab-case slug matching payment-method/{brand} set name (e.g. visa, mastercard, pix)',
    type: 'logo | icon — logo = horizontal lockup; icon = square badge',
    showBackground:
      'true | false — true = brand-colored 40×40 badge fill on root; false = transparent root (mark only). Sparse when type=logo (logo publishes showBackground=false only).',
  },
  rules: {
    sparseMatrix:
      'Per-brand sparse: e.g. visa publishes icon only (no type=logo); mastercard publishes logo + icon × showBackground; type=logo always showBackground=false when published',
    brandTokens: 'No semantic token binding — fixed trademark fills',
    vsIcons: 'Not DS Icons (*-outline/*-filled) — do not mix libraries',
    vsBrandLogo: 'BrandLogo = Loovi identity; PaymentMethodMark = third-party payment marks',
    sizing: 'Canonical height=40px for every variant',
    library: 'Source file f7HDa2A0uqtcVEOJ1YhPx6 — publish as library for S2 INSTANCE_SWAP',
    naming: 'Renamed from external lib (Type/Background → type/showBackground; PascalCase → payment-method/{brand})',
  },
  tokenRules: [],
  accessibility:
    'Decorative when adjacent label names the payment method (aria-hidden); otherwise aria-label with brand name (e.g. Visa, Pix).',
  composition: [
    'payment-method/{brand} COMPONENT_SET',
    'type=logo|icon variants',
    'showBackground brand-colored badge (icon) or transparent (logo/false)',
  ],
  reactMapping: 'PaymentMethodMark(brand, type, showBackground)',
  catalog: sets.map((b) => b.slug),
};

data.storybook.components.ListItemLeadingPaymentMark = {
  nodeId: '4990:38559',
  description:
    'AI-READY INTERNAL COMPONENT: ListItemLeadingPaymentMark wraps a payment-method/* brand mark (40×40 canonical height) for ListItem leading=payment-mark rows. Props: paymentMethodMark (INSTANCE_SWAP — swap only among payment-method/* marks from published [DS] Payment Method Marks f7HDa2A0uqtcVEOJ1YhPx6). Do not use as standalone checkout badge, Button icon, or DS Icons slot. Accessibility: decorative when ListItem headline names the payment method (aria-hidden); parent owns label. React mapping: internal only — ListItemLeadingPaymentMark(brand, type, showBackground).',
  props: {
    paymentMethodMark:
      'INSTANCE_SWAP → payment-method/* from [DS] Payment Method Marks (type=icon recommended for list rows; h=40px)',
  },
  rules: {
    internalOnly: 'Use inside ListItem leading=payment-mark only',
    swapScope: 'INSTANCE_SWAP among payment-method/* only — never DS Icons or BrandLogo',
    libraryRequired: 'Enable [DS] Payment Method Marks library in S2 for production swaps',
  },
  tokenRules: [],
  accessibility: 'Decorative when headline names the method; parent ListItem owns accessible name.',
  composition: ['payment-method/{brand} instance'],
  reactPackage: '@ds/react',
  reactImplemented: true,
};

const listItem = data.storybook.components.ListItem;
if (listItem) {
  listItem.description = listItem.description
    .replace(
      'Use leading=none|monogram|icon|image|video|checkbox|radio|switch',
      'Use leading=none|monogram|icon|image|video|payment-mark|checkbox|radio|switch',
    )
    .replace(
      'ListItemVideoThumbnail for leading=video;',
      'ListItemVideoThumbnail for leading=video; ListItemLeadingPaymentMark (paymentMethodMark INSTANCE_SWAP → payment-method/*) for leading=payment-mark;',
    );
  listItem.variants.leading.splice(4, 0, 'payment-mark');
  listItem.props.leading =
    'none | monogram | icon | image | video | payment-mark | checkbox | radio | switch';
  listItem.rules.paymentMarkLeading =
    'leading=payment-mark → ListItemLeadingPaymentMark with paymentMethodMark INSTANCE_SWAP (payment-method/* only)';
  listItem.composition.push('ListItemLeadingPaymentMark');
}

data.storybook.recentUpdates.unshift({
  id: 'payment-method-marks-audit-apply',
  date: '2026-08-26',
  summary:
    'Payment Method Marks audit apply: logo variant prop fix, showBackground semantics, layer hygiene, ListItem leading=payment-mark consumer, figmaNodeUrl slug fix.',
});

fs.writeFileSync(JSON_PATH, `${JSON.stringify(data, null, 4)}\n`);
console.log(`Patched ${sets.length} payment method marks into ${JSON_PATH}`);
