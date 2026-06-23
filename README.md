# سيرف · Serve — العرض الاستراتيجي الكامل

عرض استراتيجي متعدد الصفحات لمنصة **سيرف** للصيانة المنزلية (الرياض) — للعرض على الملّاك وصنّاع القرار والمستثمرين.

## الصفحات (13 عامة + نسخة خاصة) — بترتيب شريط التنقّل الموحّد
| الصفحة | المحتوى |
|---|---|
| `present.html` | 🎤 العرض الكامل الجاهز للتقديم (11 محطة + تفاصيل منسدلة ومراجع) + خطة التمويل (أ/ب/ج/الطرح العام) |
| `home.html` | 🏠 الرئيسية — لوحة التنقّل وخريطة الموقع |
| `now.html` | 📊 سيرف الآن — الوضع الحالي بالأرقام + ملف التطبيق |
| `index.html` | 🎯 العرض التنفيذي (14 شريحة) |
| `details.html` | 📋 التفاصيل الكاملة + التسعير + **نموذج الإسناد** (دُمجت فيها صفحة المقارنات) |
| `plan.html` | 🧭 الخطة الشاملة الكاملة (كل التفاصيل التنفيذية مكشوفة) |
| `launch-plan.html` | 🗺️ خطة التدشين (7 مراحل ببوّابات بلا تواريخ) + سوق القطع والعمالة + **التحفيز التسويقي** + **خطة التوظيف** (دُمجت فيها launch و roadmap) |
| `roadmap-tools.html` | 🧰 خارطة الطريق والمنهجيات والأدوات (WBS · جانت/المسار الحرج · كانبان) — للإدارة |
| `blueprint.html` | 📘 المنتج النهائي + **الترشيح الأخير** (دُمجت فيها صفحة final) |
| `pulse.html` | ⚡ محاكاة Serve Pulse (إدارة المرافق) |
| `sense.html` | 🧠 معمارية Serve Sense (التشخيص بالذكاء الاصطناعي) |
| `expansion.html` | 🧩 التوسّع: قنوات التأمين/التجزئة + خطوط الخدمة الجديدة |
| `qa.html` | ❓ سؤال وجواب — بنك القرارات |
| `legal.html` | ⚖️ الحزمة القانونية وفق الأنظمة السعودية |

> **تنظيم 2026:** دُمجت 4 صفحات متكرّرة لتقليل التشتّت — `final → blueprint#final-pick` · `launch → launch-plan#launch-incentives` · `roadmap → launch-plan#hiring-execution` · `comparisons → details#assignment-model`. شريط تنقّل موحّد على كل الصفحات.

> ملف HTML ثابت بالكامل (Tajawal + Inter، RTL، Chart.js عبر CDN). يُفتح مباشرةً في أي متصفّح.

🔒 **مستودع خاص** — يحتوي محتوى استراتيجي وتفاوضي حسّاس. لا تجعله عاماً.

---

## النشر المحمي بكلمة مرور (Deployment)

الطريقة المعتمدة: **Cloudflare Pages** مع بوابة كلمة مرور **من الخادم** (Cloudflare Worker / Basic Auth). المحتوى لا يُرسَل للمتصفّح إطلاقاً قبل إدخال كلمة المرور، وكل الصفحات محميّة بكلمة مرور واحدة مشتركة.

### الطريقة المعتمدة — Cloudflare Pages + كلمة مرور (Worker)

الملفات في `cloudflare/`:
- `_worker.js` — يفرض كلمة المرور على كل الطلبات ويقرأها من متغيّر البيئة `SITE_PASSWORD` (لا كلمة مرور مخزّنة في الملفات؛ يفشل مغلقاً إن لم تُضبط).
- `scripts/build-cloudflare.sh` — يجمّع مجلد النشر `cloudflare/dist/` = صفحات `Serve/*.html` الأصلية + `_worker.js`.

**خطوات النشر (رفع مباشر من اللوحة):**
1. `./scripts/build-cloudflare.sh` لإنشاء `cloudflare/dist/` (أو استخدم ملف `dist` المُرسَل).
2. Cloudflare Dashboard → **Workers & Pages → Create → Pages → Upload assets** → اسحب محتويات `cloudflare/dist/` (الـ14 صفحة + `_worker.js`).
3. بعد الإنشاء: **Settings → Variables and Secrets → Add** → `SITE_PASSWORD` = كلمة المرور (Secret) → احفظ، ثم **Retry deployment**.
4. الموقع يصبح على `https://<project>.pages.dev` ويطلب كلمة المرور (أي اسم مستخدم + كلمة المرور).

**أو عبر Wrangler CLI:**
```bash
./scripts/build-cloudflare.sh
npx wrangler login
npx wrangler pages deploy cloudflare/dist --project-name serve-deck
npx wrangler pages secret put SITE_PASSWORD --project-name serve-deck   # أدخل كلمة المرور
```

> المستودع `hashem` يبقى خاصاً. كلمة المرور تُضبط في إعدادات Cloudflare فقط ولا تُحفَظ في المستودع إطلاقاً.

### بديل — استضافة ثابتة عامة بمحتوى مشفّر (StatiCrypt)

مجلد `docs/` يحتوي نسخة **مشفّرة AES‑256** عبر [StatiCrypt](https://github.com/robinmoisson/staticrypt) (بلا نص صريح)، تصلح للرفع على أي استضافة ثابتة عامة (GitHub Pages على مستودع عام / Netlify Drop). إعادة البناء:
```bash
STATICRYPT_PASSWORD='********' ./scripts/build.sh
```
ملف `.github/workflows/deploy-pages.yml` معطّل تلقائياً (يدوي فقط)؛ يصلح للنشر من هذا المستودع **فقط** بعد ترقية الخطة إلى GitHub Pro (Pages للمستودعات الخاصة).

> ⚠️ في طريقة Cloudflare، الحماية من الخادم (المحتوى لا يُرى بدون كلمة المرور). يُفضّل دائماً كلمة مرور قوية وعدم مشاركة الرابط علناً.
