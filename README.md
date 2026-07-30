# Drupal AI Demo: CKEditor Widgets

A [Drupal CMS](https://www.drupal.org/project/cms) 2.x demo on [Lagoon](https://lagoon.sh) showing AI assistant tools built right into CKEditor with [amazee.ai](https://amazee.ai): summarize text, rewrite to a style guide, and generate image alt text via [AI Automators](https://www.drupal.org/project/ai) and [amazee.ai CKEditor Widgets](https://www.drupal.org/project/amazeeio_ckeditor_widgets).

## How it's built

The whole site is defined by the bundled recipe at `recipes/drupal-org-ai-ck-editor/` — Drupal CMS starter plus the `amazeeio_ckeditor_widgets` recipe (the `Content with AI` text format, AI assistant automator chains) and demo content as YAML. `drush site:install <recipe>` produces the complete demo from a clean database.

amazee.ai credentials are never in the repo. They're injected per environment from `AI_LLM_API_*` env vars — by `.lagoon/scripts/trial_install_configure.sh` (fresh install) or `.lagoon/scripts/polydock_post_deploy.sh` (Polydock trial restore).

## Local development

```sh
cp .env.example .env   # fill in your amazee.ai credentials
docker compose build
docker compose up -d
docker compose exec cli bash -c 'wait-for mariadb:3306'
docker compose exec cli bash -c 'drush -n si /app/recipes/drupal-org-ai-ck-editor && drush -y cr'
```

Then apply the provider recipe with your credentials (or run `.lagoon/scripts/trial_install_configure.sh` inside the cli container with the env vars set).

## Lagoon / Polydock

On first deploy of a trial environment, `polydock_post_deploy.sh` fetches and restores the pre-built `app-data-image.tgz` (fast spin-up), then wires AI credentials from env vars. `create_polydock_app_image.sh` regenerates that image from a verified build — the recipe in git is the source of truth; the image is a build artifact.
