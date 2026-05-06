# Vercel Deployment Guide

## Step 1: Chuẩn bị Environment Variables

### Local - Cập nhật `.env.local`:

```bash
# Supabase (đã có)
NEXT_PUBLIC_SUPABASE_URL=https://ryveftgditasvzblrrig.supabase.co
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=sb_publishable_j2Ittvk7AJV-usH3u2X9tA_DyMugYdq

# Backend API URL - CẬP NHẬT SAU KHI RENDER DEPLOY XONG
NEXT_PUBLIC_API_URL=https://dantalabs-backend.onrender.com
```

## Step 2: Deploy lên Vercel

### Cách 1: Qua Vercel CLI
```bash
npm i -g vercel
vercel login
vercel
```

### Cách 2: Qua GitHub
1. Push code lên GitHub (đã làm rồi)
2. Vào https://vercel.com/new
3. Import repo `Sales-Pipeline-Lead-Generation`
4. Cấu hình:
   - **Framework Preset**: Next.js
   - **Root Directory**: `.` (root)
   - **Build Command**: `npm run build`
   - **Output Directory**: `.next`

5. **Environment Variables** - Thêm các biến:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://ryveftgditasvzblrrig.supabase.co
   NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=sb_publishable_j2Ittvk7AJV-usH3u2X9tA_DyMugYdq
   NEXT_PUBLIC_API_URL=https://dantalabs-backend.onrender.com
   ```

6. Click **Deploy**

## Step 3: Sau khi Vercel deploy xong

1. Copy domain Vercel (VD: `https://your-app.vercel.app`)
2. Cập nhật Render CORS:
   - Trong `render.yaml`, thêm domain Vercel vào `allowedOrigins`
   - Push lên GitHub → Render tự deploy lại

## Step 4: Test

Frontend: `https://your-app.vercel.app`
Backend: `https://dantalabs-backend.onrender.com/health`
