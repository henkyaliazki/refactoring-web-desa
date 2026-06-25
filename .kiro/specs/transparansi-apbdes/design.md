# Design — Transparansi APBDes

## Gambaran
Halaman publik membaca data dari `budgets`, `budget_items`, `projects`, `project_photos`, dan
`documents`. Admin mengelola lewat Filament. Pelaporan warga menulis ke `aspirations`.

## Komponen
- **Controller** `TransparansiController@apbdes` — memuat budget published (tahun terpilih) + relasi.
- **Livewire** `ApbdesViewer` — pemilih tahun & render chart tanpa reload penuh.
- **Blade component** `x-before-after` — slider pembanding (Alpine: state `pos`, clip-path).
- **Filament** `BudgetResource`, `ProjectResource` (+ relation manager `ProjectPhoto`).

## Aliran data (publik)
```
/transparansi/apbdes?tahun=2025
  └─ Budget::published()->year(2025)->with(items, projects.photos, documents)
       ├─ ringkasan total → kartu
       ├─ items(type=pendapatan) → chart komposisi
       ├─ items(type=belanja) grouped bidang → chart + progress
       ├─ projects(is_published) → kartu before/after
       └─ documents → daftar unduhan
```

## Perhitungan
- Persentase realisasi bidang = `SUM(realized_amount) / SUM(planned_amount) * 100`, dibulatkan.
- Total realisasi = agregasi `budget_items` per type.
- Selisih fisik vs keuangan kegiatan = `physical_progress` vs `realized_cost/planned_cost`;
  bila selisih > ambang (mis. 10 poin) tampilkan `note`.

## Keamanan & kinerja
- Hanya budget `published` & project `is_published` yang diekspos publik (query scope).
- Dokumen PDF resmi boleh publik; tidak ada PII pada modul ini.
- Cache hasil agregasi per tahun (mis. 1 jam) untuk kecepatan; invalidasi saat admin menyimpan.

## Pengujian
- Unit: perhitungan persentase realisasi & deteksi selisih fisik/keuangan.
- Feature: budget draft tidak tampil publik; pemilih tahun; submit "lapor tidak sesuai" membuat aspirasi tertaut project.
