# Tasks — Transparansi APBDes

> Prasyarat: spec `laravel-foundation` selesai (migration, model, Filament, kerangka publik).

- [ ] 1. Scope & query model
  - Scope `Budget::published()`, `Project::published()`
  - Relasi: Budget→items, Budget→projects→photos, Budget→documents
  - _Requirements: R1.1, R1.3_

- [ ] 2. Perhitungan realisasi
  - Service/accessor: total per type, persentase realisasi per bidang, deteksi selisih fisik/keuangan
  - Unit test perhitungan
  - _Requirements: R2.3, R3.2, R3.3_

- [ ] 3. Halaman publik APBDes
  - [ ] 3.1 Controller + rute `/transparansi/apbdes` dengan pemilih tahun
  - [ ] 3.2 Kartu ringkasan (pendapatan/belanja/pembiayaan)
  - [ ] 3.3 Chart komposisi pendapatan & belanja per bidang (Chart.js)
  - [ ] 3.4 Progress bar realisasi per bidang
  - _Requirements: R1, R2_

- [ ] 4. Komponen bukti kegiatan
  - [ ] 4.1 Blade `x-before-after` (slider Alpine)
  - [ ] 4.2 Kartu kegiatan: progres fisik vs keuangan + catatan selisih + meta (volume/lokasi/pelaksana)
  - _Requirements: R3_

- [ ] 5. Dokumen & sumber data
  - Daftar unduhan PDF + label sumber & tanggal pembaruan
  - _Requirements: R4_

- [ ] 6. Pelaporan ketidaksesuaian
  - Tautkan tombol "Lapor jika tidak sesuai" ke form aspirasi dengan `related_project_id`
  - Simpan aspirasi berstatus `new`
  - Feature test: laporan tersimpan & tertaut project
  - _Requirements: R5_

- [ ] 7. Pengelolaan admin (Filament)
  - [ ] 7.1 `BudgetResource` + relation manager `BudgetItem`
  - [ ] 7.2 `ProjectResource` + relation manager `ProjectPhoto` (upload before/after)
  - [ ] 7.3 Aktifkan audit log perubahan realisasi
  - _Requirements: R6_

- [ ] 8. Kinerja & verifikasi akhir
  - Cache agregasi per tahun + invalidasi saat simpan
  - Feature test: budget draft tidak tampil publik
  - `./vendor/bin/pint` & `./vendor/bin/pest` hijau
  - _Requirements: R1.3, R2_
