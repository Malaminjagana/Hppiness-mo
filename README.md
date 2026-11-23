# Jagana African Shop — PHONE + PRODUCTION READY (HTML/CSS/JS + Supabase)
Private shop for Mohamed Jagana only. Phone-first, installable, works offline in demo mode.

## What is in this ZIP
- index.html — the whole app (HTML + CSS + JS, phone bottom nav)
- js/config.js — THE ONLY FILE YOU EDIT (Supabase URL + anon key)
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

## STEP 2 — Add your keys
1. Supabase -> Settings -> API -> copy Project URL + anon public key (NOT service_role)
2. Open js/config.js -> paste them -> save
3. Supabase -> Auth -> URL Configuration -> Site URL = your Vercel URL (after Step 4, come back and set it)
   Redirect URLs -> add same Vercel URL

## STEP 3 — GitHub
1. github.com -> New repository -> name jagana-shop -> Create
2. Upload ALL files from this ZIP (not the zip itself): index.html, js/config.js, manifest.json, sw.js, icon.png, vercel.json, supabase/*.sql, README.md
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
- Login page calls supabase.auth.signInWithPassword(email, password)
- Supabase checks password. If wrong -> "Invalid login credentials"
- App then checks allowed_users for that user id. If NOT there -> logs out immediately, "not authorized"
- If OK -> loads products/batches/sales/expenses FROM Supabase (RLS: user_id = auth.uid() + is_allowed())
- If config still has placeholders -> DEMO mode: demo email/password in js/config.js, data in browser only. Demo STOPS working once real keys are pasted.
- Logout: supabase.auth.signOut() + reload.

## If login fails, check in order
1. Keys in js/config.js correct? No extra spaces? Pushed to GitHub? Vercel redeployed?
2. Mohamed in Auth > Users? Auto-confirm ticked?
3. allowed_users has his UUID? (run select * from allowed_users;)
4. Signup OFF? Site URL = Vercel URL?
5. RLS: all 001-004 SQL ran without errors?

## Images
Add Product -> Add image -> JPG/PNG/WebP max 5MB.
Demo mode: saved in browser. Supabase mode: uploaded to private Storage bucket product-images as <user_id>/new/<uuid>-file, signed URL saved as image_url. Only Mohamed can read/upload/delete (Storage RLS).
