// Cloudflare Pages — advanced-mode Worker.
// Protects the ENTIRE site with a shared password (HTTP Basic Auth), server-side:
// the content is never delivered until the password is entered.
//
// Set the password in the Cloudflare dashboard:
//   Pages project -> Settings -> Variables and Secrets
//   SITE_PASSWORD = <your-password>   (add it as an encrypted Secret)
//
// The username field can be anything; only the password is checked.

const REALM = "Serve - alaard alastraatiijii (mahmii)";

export default {
  async fetch(request, env) {
    const expected = env.SITE_PASSWORD;

    // Fail closed: if no password is configured, deny everything.
    if (!expected) {
      return new Response("SITE_PASSWORD is not configured in the Pages project.", {
        status: 503,
        headers: { "Content-Type": "text/plain; charset=utf-8" },
      });
    }

    if (isAuthorized(request, expected)) {
      // Authorized -> serve the requested static asset.
      return env.ASSETS.fetch(request);
    }

    return new Response("الدخول يتطلب كلمة المرور.", {
      status: 401,
      headers: {
        "WWW-Authenticate": `Basic realm="${REALM}", charset="UTF-8"`,
        "Content-Type": "text/plain; charset=utf-8",
        "Cache-Control": "no-store",
      },
    });
  },
};

function isAuthorized(request, expected) {
  const header = request.headers.get("Authorization") || "";
  const [scheme, encoded] = header.split(" ");
  if (scheme !== "Basic" || !encoded) return false;

  let decoded;
  try {
    // base64 -> bytes -> UTF-8 (supports non-ASCII passwords too)
    const bytes = Uint8Array.from(atob(encoded), (c) => c.charCodeAt(0));
    decoded = new TextDecoder().decode(bytes);
  } catch {
    return false;
  }

  const sep = decoded.indexOf(":");
  if (sep === -1) return false;
  const password = decoded.slice(sep + 1);

  return timingSafeEqual(password, expected);
}

function timingSafeEqual(a, b) {
  const enc = new TextEncoder();
  const ab = enc.encode(a);
  const bb = enc.encode(b);
  if (ab.length !== bb.length) return false;
  let diff = 0;
  for (let i = 0; i < ab.length; i++) diff |= ab[i] ^ bb[i];
  return diff === 0;
}
