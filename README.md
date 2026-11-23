# Jagana African Shop — PHONE + PRODUCTION READY (HTML/CSS/JS + Supabase)
Private shop for Mohamed Jagana only. Phone-first and installable, with authentication and shop data provided by Supabase.

## What is in this ZIP
- index.html — the whole app (HTML + CSS + JS, phone bottom nav)
- build-config.js — generates js/config.js from Vercel Environment Variables
- js/config.js — generated config; do not put credentials in this file or commit generated credentials
- manifest.json + sw.js + icon.png — install on phone home screen
- supabase/001_schema.sql ... 005_authorize_mohamed.sql — run in order
- vercel.json

## STEP 1 — Supabase (free) — do this FIRST
1. supabase.com -> New project (free) -> wait 1-2 min
2. SQL Editor -> New query -> run in order: 001, 002, 003, 004
3. Auth -> Providers -> Email ON. Auth -> Settings -> "Allow new users to sign up" -> OFF -> Save
4. Auth -> Users -> Add user -> Mohamed's REAL email + strong password -> Auto Confirm -> Create -> copy UUID
5. SQL Editor -> open 005_authorize_mohamed.sql -> replace UUID + email -> Run
   Check: select * from allowed_users; -> you must see 1 row.

## STEP 2 — Configure Vercel
1. In Vercel Project Settings -> Environment Variables, set SUPABASE_URL and SUPABASE_ANON_KEY using the Supabase Project URL and anon/publishable key (NOT service_role).
2. Keep these values in Vercel only; build-config.js injects them into js/config.js during deployment.
3. Supabase -> Auth -> URL Configuration -> Site URL = your Vercel URL (after Step 4, come back and set it)
   Redirect URLs -> add same Vercel URL

## STEP 3 — GitHub
1. github.com -> New repository -> name jagana-shop -> Create
2. Upload ALL files from this ZIP (not the zip itself): index.html, build-config.js, js/config.js, manifest.json, sw.js, icon.png, vercel.json, supabase/*.sql, README.md
3. Commit

## STEP 4 — Vercel
1. vercel.com -> Sign up with GitHub -> Add New -> Project -> Import jagana-shop -> Deploy
2. You get https://jagana-shop-xxxx.vercel.app
3. Go back to Supabase URL Configuration (Step 2.3) and set Site URL to this link.

## STEP 5 — Phone
1. Open Vercel link on phone -> login with MOHAMED'S REAL Supabase email + password
2. Android Chrome: Menu -> Add to Home screen. iPhone Safari: Share -> Add to Home Screen.
3. Open from home screen.

## How login works (so you can explain it)
- Login uses supabase.auth.signInWithPassword(email, password).
- The app checks allowed_users for the signed-in user id; users without a row are signed out and shown "Not authorized".
- Authorized users see products, purchases, sales, and expenses loaded from Supabase (RLS: user_id = auth.uid() + is_allowed()).
- If environment variables are unavailable, the login page displays "Not connected - check Vercel Environment Variables".
- Logout: supabase.auth.signOut() + reload.

## If login fails, check in order
1. SUPABASE_URL and SUPABASE_ANON_KEY are set in Vercel Environment Variables? Has Vercel redeployed?
2. Mohamed in Auth > Users? Auto-confirm ticked?
3. allowed_users has his UUID? (run select * from allowed_users;)
4. Signup OFF? Site URL = Vercel URL?
5. RLS: all 001-004 SQL ran without errors?

## Images
Add Product -> Add image -> JPG/PNG/WebP max 5MB.
Images are uploaded to the private Supabase Storage bucket product-images as <user_id>/new/<uuid>-file; a signed URL is saved as image_url. Only authorized users can read/upload/delete (Storage RLS).
