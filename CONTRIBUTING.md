# Panduan Kontribusi — Website Desa Jatirokeh

Terima kasih ingin berkontribusi! Proyek ini dibangun dengan **Laravel 12 + Filament + Livewire + Tailwind**
dan dikembangkan dengan bantuan **Kiro**. Tata kelola development terdapat di folder `.kiro/`.

## Mulai cepat
```bash
git clone https://github.com/henkyaliazki/refactoring-web-desa.git
cd refactoring-web-desa
composer install && npm install
cp .env.example .env && php artisan key:generate
php artisan migrate --seed
npm run build
```

## Struktur tata kelola Kiro (`.kiro/`)

### Steering — `.kiro/steering/`
Aturan & konteks yang otomatis dipakai Kiro saat membantu coding:
- `product.md` — visi produk & prinsip (selalu aktif)
- `tech.md` — stack & perintah (selalu aktif)
- `structure.md` — struktur folder & penamaan (selalu aktif)
- `git-workflow.md` — alur branch/commit/PR (selalu aktif)
- `code-style.md` — standar PHP (aktif saat menyentuh `*.php`)
- `testing.md` — standar test (aktif di `tests/`)
- `security-privacy.md` — aturan privasi PII (aktif di kode surat/akun)
- `database.md`, `powers.md` — acuan manual

### Specs — `.kiro/specs/`
Perencanaan fitur berbasis requirements → design → tasks:
- `laravel-foundation/` — fondasi aplikasi (kerjakan lebih dulu)
- `transparansi-apbdes/` — contoh spec fitur lengkap

Kerjakan tugas dengan mengikuti `tasks.md` pada tiap spec secara berurutan.

### Hooks — `.kiro/hooks/`
Otomatisasi: format PHP saat simpan, jalankan test saat kode berubah, sinkronkan dokumen skema
saat migration diubah, dan tinjauan privasi untuk kode ber-PII.

### Database
Skema lengkap: [`docs/DATABASE.md`](docs/DATABASE.md) (ERD) & [`database/schema.sql`](database/schema.sql) (DDL).

## Alur kerja
1. Buat branch: `feat/...`, `fix/...`, `docs/...`
2. Ikuti standar di `.kiro/steering/`
3. Sebelum PR: `./vendor/bin/pint` + `./vendor/bin/pest` (hijau)
4. Buka Pull Request ke `main` dengan deskripsi jelas

## Prinsip yang tidak boleh dilanggar
- **Mobile-first** & Bahasa Indonesia untuk antarmuka.
- **Transparansi yang dapat diverifikasi** (sertakan bukti & sumber data).
- **Lindungi data pribadi warga** sesuai UU PDP (lihat `security-privacy.md`).
- Uang sebagai integer rupiah penuh.
