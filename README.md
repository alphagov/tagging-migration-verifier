# tagging-migration-verifier

This repository contains a set of scripts that check our progress in migrating to the new tagging infrastructure.

## verify_migrated_apps

`verify_migrated_apps` compares tags in [contentapi](https://github.com/alphagov/govuk_content_api) to [content-store](https://github.com/alphagov/content-store), to make sure the two are kept in sync.

### Usage

The script will check the dev environment if GOVUK_APP_DOMAIN is not set.

In tasks run by Jenkins, GOVUK_APP_DOMAIN will be available and point to the preview/staging/production domains.

Run the script with

    bundle exec bin/verify_migrated_apps

## fetch_publishing_api_links

The script will check the dev environment if DATABASE_URL is not set.

This script extracts all links from the publishing api, for later comparison
with [rummager](https://github.com/alphagov/rummager) data.

### Usage

Run the script with

    govuk_setenv publishing-api bundle exec bin/fetch_publishing_api_links FILE_NAME
