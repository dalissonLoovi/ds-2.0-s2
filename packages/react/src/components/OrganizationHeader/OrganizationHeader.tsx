import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { ChipTag } from '../ChipTag/ChipTag';
import styles from './OrganizationHeader.module.css';

export type OrganizationHeaderProps = HTMLAttributes<HTMLElement> & {
  project?: string;
  projectHref?: string;
  title?: string;
  type?: string;
  description?: string;
  showProject?: boolean;
  showType?: boolean;
  showDescription?: boolean;
  showLabel?: boolean;
};

export function OrganizationHeader({
  project = 'Project',
  projectHref,
  title = 'Title',
  type = 'Type',
  description = 'Description',
  showProject = true,
  showType = true,
  showDescription = true,
  showLabel = true,
  className,
  ...rest
}: OrganizationHeaderProps) {
  return (
    <header className={cx(styles.root, className)} {...rest}>
      {showProject &&
        (projectHref ? (
          <a className={styles.project} href={projectHref}>
            {project}
          </a>
        ) : (
          <p className={styles.project}>{project}</p>
        ))}
      {showLabel && <h1 className={styles.title}>{title}</h1>}
      {showType && (
        <ChipTag
          size="sm"
          intent="success"
          emphasis="soft"
          label={type}
          showLeadingIcon
          leadingIcon="circle-check-outline"
        />
      )}
      {showDescription && <p className={styles.description}>{description}</p>}
    </header>
  );
}
