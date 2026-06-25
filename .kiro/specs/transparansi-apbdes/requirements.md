# Requirements — Transparansi APBDes

## Pengantar
Fitur inti proyek: mempublikasikan APBDes secara terbuka dan **dapat diverifikasi** warga,
mencakup ringkasan anggaran, visualisasi, realisasi per bidang, bukti kegiatan (foto before/after,
progres fisik vs keuangan), unduh dokumen resmi, dan pelaporan ketidaksesuaian. Dibangun di atas
spec `laravel-foundation`.

## Requirements

### R1 — Publikasi APBDes per tahun
**User story:** Sebagai warga/perantau, saya ingin melihat APBDes per tahun anggaran, agar dapat mengetahui pendapatan dan belanja desa.

#### Acceptance Criteria
1. WHEN warga membuka `/transparansi/apbdes` THEN sistem SHALL menampilkan APBDes tahun terbaru berstatus `published`.
2. THE halaman SHALL menyediakan pemilih tahun untuk melihat arsip tahun sebelumnya.
3. IF sebuah budget berstatus `draft` THEN sistem SHALL TIDAK menampilkannya ke publik.
4. THE ringkasan SHALL menampilkan total pendapatan, belanja, dan pembiayaan.

### R2 — Visualisasi anggaran
**User story:** Sebagai warga awam, saya ingin melihat anggaran dalam grafik, agar mudah dipahami tanpa membaca tabel rumit.

#### Acceptance Criteria
1. THE halaman SHALL menampilkan grafik komposisi sumber pendapatan.
2. THE halaman SHALL menampilkan grafik belanja per bidang (anggaran vs realisasi).
3. THE halaman SHALL menampilkan progress bar realisasi per bidang dengan persentase.

### R3 — Bukti kegiatan (before/after)
**User story:** Sebagai warga, saya ingin melihat bukti fisik pembangunan, agar dapat memverifikasi penggunaan anggaran.

#### Acceptance Criteria
1. THE tiap kegiatan SHALL dapat menampilkan foto sebelum dan sesudah dalam pembanding geser (slider).
2. THE tiap kegiatan SHALL menampilkan progres fisik DAN realisasi keuangan secara terpisah.
3. IF progres fisik berbeda signifikan dari realisasi keuangan THEN sistem SHALL menampilkan catatan penjelasan.
4. THE kegiatan SHALL menampilkan volume, lokasi, pelaksana, dan rentang tanggal.

### R4 — Dokumen resmi
**User story:** Sebagai warga, saya ingin mengunduh dokumen resmi, agar memperoleh sumber primer.

#### Acceptance Criteria
1. THE halaman SHALL menyediakan unduhan Perdes APBDes dan laporan realisasi (PDF).
2. THE setiap data SHALL mencantumkan sumber data dan tanggal pembaruan.

### R5 — Pelaporan ketidaksesuaian
**User story:** Sebagai warga, saya ingin melaporkan jika sebuah kegiatan tidak sesuai, agar pengawasan berjalan.

#### Acceptance Criteria
1. WHEN warga menekan "Lapor jika tidak sesuai" pada sebuah kegiatan THEN sistem SHALL membuka form aspirasi yang tertaut ke kegiatan tersebut (`related_project_id`).
2. WHEN laporan dikirim THEN sistem SHALL menyimpannya berstatus `new` untuk ditindaklanjuti admin.

### R6 — Pengelolaan oleh admin
**User story:** Sebagai bendahara desa, saya ingin menginput anggaran/realisasi dan mengunggah foto kegiatan, agar data publik selalu mutakhir.

#### Acceptance Criteria
1. THE bendahara/admin SHALL dapat membuat & menyunting budget, budget item, dan kegiatan via Filament.
2. WHEN admin mengunggah foto before/after THEN sistem SHALL menampilkannya di halaman publik setelah kegiatan `is_published`.
3. THE perubahan nilai realisasi SHALL tercatat di audit log.
