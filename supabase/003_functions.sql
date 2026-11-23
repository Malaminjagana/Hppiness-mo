-- FIFO sale in ONE transaction. Call: select record_sale(product_id, qty, date, price, notes)
create or replace function public.record_sale(p_product uuid, p_qty numeric, p_date date, p_price numeric, p_notes text default null) returns uuid language plpgsql security definer as $$
declare v_sale uuid; v_remaining numeric:=p_qty; v_batch record; v_take numeric; v_stock numeric;
begin
 if not public.is_allowed() then raise exception 'not allowed'; end if;
 select coalesce(sum(qty_remaining),0) into v_stock from public.purchase_batches where product_id=p_product and user_id=auth.uid();
 if v_stock < p_qty then raise exception 'Insufficient stock: have %, requested %', v_stock, p_qty; end if;
 insert into public.sales(user_id,product_id,qty,sale_date,unit_price,notes) values(auth.uid(),p_product,p_qty,p_date,p_price,p_notes) returning id into v_sale;
 for v_batch in select * from public.purchase_batches where product_id=p_product and user_id=auth.uid() and qty_remaining>0 order by arrival_date asc, created_at asc loop
  exit when v_remaining<=0; v_take:=least(v_batch.qty_remaining,v_remaining);
  update public.purchase_batches set qty_remaining=qty_remaining-v_take, sold_out_at=case when qty_remaining-v_take=0 then now() else sold_out_at end where id=v_batch.id;
  insert into public.sale_allocations(user_id,sale_id,batch_id,qty,cost_per_unit) values(auth.uid(),v_sale,v_batch.id,v_take,v_batch.cost_per_unit);
  v_remaining:=v_remaining-v_take;
 end loop;
 insert into public.stock_movements(user_id,product_id,type,qty_delta,reference_type,reference_id,reason) values(auth.uid(),p_product,'sale',-p_qty,'sale',v_sale,'Sale recorded');
 return v_sale;
end; $$;
create or replace function public.reverse_sale(p_sale uuid) returns void language plpgsql security definer as $$
declare r record; v_product uuid; v_qty numeric;
begin
 if not public.is_allowed() then raise exception 'not allowed'; end if;
 select product_id,qty into v_product,v_qty from public.sales where id=p_sale and user_id=auth.uid();
 if not found then raise exception 'sale not found'; end if;
 for r in select * from public.sale_allocations where sale_id=p_sale loop update public.purchase_batches set qty_remaining=qty_remaining+r.qty, sold_out_at=null where id=r.batch_id; end loop;
 delete from public.sale_allocations where sale_id=p_sale; delete from public.sales where id=p_sale;
 insert into public.stock_movements(user_id,product_id,type,qty_delta,reference_type,reference_id,reason) values(auth.uid(),v_product,'reversal',v_qty,'sale',p_sale,'Sale reversed');
end; $$;
create or replace function public.record_purchase(p_product uuid, p_qty numeric, p_purchase date, p_arrival date, p_total numeric, p_supplier text default null, p_notes text default null) returns uuid language plpgsql security definer as $$
declare v_id uuid;
begin
 if not public.is_allowed() then raise exception 'not allowed'; end if;
 insert into public.purchase_batches(user_id,product_id,qty_purchased,qty_remaining,purchase_date,arrival_date,total_cost,supplier,notes) values(auth.uid(),p_product,p_qty,p_qty,p_purchase,p_arrival,p_total,p_supplier,p_notes) returning id into v_id;
 insert into public.stock_movements(user_id,product_id,type,qty_delta,reference_type,reference_id,reason) values(auth.uid(),p_product,'purchase',p_qty,'purchase_batch',v_id,'Purchase recorded');
 return v_id;
end; $$;
