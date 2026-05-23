-- Chạy file này trong Supabase SQL Editor để database khớp bản gom nhóm V3.

alter table products add column if not exists group_name text;
alter table products alter column group_name drop not null;
alter table products alter column group_name set default '';
update products set group_name = coalesce(nullif(group_name,''), code, '') where group_name is null or group_name = '';

alter table products alter column code drop not null;

alter table products drop constraint if exists products_code_key;
alter table products drop constraint if exists products_code_unique;
alter table products drop constraint if exists products_group_name_name_unique;

-- Xóa dòng trùng cùng nhóm + tên, giữ dòng mới nhất.
delete from products a
using products b
where a.ctid < b.ctid
and upper(trim(coalesce(a.group_name,''))) = upper(trim(coalesce(b.group_name,'')))
and upper(trim(coalesce(a.name,''))) = upper(trim(coalesce(b.name,'')));

alter table products add constraint products_group_name_name_unique unique (group_name, name);

alter table products enable row level security;
drop policy if exists products_owner_all on products;
drop policy if exists "products_owner_all" on products;
drop policy if exists products_all_authenticated on products;
drop policy if exists "products_all_authenticated" on products;
create policy "products_all_authenticated"
on products for all to authenticated
using (true) with check (true);
