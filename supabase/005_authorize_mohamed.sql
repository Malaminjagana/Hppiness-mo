-- AFTER creating Mohamed in Auth > Users, copy his UUID and run this.
-- Replace BOTH placeholders.
insert into public.allowed_users (user_id, email)
values ('PASTE-MOHAMED-UUID-HERE', 'mohamed.jagana@example.com')
on conflict (user_id) do nothing;
-- Check: select * from public.allowed_users;
