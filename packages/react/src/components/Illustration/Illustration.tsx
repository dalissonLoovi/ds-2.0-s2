import { useEffect, useState, type CSSProperties, type HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import {
  illustrationLoaders,
  illustrationNames,
  illustrations,
  type IllustrationName,
} from '../../illustrations';
import styles from './Illustration.module.css';

export type IllustrationFit = 'contain' | 'cover' | 'fill';

export type IllustrationProps = Omit<HTMLAttributes<HTMLElement>, 'children'> & {
  /** Catalog name `<group>/<name>`, e.g. `claim-reason/theft`. */
  name: IllustrationName;
  /** Width in px. Alone, height follows the artboard ratio. */
  width?: number;
  /** Height in px. Alone, width follows the artboard ratio. */
  height?: number;
  /** Accessible text. Omitted/empty = decorative (`alt=""`, `aria-hidden`). */
  alt?: string;
  /** How the art fits a box whose ratio differs from the artboard. */
  fit?: IllustrationFit;
};

const cache = new Map<IllustrationName, string>();
const pending = new Map<IllustrationName, Promise<string>>();

/** Loads one illustration as an SVG data URL (cached). */
export function loadIllustration(name: IllustrationName): Promise<string> {
  const hit = cache.get(name);
  if (hit) return Promise.resolve(hit);
  let p = pending.get(name);
  if (!p) {
    p = illustrationLoaders[name]().then(({ default: svg }) => {
      const url = `data:image/svg+xml;charset=utf-8,${encodeURIComponent(svg)}`;
      cache.set(name, url);
      pending.delete(name);
      return url;
    });
    pending.set(name, p);
  }
  return p;
}

/**
 * Resolves a slot slug to a catalog name: the full `<group>/<name>`, or a bare
 * `<name>` when it is unique in the catalog (e.g. `sedan` → `vehicle-icon/sedan`).
 */
export function resolveIllustrationName(slug: string | null | undefined): IllustrationName | null {
  if (!slug) return null;
  if (slug in illustrations) return slug as IllustrationName;
  const matches = illustrationNames.filter((n) => n.slice(n.indexOf('/') + 1) === slug);
  return matches.length === 1 ? matches[0] : null;
}

/** Box size for [name] keeping the artboard aspect ratio unless both sides are given. */
export function illustrationSize(name: IllustrationName, width?: number, height?: number) {
  const meta = illustrations[name];
  const ratio = meta.width / meta.height;
  if (width != null && height != null) return { width, height };
  if (width != null) return { width, height: width / ratio };
  if (height != null) return { width: height * ratio, height };
  return { width: meta.width, height: meta.height };
}

/**
 * DS illustration (Figma page "Ilustrações e animações" 4326:1764) rendered as
 * an `<img>` with its dedicated palette (not remapped to semantic tokens).
 * Each SVG is a lazy chunk; the box is reserved while it loads.
 */
export function Illustration({ name, width, height, alt, fit = 'contain', className, style, ...rest }: IllustrationProps) {
  const [src, setSrc] = useState<string | undefined>(() => cache.get(name));
  useEffect(() => {
    let alive = true;
    const hit = cache.get(name);
    if (hit) {
      setSrc(hit);
      return undefined;
    }
    setSrc(undefined);
    loadIllustration(name).then((url) => {
      if (alive) setSrc(url);
    });
    return () => {
      alive = false;
    };
  }, [name]);

  const size = illustrationSize(name, width, height);
  const decorative = !alt;
  const boxStyle: CSSProperties = { width: size.width, height: size.height, objectFit: fit, ...style };
  const common = {
    className: cx(styles.root, className),
    'data-illustration': name,
    ...rest,
  };

  if (!src) {
    return (
      <span
        {...common}
        style={boxStyle}
        role={decorative ? undefined : 'img'}
        aria-label={decorative ? undefined : alt}
        aria-hidden={decorative || undefined}
        data-loading=""
      />
    );
  }
  return (
    <img
      {...common}
      src={src}
      width={size.width}
      height={size.height}
      style={boxStyle}
      alt={decorative ? '' : alt}
      aria-hidden={decorative || undefined}
      draggable={false}
    />
  );
}
