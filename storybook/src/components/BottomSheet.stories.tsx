import type { Meta, StoryObj } from '@storybook/react';
import { BottomSheet, BottomSheetCheckItem } from '@ds/react';

const meta = {
  title: 'Components/BottomSheet',
  component: BottomSheet,
  tags: ['autodocs'],
  args: { header: 'sheet-header', title: 'Sheet', open: true },
  parameters: { layout: 'fullscreen' },
  render: (args) => (
    <BottomSheet {...args}>
      <ul style={{ margin: 0, padding: 0, display: 'flex', flexDirection: 'column', gap: 12 }}>
        <BottomSheetCheckItem description="Guideline one" />
        <BottomSheetCheckItem description="Guideline two" />
      </ul>
    </BottomSheet>
  ),
} satisfies Meta<typeof BottomSheet>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
