# Requirements — Fondasi Aplikasi Laravel

## Pengantar
Spec ini menetapkan fondasi teknis untuk mengubah prototipe statis menjadi aplikasi Laravel 12
yang berfungsi: instalasi proyek, skema database (migration), autentikasi & peran, panel admin
Filament, serta kerangka halaman publik. Spec fitur (APBDes, layanan surat, dll.) dibangun di atas fondasi ini.

## Glosarium
- **Operator**: pengguna admin dengan peran memproses surat.
- **APBDes**: Anggaran Pendapatan dan Belanja Desa.

## Requirements

### R1 — Inisialisasi proyek
**User story:** Sebagai kontributor, saya ingin proyek Laravel siap dijalankan secara lokal, agar saya bisa mulai mengembangkan fitur.

#### Acceptance Criteria
1. WHEN kontributor menjalankan `composer install` dan `npm install` THEN seluruh dependensi terpasang tanpa error.
2. WHEN `php artisan migrate --seed` dijalankan pada database kosong THEN seluruh tabel sesuai `docs/DATABASE.md` terbentuk beserta data awal (roles, batas wilayah).
3. THE proyek SHALL menyediakan `.env.example` dengan konfigurasi default (SQLite untuk dev).
4. WHEN `npm run build` dijalankan THEN aset Tailwind & JS ter-compile tanpa error.

### R2 — Skema database via migration
**User story:** Sebagai developer, saya ingin seluruh tabel didefinisikan sebagai migration, agar skema versioned dan dapat direproduksi.

#### Acceptance Criteria
1. THE aplikasi SHALL memiliki migration untuk seluruh 25 tabel pada `database/schema.sql`.
2. THE kolom uang SHALL bertipe integer (BIGINT) rupiah penuh.
3. THE kolom status/type/category SHALL memiliki PHP enum yang sesuai dan di-cast pada model.
4. THE tabel ber-PII (`letter_requests` dan lampiran) SHALL menggunakan soft delete.
5. WHEN migration dijalankan THEN seluruh foreign key terbentuk dengan aksi ON DELETE yang benar.

### R3 — Autentikasi & peran
**User story:** Sebagai admin desa, saya ingin masuk ke panel dengan peran tertentu, agar akses sesuai tanggung jawab.

#### Acceptance Criteria
1. THE sistem SHALL mendukung 4 peran: admin, editor, operator, bendahara.
2. WHEN pengguna login THEN sistem SHALL mengarahkan ke panel admin sesuai peran.
3. IF pengguna nonaktif (`is_active = false`) THEN sistem SHALL menolak login.
4. THE akses tiap modul SHALL dibatasi melalui Policy sesuai peran.

### R4 — Panel admin (Filament)
**User story:** Sebagai operator desa, saya ingin panel admin yang mudah, agar bisa mengelola konten tanpa coding.

#### Acceptance Criteria
1. THE panel SHALL dapat diakses di `/admin` dan memerlukan autentikasi.
2. THE panel SHALL menampilkan dashboard dengan ringkasan (pengajuan surat, kunjungan, realisasi APBDes).
3. WHEN role tidak memiliki izin atas suatu resource THEN resource tersebut SHALL tidak tampil di navigasi.

### R5 — Kerangka halaman publik
**User story:** Sebagai warga, saya ingin mengakses situs publik, agar memperoleh informasi desa.

#### Acceptance Criteria
1. THE rute publik SHALL mengikuti struktur PRD (mis. `/`, `/transparansi/apbdes`, `/berita`, `/layanan`, `/umkm`).
2. THE tampilan publik SHALL responsif (mobile-first) dan memuat dalam ≤ 3 detik pada koneksi 4G.
3. THE setiap halaman SHALL memiliki meta tag & Open Graph yang benar untuk berbagi ke WhatsApp.
4. THE situs SHALL menyediakan halaman 404 yang ramah.
