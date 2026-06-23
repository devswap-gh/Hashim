#!/usr/bin/env bash
# Assembles the Cloudflare Pages deploy folder: the ORIGINAL site pages + the
# server-side password Worker (_worker.js). No password is stored in these files;
# the password is configured as the SITE_PASSWORD env var in the Pages project.
#
#   ./scripts/build-cloudflare.sh
#   -> cloudflare/dist/   (drag-drop to Cloudflare, or: npx wrangler pages deploy cloudflare/dist)
set -euo pipefail
cd "$(dirname "$0")/.."

DIST="cloudflare/dist"
rm -rf "$DIST"
mkdir -p "$DIST"

cp Serve/*.html "$DIST"/
cp cloudflare/_worker.js "$DIST"/_worker.js

echo "Built $DIST ($(ls "$DIST"/*.html | wc -l) pages + _worker.js)."
