#!/usr/bin/env bash
#
# Rebuild the password-protected site in _site/ from the plaintext in Serve/.
#
# The password is supplied at build time only, via the STATICRYPT_PASSWORD
# environment variable. It is NEVER written to the repository. The shared salt
# lives in Serve/.staticrypt.json so that rebuilds keep the same salt (existing
# "remember me" sessions stay valid).
#
# Usage:
#   STATICRYPT_PASSWORD='your-password' ./scripts/build.sh
#
set -euo pipefail

cd "$(dirname "$0")/.."

: "${STATICRYPT_PASSWORD:?Set STATICRYPT_PASSWORD to the gate password before running}"

rm -rf _site

(
  cd Serve
  npx --yes staticrypt *.html \
    -d ../_site \
    --remember 365 \
    --short \
    --template-title "محتوى محمي — سيرف · Serve" \
    --template-instructions "هذا المحتوى استراتيجي وتفاوضي حسّاس. أدخل كلمة المرور للعرض. فعِّل «تذكّرني» لتتصفّح كل الصفحات بتسجيل دخول واحد." \
    --template-button "دخول" \
    --template-placeholder "كلمة المرور" \
    --template-remember "تذكّرني على هذا الجهاز" \
    --template-error "كلمة المرور غير صحيحة"
)

touch _site/.nojekyll

echo "Built _site/ with $(ls _site/*.html | wc -l | tr -d ' ') encrypted pages."
