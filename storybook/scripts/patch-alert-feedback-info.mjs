import fs from 'node:fs';

const path = 'design-system-tokens.storybook.updated.v2.json';
let raw = fs.readFileSync(path, 'utf8');
if (raw.charCodeAt(0) === 0xfeff) raw = raw.slice(1);
const data = JSON.parse(raw);

data.meta.newVariables = data.meta.newVariables || [];
if (!data.meta.newVariables.some((v) => v.name === 'feedback/info')) {
  data.meta.newVariables.push({
    name: 'feedback/info',
    id: 'VariableID:4419:32',
    aliasOf: 'primitive-colors/aqua-gleam',
  });
}
data.meta.variableCount = Math.max(data.meta.variableCount || 0, 272);

data.meta.storybookUpdatedAt = '2026-07-28T14:50:00-03:00';
data.meta.storybookRevision = '2026-07-28-alert-feedback-info';
data.meta.changelog = [
  {
    date: '2026-07-28',
    type: 'storybook-alert-feedback-info',
    summary:
      'Created feedback/info (alias aqua-gleam); Alert+Toast status=info icon fills → feedback/info (content layer). actionLabel stays nested Button.label (Figma API cannot bind parent TEXT to instance sublayer). Docs synced.',
  },
  ...(data.meta.changelog || []),
];

function patchFeedbackTable(ft) {
  if (!ft || !ft.layers) return;
  for (const layer of ft.layers) {
    if (layer.id !== 'content') continue;
    if (Array.isArray(layer.allowedStatuses) && !layer.allowedStatuses.includes('info')) {
      layer.allowedStatuses = ['info', ...layer.allowedStatuses];
    }
    if (layer.unavailableStatuses && layer.unavailableStatuses.info) {
      delete layer.unavailableStatuses.info;
    }
    if (Array.isArray(layer.figmaVariables) && !layer.figmaVariables.includes('feedback/info')) {
      layer.figmaVariables = ['feedback/info', ...layer.figmaVariables];
    }
  }
}

if (data.meta.feedbackUsageTable) patchFeedbackTable(data.meta.feedbackUsageTable);
if (data.storybook?.globalRules?.feedbackUsageTable) {
  patchFeedbackTable(data.storybook.globalRules.feedbackUsageTable);
}

function patchComponent(name) {
  const c = data.storybook?.components?.[name];
  if (!c) return;
  if (c.description) {
    c.description = c.description
      .split('color/background-feedback-primary/info')
      .join('feedback/info')
      .split('Toast-aligned fills')
      .join('content-layer icon fills');
    c.description = c.description.replace(
      /info → feedback\/info; success\|danger\|warning → feedback\/success\|danger\|warning/,
      'info|success|danger|warning → feedback/info|success|danger|warning',
    );
  }
  if (c.statusMap?.info) c.statusMap.info.iconFillToken = 'feedback/info';
  if (Array.isArray(c.tokenRules)) {
    c.tokenRules = c.tokenRules.map((t) => {
      let s = String(t).split('color/background-feedback-primary/info').join('feedback/info');
      if (/status icon fills/.test(s)) s = 'status icon fills: feedback/info|success|danger|warning';
      return s;
    });
  }
  if (name === 'Alert' && c.rules) {
    c.rules.actionLabel =
      'actionLabel is React-side / nested Button.label — Figma parent TEXT cannot bind to instance sublayer via API; edit nested action label when showAction=true';
  }
}

patchComponent('Alert');
patchComponent('Toast');

data.storybook.recentUpdates = [
  {
    id: 'alert-feedback-info',
    summary:
      'feedback/info token created; Alert+Toast info icon fills use content-layer feedback/info; docs synced.',
  },
  ...(data.storybook.recentUpdates || []),
];

fs.writeFileSync(path, JSON.stringify(data, null, 4) + '\n', 'utf8');
const content = data.storybook.globalRules.feedbackUsageTable.layers.find((l) => l.id === 'content');
console.log(
  JSON.stringify(
    {
      rev: data.meta.storybookRevision,
      alertInfoFill: data.storybook.components.Alert.statusMap.info.iconFillToken,
      toastInfoFill: data.storybook.components.Toast.statusMap.info.iconFillToken,
      contentAllowed: content.allowedStatuses,
      hasUnavailableInfo: Boolean(content.unavailableStatuses?.info),
    },
    null,
    2,
  ),
);
