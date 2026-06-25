---
inclusion: always
---

# Alur Git & Kontribusi

## Branch
- Jangan commit langsung ke `main`. Buat branch dari `main`:
  - `feat/<ringkas>` — fitur baru
  - `fix/<ringkas>` — perbaikan bug
  - `chore/<ringkas>` — perawatan/non-fungsional
  - `docs/<ringkas>` — dokumentasi

## Commit (Conventional Commits)
Format: `<tipe>: <ringkasan singkat dalam bahasa Indonesia/Inggris konsisten>`
- Tipe: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`.
- Contoh: `feat: tambah modul pengajuan surat domisili`
- Commit kecil & fokus; satu perubahan logis per commit.

## Sebelum membuka Pull Request
1. `./vendor/bin/pint` (format)
2. `./vendor/bin/pest` (test hijau)
3. `php artisan migrate:fresh --seed` berjalan tanpa error
4. Perbarui `docs/DATABASE.md` bila skema berubah

## Pull Request
- Judul ringkas (< 70 karakter), deskripsi berisi: ringkasan, apa yang diuji, keterbatasan.
- Kaitkan issue terkait bila ada.
- Minimal 1 review sebelum merge ke `main`.

## Larangan
- Tidak ada force-push ke `main`.
- Tidak commit file `.env`, kredensial, atau data pribadi warga.
- Tidak melewati git hook (`--no-verify`) tanpa alasan kuat.
