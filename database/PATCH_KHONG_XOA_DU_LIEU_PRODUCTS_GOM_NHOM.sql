-- PATCH CHO DATABASE ĐANG DÙNG: chuyển products sang gom nhóm sản phẩm
-- Chạy file này trong Supabase SQL Editor nếu bạn KHÔNG muốn xóa dữ liệu cũ.

-- 1) Đảm bảo có cột nhóm sản phẩm
alter table products add column if not exists group_name text;
update products set group_name = coalesce(nullif(trim(group_name), ''), coalesce(nullif(trim(code), ''), 'CHUNG')) where group_name is null or trim(group_name) = '';
alter table products alter column group_name set default '';
alter table products alter column group_name set not null;

-- 2) Bỏ unique cũ theo code, vì bây giờ unique theo Nhóm + Tên sản phẩm
alter table products drop constraint if exists products_code_key;
alter table products drop constraint if exists products_code_unique;

-- 3) Cho phép code rỗng/auto, app sẽ ưu tiên nhóm + tên
alter table products alter column code drop not null;

-- 4) Xử lý dữ liệu bị trùng trước khi tạo unique mới
-- Các dòng trùng nhóm+tên giữ lại dòng mới nhất, xóa dòng còn lại.
delete from products a
using products b
where a.id < b.id
  and lower(trim(a.group_name)) = lower(trim(b.group_name))
  and lower(trim(a.name)) = lower(trim(b.name));

-- 5) Tạo unique theo đúng logic mới
alter table products drop constraint if exists products_group_name_name_unique;
alter table products add constraint products_group_name_name_unique unique (group_name, name);

-- 6) RLS cho user đã đăng nhập
alter table products enable row level security;
drop policy if exists products_owner_all on products;
drop policy if exists "products_owner_all" on products;
drop policy if exists products_all_authenticated on products;
drop policy if exists "products_all_authenticated" on products;
create policy "products_all_authenticated"
on products for all
to authenticated
using (true)
with check (true);
