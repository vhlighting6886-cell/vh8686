-- PATCH DATABASE CHO BẢN GOM NHÓM GỌN - KHÔNG XÓA DỮ LIỆU

alter table products add column if not exists group_name text;

update products
set group_name = coalesce(nullif(group_name,''), code, 'KHAC')
where group_name is null or group_name = '';

alter table products alter column group_name set default '';
alter table products alter column group_name drop not null;
alter table products alter column code drop not null;

alter table products drop constraint if exists products_code_key;
alter table products drop constraint if exists products_code_unique;
alter table products drop constraint if exists products_group_name_name_unique;

create unique index if not exists products_group_name_name_unique
on products (group_name, name);

drop policy if exists products_owner_all on products;
drop policy if exists "products_owner_all" on products;
drop policy if exists products_all_authenticated on products;
drop policy if exists "products_all_authenticated" on products;

alter table products enable row level security;

create policy "products_all_authenticated"
on products
for all
to authenticated
using (true)
with check (true);
