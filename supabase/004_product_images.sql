alter table public.products add column if not exists image_url text;
alter table public.products add column if not exists image_path text;
insert into storage.buckets (id, name, public) values ('product-images','product-images', false) on conflict (id) do nothing;
create policy "owner read product images" on storage.objects for select using (bucket_id='product-images' and auth.uid()::text = (storage.foldername(name))[1] and public.is_allowed());
create policy "owner upload product images" on storage.objects for insert with check (bucket_id='product-images' and auth.uid()::text = (storage.foldername(name))[1] and public.is_allowed());
create policy "owner update product images" on storage.objects for update using (bucket_id='product-images' and auth.uid()::text = (storage.foldername(name))[1] and public.is_allowed());
create policy "owner delete product images" on storage.objects for delete using (bucket_id='product-images' and auth.uid()::text = (storage.foldername(name))[1] and public.is_allowed());
