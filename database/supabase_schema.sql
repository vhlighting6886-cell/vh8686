-- Vũ Hoàng Lighting POS - schema đơn giản, dùng chung nội bộ
-- Chạy trong Supabase SQL Editor nếu muốn tạo lại bảng sạch.

create extension if not exists "pgcrypto";

drop policy if exists products_owner_all on public.products;
drop policy if exists "products_owner_all" on public.products;
drop policy if exists products_all_authenticated on public.products;
drop policy if exists "products_all_authenticated" on public.products;
drop policy if exists customers_owner_all on public.customers;
drop policy if exists "customers_owner_all" on public.customers;
drop policy if exists customers_all_authenticated on public.customers;
drop policy if exists "customers_all_authenticated" on public.customers;
drop policy if exists orders_owner_all on public.orders;
drop policy if exists "orders_owner_all" on public.orders;
drop policy if exists orders_all_authenticated on public.orders;
drop policy if exists "orders_all_authenticated" on public.orders;
drop policy if exists order_items_owner_all on public.order_items;
drop policy if exists "order_items_owner_all" on public.order_items;
drop policy if exists order_items_all_authenticated on public.order_items;
drop policy if exists "order_items_all_authenticated" on public.order_items;

drop table if exists public.order_items cascade;
drop table if exists public.orders cascade;
drop table if exists public.products cascade;
drop table if exists public.customers cascade;

create table public.products (
  id uuid primary key default gen_random_uuid(),
  group_name text not null,
  code text not null unique,
  name text not null,
  unit text default 'CÁI',
  price numeric default 0,
  created_at timestamptz default now()
);

create table public.customers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text,
  address text,
  note text,
  created_at timestamptz default now()
);

create table public.orders (
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

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.orders(id) on delete cascade,
  code text,
  name text,
  unit text,
  quantity numeric default 0,
  price numeric default 0,
  total numeric default 0,
  created_at timestamptz default now()
);

alter table public.products enable row level security;
alter table public.customers enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

create policy "products_all_authenticated" on public.products for all to authenticated using (true) with check (true);
create policy "customers_all_authenticated" on public.customers for all to authenticated using (true) with check (true);
create policy "orders_all_authenticated" on public.orders for all to authenticated using (true) with check (true);
create policy "order_items_all_authenticated" on public.order_items for all to authenticated using (true) with check (true);
