# Tasks — Fondasi Aplikasi Laravel

- [ ] 1. Inisialisasi proyek Laravel 12
  - Buat proyek Laravel 12 di root repo (pertahankan `docs/`, `database/schema.sql`, `.kiro/`, prototipe `/mockup` bila masih dipakai sebagai referensi)
  - Konfigurasi `.env.example` (SQLite dev), generate app key
  - Pasang Tailwind + Vite, pastikan `npm run build` sukses
  - _Requirements: R1_

- [ ] 2. Pasang & konfigurasi dependensi inti
  - Tambah Filament 3, Livewire 3, Pest, Pint, spatie/activitylog
  - Konfigurasi panel Filament di `/admin`
  - _Requirements: R1, R4_

- [ ] 3. Buat enum domain
  - `LetterStatus`, `ProjectStatus`, `PostStatus`, `BudgetItemType`, `BusinessCategory`, dll.
  - _Requirements: R2.3_

- [ ] 4. Tulis migration untuk seluruh 25 tabel
  - [ ] 4.1 Modul akses & konten: roles, users, categories, posts
  - [ ] 4.2 Modul APBDes: budgets, budget_items, documents, projects, project_photos
  - [ ] 4.3 Modul surat: letter_types, letter_requests (+soft delete), attachments, logs
  - [ ] 4.4 Modul kependudukan, profil, potensi, galeri, aspirasi, settings
  - [ ] 4.5 Modul UMKM: businesses, business_products
  - Pastikan uang BIGINT, enum, foreign key ON DELETE benar
  - _Requirements: R2_

- [ ] 5. Buat model Eloquent + relasi + cast enum
  - Definisikan `$fillable`, relasi, cast enum & tanggal pada tiap model
  - _Requirements: R2.3, R3_

- [ ] 6. Seeder & factory
  - Seeder: roles, batas wilayah, pengaturan situs, contoh APBDes & berita
  - Factory untuk model utama (untuk test)
  - _Requirements: R1.2_

- [ ] 7. Autentikasi & peran
  - Relasi user–role, guard login Filament, blokir user nonaktif
  - Policy per modul sesuai matriks otorisasi
  - _Requirements: R3_

- [ ] 8. Dashboard & resource Filament dasar
  - Widget ringkasan (surat masuk, kunjungan, realisasi APBDes)
  - Resource untuk Post & Category sebagai contoh, navigasi terfilter peran
  - _Requirements: R4_

- [ ] 9. Kerangka halaman publik
  - Layout Blade + komponen (`x-navbar`, `x-footer`), rute publik sesuai PRD
  - Terjemahkan beranda dari prototipe, meta/OG tag, halaman 404
  - _Requirements: R5_

- [ ] 10. Pengujian fondasi
  - Test: migrasi+seed sukses, login & otorisasi peran, akses resource Filament
  - Jalankan `./vendor/bin/pint` dan `./vendor/bin/pest` hijau
  - _Requirements: R1, R3, R4_
