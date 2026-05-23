# Vũ Hoàng Lighting POS - Deploy Vercel

## 1) Chuẩn bị Supabase

1. Mở Supabase project.
2. Vào **SQL Editor**.
3. Chạy file `database/supabase_schema.sql`.
4. Vào **Authentication > Providers > Email** và bật Email login.

## 2) Deploy bằng GitHub + Vercel

1. Tạo repo GitHub mới.
2. Upload toàn bộ thư mục này lên repo.
3. Vào Vercel > **Add New Project** > Import repo.
4. Framework Preset: **Other**.
5. Build Command: `npm run build`.
6. Output Directory: `public`.
7. Thêm Environment Variables:

```txt
SUPABASE_URL=https://dujqgffrpyqewtobjfag.supabase.co
SUPABASE_ANON_KEY=sb_publishable_qCCWvQH0rKCnVqRNjDGnBw_RVt-I8TD
BANK_NAME=VP BANK
BANK_ACCOUNT_NO=5577626198
BANK_ACCOUNT_NAME=HKD HOANG VU LIGHTING
BANK_QR_IMAGE=qr.jpg
```

8. Bấm **Deploy**.

## 3) Deploy bằng Vercel CLI

```bash
npm install
npm i -g vercel
vercel login
vercel env add SUPABASE_URL production
vercel env add SUPABASE_ANON_KEY production
vercel env add BANK_NAME production
vercel env add BANK_ACCOUNT_NO production
vercel env add BANK_ACCOUNT_NAME production
vercel env add BANK_QR_IMAGE production
vercel --prod
```

## 4) Chạy thử local

Tạo file `.env.local` từ `.env.example`, sau đó chạy:

```bash
npm install
set -a && source .env.local && set +a
npm run build
npm run preview
```

Mở: http://localhost:3000

## 5) Lưu ý bảo mật

- Supabase anon/publishable key được phép dùng ở frontend, nhưng database phải bật RLS.
- Không đưa `service_role` key lên Vercel hoặc frontend.
- Mỗi nhân viên nên có tài khoản riêng trong Supabase Auth.


## Bản đã tích hợp Supabase

Mình đã tích hợp sẵn:
- SUPABASE_URL: https://jrkmhalznaxsskazyggt.supabase.co
- SUPABASE_ANON_KEY: sb_publishable_VHNiWKy9mwV3rZAvLs85pQ_fKKFFQQh

Vì vậy bạn có thể deploy thẳng lên Vercel mà chưa cần nhập Environment Variables.
Nếu sau này đổi Supabase project, vào Vercel → Project Settings → Environment Variables và thêm SUPABASE_URL, SUPABASE_ANON_KEY rồi redeploy.
