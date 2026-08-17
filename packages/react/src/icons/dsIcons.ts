import type { ComponentType, SVGProps } from 'react';
import {
  IconAlertCircle,
  IconAlertCircleFilled,
  IconAlertTriangle,
  IconArrowLeft,
  IconArrowNarrowRight,
  IconCalendar,
  IconCheck,
  IconChevronDown,
  IconChevronLeft,
  IconChevronRight,
  IconChevronUp,
  IconCircleCheck,
  IconCircleCheckFilled,
  IconDotsVertical,
  IconEye,
  IconEyeOff,
  IconInfoCircle,
  IconInfoCircleFilled,
  IconBell,
  IconHome,
  IconLoader2,
  IconLock,
  IconMenu2,
  IconMinus,
  IconPlus,
  IconSearch,
  IconUser,
  IconX,
} from '@tabler/icons-react';

/** DS icon contract: *-outline / *-filled names → Tabler (EV) for the pilot. */
export const dsIcons = {
  'x-outline': IconX,
  'plus-outline': IconPlus,
  'search-outline': IconSearch,
  'chevron-down-outline': IconChevronDown,
  'chevron-up-outline': IconChevronUp,
  'chevron-left-outline': IconChevronLeft,
  'chevron-right-outline': IconChevronRight,
  'loader-outline': IconLoader2,
  'alert-circle-outline': IconAlertCircle,
  'alert-circle-filled': IconAlertCircleFilled,
  'alert-triangle-outline': IconAlertTriangle,
  'info-circle-outline': IconInfoCircle,
  'info-circle-filled': IconInfoCircleFilled,
  'circle-check-outline': IconCircleCheck,
  'circle-check-filled': IconCircleCheckFilled,
  'check-outline': IconCheck,
  'minus-outline': IconMinus,
  'lock-outline': IconLock,
  'eye-outline': IconEye,
  'eye-closed-outline': IconEyeOff,
  'calendar-outline': IconCalendar,
  'arrow-narrow-right-outline': IconArrowNarrowRight,
  'arrow-left-outline': IconArrowLeft,
  'dots-vertical-outline': IconDotsVertical,
  'menu-2-outline': IconMenu2,
  'bell-outline': IconBell,
  'home-outline': IconHome,
  'user-outline': IconUser,
} as const;

export type DsIconName = keyof typeof dsIcons;

export type IconComponent = ComponentType<
  SVGProps<SVGSVGElement> & { size?: number | string; className?: string }
>;

export function resolveIcon(name?: DsIconName | IconComponent | null): IconComponent | null {
  if (!name) return null;
  if (typeof name === 'string') {
    return (dsIcons[name] as unknown as IconComponent) ?? null;
  }
  return name;
}
