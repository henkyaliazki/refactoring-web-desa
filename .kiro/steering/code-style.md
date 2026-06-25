---
inclusion: fileMatch
fileMatchPattern: '**/*.php'
---

# Standar Kode PHP / Laravel

## Format
- Patuhi **PSR-12**. Format wajib dengan **Laravel Pint** sebelum commit: `./vendor/bin/pint`.
- Indentasi 4 spasi, kurung kurawal kelas/metode di baris baru sesuai Pint default Laravel.

## Praktik Laravel
- Gunakan **type hint** & **return type** di semua metode.
- Gunakan **Eloquent** dan relasi, hindari query mentah kecuali perlu performa.
- Selalu cegah N+1 query dengan eager loading (`with()`).
- **Mass assignment**: definisikan `$fillable` (jangan `$guarded = []`).
- **Enum cast**: kolom status/type/category pakai PHP enum + `protected function casts()`.
- **Uang**: integer rupiah penuh; format ke tampilan via accessor/helper, jangan simpan sebagai float.
- **Otorisasi**: gunakan Policy untuk akses data; jangan cek role manual tersebar.

## Keamanan (wajib)
- Validasi semua input via **Form Request**.
- Jangan pernah menonaktifkan proteksi CSRF.
- Escape output Blade (`{{ }}`); pakai `{!! !!}` hanya untuk konten yang sudah disanitasi.
- Batasi upload: tipe MIME & ukuran file (KTP/KK maks 2 MB).
- Rate-limit endpoint publik (pengajuan surat, form kontak).

## Komentar & bahasa
- Komentar dan pesan validasi untuk pengguna akhir: **Bahasa Indonesia**.
- Nama variabel/metode/kelas: **Bahasa Inggris** (konvensi Laravel).
