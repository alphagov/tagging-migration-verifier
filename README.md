# tagging-migration-verifier

Tagging migration verifier is a script that checks our progress in migrating to the new tagging infrastructure.

It compares tags in contentapi to content-store, to make sure the two are kept in sync.

## Running the script
The script will check the dev environment if GOVUK_APP_DOMAIN is not set.

In tasks run by Jenkins, GOVUK_APP_DOMAIN will be available and point to the preview/staging/production domains.

Run the script with

    bundle exec bin/verify_migrated_apps
