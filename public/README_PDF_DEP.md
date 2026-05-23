# Vũ Hoàng POS - bản hóa đơn PDF đẹp A5

Đã chỉnh theo mẫu ảnh:
- Bảng hóa đơn A5 gọn, cột tên sản phẩm rộng hơn.
- Cột mã in nhóm sản phẩm ngắn, không in link/app URL.
- Tên sản phẩm không còn bị ghép nhóm + URL.
- QR thanh toán giữ bố cục bên trái, tổng tiền bên phải.

Cách dùng:
1. Thay `index.html` trong repo Vercel bằng file này.
2. Nếu repo có `index.template.html` thì thay luôn file đó.
3. Commit lên GitHub.
4. Vercel → Redeploy → Clear Build Cache.

Lưu ý QR: đặt file `qr.jpg` cùng cấp với `index.html` trong thư mục public/repo để QR hiện khi in.
