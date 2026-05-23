-- Vũ Hoàng Lighting POS - Supabase schema
-- Chạy trong Supabase SQL Editor. Bật Authentication Email/Password trước khi dùng.

create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid(),
  code text not null,
  name text not null,
  unit text not null default 'Cái',
  price numeric(14,2) not null default 0,
  cost numeric(14,2) not null default 0,
  stock numeric(14,2) not null default 0,
  min_stock numeric(14,2) not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, code)
);

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid(),
  name text not null,
  phone text,
  address text,
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, name)
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid(),
  invoice_no text not null,
  customer_id uuid references public.customers(id) on delete set null,
  customer_name text,
  customer_phone text,
  customer_address text,
  note text,
  status text not null default 'new' check (status in ('new','processing','delivered','cancelled')),
  payment_method text not null default 'cash' check (payment_method in ('cash','bank','cod','other')),
  subtotal numeric(14,2) not null default 0,
  discount numeric(14,2) not null default 0,
  shipping_fee numeric(14,2) not null default 0,
  paid numeric(14,2) not null default 0,
  grand numeric(14,2) not null default 0,
  debt numeric(14,2) not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, invoice_no)
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  code text not null,
  name text not null,
  unit text,
  quantity numeric(14,2) not null default 1,
  price numeric(14,2) not null default 0,
  total numeric(14,2) not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists idx_products_user_code on public.products(user_id, code);
create index if not exists idx_customers_user_name on public.customers(user_id, name);
create index if not exists idx_orders_user_created on public.orders(user_id, created_at desc);
create index if not exists idx_order_items_order on public.order_items(order_id);

alter table public.products enable row level security;
alter table public.customers enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

drop policy if exists products_owner_all on public.products;
create policy products_owner_all on public.products for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists customers_owner_all on public.customers;
create policy customers_owner_all on public.customers for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists orders_owner_all on public.orders;
create policy orders_owner_all on public.orders for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists order_items_owner_all on public.order_items;
create policy order_items_owner_all on public.order_items for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_products_updated_at on public.products;
create trigger set_products_updated_at before update on public.products for each row execute function public.set_updated_at();
drop trigger if exists set_customers_updated_at on public.customers;
create trigger set_customers_updated_at before update on public.customers for each row execute function public.set_updated_at();
drop trigger if exists set_orders_updated_at on public.orders;
create trigger set_orders_updated_at before update on public.orders for each row execute function public.set_updated_at();
