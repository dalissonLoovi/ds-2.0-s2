import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import { TextHeader } from '../TextHeader/TextHeader';
import styles from './AppHeader.module.css';

export type AppHeaderLayout = 'small-centered' | 'small' | 'medium' | 'large';
export type AppHeaderAppearance = 'default' | 'inverse';
export type AppHeaderHierarchy = 'global' | 'specific' | 'super-app';

export type AppHeaderProps = HTMLAttributes<HTMLElement> & {
  layout?: AppHeaderLayout;
  appearance?: AppHeaderAppearance;
  hierarchy?: AppHeaderHierarchy;
  showLabel?: boolean;
  showAction?: boolean;
  showFirstTrailingAction?: boolean;
  showSecondTrailingAction?: boolean;
  showProfileMenu?: boolean;
  greeting?: string;
  title?: string;
  description?: string;
  avatar?: ReactNode;
  onLeadingAction?: () => void;
  onFirstTrailingAction?: () => void;
  onSecondTrailingAction?: () => void;
  onProfile?: () => void;
};

function layoutForHierarchy(hierarchy: AppHeaderHierarchy, layout: AppHeaderLayout): AppHeaderLayout {
  if (hierarchy === 'global' || hierarchy === 'super-app') return 'small-centered';
  return layout;
}

export function AppHeader({
  layout = 'small-centered',
  appearance = 'default',
  hierarchy = 'global',
  showLabel = true,
  showAction = true,
  showFirstTrailingAction = true,
  showSecondTrailingAction = false,
  showProfileMenu = false,
  greeting = 'Olá, Maria',
  title = 'Title',
  description = 'Description',
  avatar,
  onLeadingAction,
  onFirstTrailingAction,
  onSecondTrailingAction,
  onProfile,
  className,
  ...rest
}: AppHeaderProps) {
  const resolvedLayout = layoutForHierarchy(hierarchy, layout);
  const inverse = appearance === 'inverse';
  const global = hierarchy === 'global';
  const superApp = hierarchy === 'super-app';

  return (
    <header
      className={cx(
        styles.root,
        styles[`layout-${resolvedLayout}`],
        styles[`hierarchy-${hierarchy}`],
        inverse && styles.inverse,
        className,
      )}
      data-layout={resolvedLayout}
      data-appearance={appearance}
      data-hierarchy={hierarchy}
      {...rest}
    >
      <div className={styles.leading}>
        {global ? (
          <>
            <button type="button" className={styles.avatarButton} aria-label="Profile" onClick={onProfile}>
              {avatar ?? <span className={styles.avatarFallback} aria-hidden />}
            </button>
            {showLabel && <p className={styles.greeting}>{greeting}</p>}
          </>
        ) : (
          <>
            {showAction && (
              <Button
                variant="text"
                size="sm"
                intent="primary"
                showLabel={false}
                showIcon
                icon={superApp ? 'menu-2-outline' : 'arrow-left-outline'}
                aria-label={superApp ? 'Menu' : 'Back'}
                onClick={onLeadingAction}
              />
            )}
            <TextHeader
              size={resolvedLayout === 'large' ? 'large' : resolvedLayout === 'medium' ? 'medium' : 'small'}
              alignment={resolvedLayout === 'small-centered' ? 'center' : 'left'}
              title={title}
              description={description}
              showDescription={resolvedLayout !== 'small' && resolvedLayout !== 'small-centered'}
              inverse={inverse}
            />
          </>
        )}
      </div>
      <div className={styles.trailing}>
        {showFirstTrailingAction && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon={global ? 'bell-outline' : 'search-outline'}
            aria-label={global ? 'Notificações' : 'Search'}
            onClick={onFirstTrailingAction}
          />
        )}
        {showSecondTrailingAction && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon="plus-outline"
            aria-label="Add"
            onClick={onSecondTrailingAction}
          />
        )}
        {(showProfileMenu || superApp) && (
          <button type="button" className={styles.avatarButton} aria-haspopup="menu" aria-label="Profile menu" onClick={onProfile}>
            {avatar ?? <span className={styles.avatarFallback} aria-hidden />}
          </button>
        )}
      </div>
    </header>
  );
}
