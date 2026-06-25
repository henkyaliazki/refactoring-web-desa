---
inclusion: always
---

# Stack Teknologi & Perintah

## Stack
| Lapisan | Teknologi |
|---|---|
| Bahasa | PHP 8.3+ |
| Framework | Laravel 12 |
| Panel Admin | Filament 5 |
| Interaktivitas | Livewire 4 + Alpine.js |
| Styling | Tailwind CSS |
| Database | MySQL 8  |
| Build aset | Vite |
| Chart | Chart.js |
| Queue | Laravel Queue (notifikasi WhatsApp) |
| Penyimpanan file | Laravel Storage (lokal) / S3-compatible |

## Paket yang direkomendasikan
- `filament/filament` — panel admin.
- `spatie/laravel-activitylog` — audit log perubahan (akuntabilitas).
- `spatie/laravel-permission` — hak akses granular.
- `pestphp/pest` — testing.
- `laravel/pint` — formatter (PSR-12).
- `larastan/larastan` — analisis statis.

## Perintah umum
```bash
# Setup awal
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
npm install && npm run build

# Pengembangan (JANGAN dijalankan agent sebagai proses blocking)
php artisan serve         # server lokal
npm run dev               # vite watch
php artisan queue:work    # proses antrian notifikasi

# Kualitas kode — WAJIB sebelum commit
./vendor/bin/pint                 # format kode
./vendor/bin/pest                 # jalankan test
./vendor/bin/phpstan analyse      # analisis statis (jika dipakai)

# Database
php artisan migrate:fresh --seed  # reset + seed (HANYA dev, jangan di produksi)
php artisan make:filament-resource <Model> --generate
```

## Aturan untuk agent (lingkungan sandbox)
- **JANGAN** menjalankan proses blocking/long-running (`php artisan serve`, `npm run dev`, `queue:work`, `--watch`) di foreground.
- Untuk test gunakan mode sekali jalan: `./vendor/bin/pest` (tanpa `--watch`).
- Uang disimpan sebagai integer rupiah penuh — jangan pakai float.
