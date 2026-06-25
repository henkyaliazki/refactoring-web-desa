---
inclusion: fileMatch
fileMatchPattern: 'tests/**/*.php'
---

# Standar Pengujian

Framework: **Pest** (di atas PHPUnit). Database test: SQLite in-memory.

## Apa yang wajib diuji
- **Layanan surat**: alur pengajuan, transisi status (`new → ... → done`/`rejected`), pembuatan kode unik, kebijakan akses operator.
- **APBDes**: perhitungan total & persentase realisasi, hanya budget berstatus `published` yang tampil publik.
- **Otorisasi**: tiap role hanya mengakses modul yang diizinkan.
- **Form publik**: validasi pengajuan surat & form aspirasi (input wajib, batas ukuran file).

## Konvensi
- Feature test untuk alur HTTP & Filament; Unit test untuk Service/Enum/perhitungan.
- Gunakan **factory** untuk data uji, jangan hardcode.
- Satu perilaku per test; nama deskriptif: `it('menolak pengajuan tanpa lampiran KTP')`.
- Jalankan sekali (bukan watch): `./vendor/bin/pest`.

## Jangan
- Jangan menulis test yang bergantung pada data produksi atau urutan eksekusi.
- Jangan menambah test otomatis tanpa diminta jika di luar lingkup tugas.
