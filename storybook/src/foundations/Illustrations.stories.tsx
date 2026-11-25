import type { Meta, StoryObj } from '@storybook/react';
import { Illustration, illustrationNames, illustrations, type IllustrationName } from '@ds/react';

/**
 * Live catalog of the illustration assets shipped in `@ds/react` (same SVGs as
 * the Flutter `LooviIllustration`). Seed docs for the families live in the
 * "Docs" page of this section (generated MDX).
 */
const meta = {
  title: 'Foundations/Illustrations',
  component: Illustration,
  args: { name: 'claim-reason/theft', width: 208 },
  argTypes: {
    name: { control: 'select', options: illustrationNames },
    width: { control: { type: 'range', min: 32, max: 520, step: 4 } },
    height: { control: 'number' },
    alt: { control: 'text' },
    fit: { control: 'inline-radio', options: ['contain', 'cover', 'fill'] },
  },
} satisfies Meta<typeof Illustration>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Playground: Story = {
  render: (args) => {
    const m = illustrations[args.name];
    return (
      <figure style={{ margin: 0, display: 'inline-flex', flexDirection: 'column', gap: 8 }}>
        <Illustration {...args} />
        <figcaption style={{ font: '12px/16px var(--font-family-base, sans-serif)', color: 'var(--text-secondary)' }}>
          {m.name} · {m.width} × {m.height} · node {m.nodeId}
        </figcaption>
      </figure>
    );
  },
};

const groups = illustrationNames.reduce<Record<string, IllustrationName[]>>((acc, n) => {
  (acc[illustrations[n].group] ??= []).push(n);
  return acc;
}, {});

export const Gallery: Story = {
  parameters: { controls: { disable: true } },
  render: () => (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 24 }}>
      {Object.entries(groups).map(([group, names]) => (
        <section key={group}>
          <h3 style={{ margin: '0 0 8px', font: '600 16px/24px var(--font-family-base, sans-serif)' }}>{group}</h3>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(128px, 1fr))', gap: 16 }}>
            {names.map((n) => (
              <figure key={n} style={{ margin: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
                <Illustration name={n} width={120} height={120} />
                <figcaption style={{ font: '12px/16px var(--font-family-base, sans-serif)', color: 'var(--text-secondary)', textAlign: 'center' }}>
                  {n.split('/')[1]}
                </figcaption>
              </figure>
            ))}
          </div>
        </section>
      ))}
    </div>
  ),
};
