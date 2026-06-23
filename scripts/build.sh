#!/usr/bin/env bash
# Re-encrypts the site from Serve/*.html into docs/ (the deployed, password-protected build).
#
# The password is NEVER stored in the repo. Provide it at build time:
#   STATICRYPT_PASSWORD='your-password' ./scripts/build.sh
# (or run without it and you'll be prompted)
#
# Output: docs/  -> AES-encrypted copies of every page + a browser password gate.
set -euo pipefail
cd "$(dirname "$0")/.."

# Fixed salt so the "Remember me" unlock works across ALL pages with one login.
SALT='0fa89c2540d4a017aabbccddeeff0011'

rm -rf docs
mkdir -p docs

npx --yes staticrypt@3 Serve/*.html \
  ${STATICRYPT_PASSWORD:+-p "$STATICRYPT_PASSWORD"} \
  -s "$SALT" \
  -c false \
  -d docs \
  --remember 365 \
  --short \
  --template-title 'سيرف · Serve — دخول محمي' \
  --template-instructions 'هذا العرض الاستراتيجي لمنصة «سيرف» محمي بكلمة مرور. الرجاء إدخال كلمة المرور للاطّلاع.' \
  --template-placeholder 'كلمة المرور' \
  --template-button 'دخول' \
  --template-remember 'تذكّرني على هذا الجهاز' \
  --template-error 'كلمة المرور غير صحيحة. حاول مرة أخرى.' \
  --template-color-primary '#0FA89C' \
  --template-color-secondary '#0A2540'

touch docs/.nojekyll
echo "Built docs/ ($(ls docs/*.html | wc -l) encrypted pages)."
