#!/bin/sh

LOCKFILE="/app/web/sites/default/files/.lagoon_trial_installed"

if [ -f "$LOCKFILE" ]; then
  echo "Site has already been installed"
elif [ -z "$AI_LLM_API_URL" ]; then
  echo "Please configure the AI_LLM_API_URL variable"
elif [ -z "$AI_LLM_API_TOKEN" ]; then
  echo "Please configure the AI_LLM_API_TOKEN variable"
else
  # Install the site from the bundled demo recipe (config + default content).
  echo "Installing the site from the drupal-org-ai-ck-editor recipe"
  drush -n site:install /app/recipes/drupal-org-ai-ck-editor

  # Install the provider.
  echo "Installing the amazee.io AI provider"

  drush recipe /app/recipes/ai_provider_amazeeio_recipe \
    --input=ai_provider_amazeeio_recipe.llm_host=$AI_LLM_API_URL \
    --input=ai_provider_amazeeio_recipe.llm_api_key=$AI_LLM_API_TOKEN

  # Demos don't self-update; remove the Update Manager stack so admins don't
  # see "out of date" warnings. Per-module + `|| true` handles both the CMS
  # demos (all three present) and search (only `update`).
  echo "Uninstalling update-manager modules"
  for module in automatic_updates update package_manager; do
    drush -y pm:uninstall "$module" || true
  done

  # Clear the cache
  echo "Rebuilding of the Drupal cache"
  drush cr

  touch $LOCKFILE
  echo "Site install complete."
fi
