BẢN ĐÃ TÁCH RIÊNG - GOM NHÓM SẢN PHẨM

1. Code app nằm ở: public/index.html
2. SQL tạo mới sạch nằm ở: database/supabase_schema.sql
3. SQL sửa database đang dùng, không xóa dữ liệu: database/PATCH_KHONG_XOA_DU_LIEU_PRODUCTS_GOM_NHOM.sql

Cách làm khuyến nghị:
- Nếu database đang có sản phẩm: chạy file PATCH_KHONG_XOA_DU_LIEU_PRODUCTS_GOM_NHOM.sql
- Sau đó upload toàn bộ thư mục này lên GitHub.
- Vercel Redeploy và bật Clear Build Cache.

Logic mới:
- Sản phẩm không unique theo mã nữa.
- Sản phẩm unique theo Nhóm sản phẩm + Tên sản phẩm.
- Nhập trùng nhóm + tên sẽ tự cập nhật ĐVT/Giá bán, không báo duplicate.
- Bán hàng nhanh: gõ nhóm sản phẩm, hệ thống hiện các sản phẩm thuộc nhóm để bấm Thêm.
