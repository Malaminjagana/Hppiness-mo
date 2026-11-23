// ============================================================
//  JAGANA SHOP — CONFIG — THIS IS THE ONLY FILE YOU MUST EDIT
//  1. Create free Supabase project at supabase.com
//  2. Supabase -> Settings -> API -> copy Project URL + anon public key
//  3. Paste them below, save, push to GitHub -> Vercel redeploys
//  4. NEVER paste the service_role key here. Only anon key.
// ============================================================
window.JAGANA_CONFIG = {
  SUPABASE_URL: "https://YOUR-PROJECT.supabase.co",   // <-- paste yours
  SUPABASE_ANON_KEY: "YOUR-ANON-KEY-HERE",           // <-- paste yours
  // Demo mode is used ONLY while the 2 lines above are still placeholders.
  // Once you paste real keys, demo login stops working and only Mohamed's Supabase account works.
  DEMO_EMAIL: "mohamed.jagana@shop.local",
  DEMO_PASSWORD: "demo1234",
  SHOP_NAME: "Jagana African Shop",
  CURRENCY: "EUR" // EUR | GBP | USD
};
