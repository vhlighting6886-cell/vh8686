drop table if exists order_items cascade;
drop table if exists orders cascade;
drop table if exists products cascade;
drop table if exists customers cascade;

create extension if not exists "pgcrypto";

create table products (
  id uuid primary key default gen_random_uuid(),
  group_name text not null default '',
  code text not null unique,
  name text not null,
  unit text default 'CÁI',
  price numeric default 0,
  created_at timestamptz default now()
);

create table customers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text,
  address text,
  note text,
  created_at timestamptz default now()
);

create table orders (
  id uuid primary key default gen_random_uuid(),
  invoice_no text not null,
  customer_name text,
  customer_phone text,
  customer_address text,
  note text,
  subtotal numeric default 0,
  discount numeric default 0,
  shipping_fee numeric default 0,
  paid numeric default 0,
  grand numeric default 0,
  debt numeric default 0,
  created_at timestamptz default now()
);

create table order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references orders(id) on delete cascade,
  code text,
  name text,
  unit text,
  quantity numeric default 0,
  price numeric default 0,
  total numeric default 0,
  created_at timestamptz default now()
);

alter table products enable row level security;
alter table customers enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;

create policy "products_all_authenticated" on products for all to authenticated using (true) with check (true);
create policy "customers_all_authenticated" on customers for all to authenticated using (true) with check (true);
create policy "orders_all_authenticated" on orders for all to authenticated using (true) with check (true);
create policy "order_items_all_authenticated" on order_items for all to authenticated using (true) with check (true);
