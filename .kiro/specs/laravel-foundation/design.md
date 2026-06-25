# Design — Fondasi Aplikasi Laravel

## Arsitektur
Aplikasi monolitik Laravel 12 dengan dua sisi yang terpisah jelas:
- **Publik** — Blade + Livewire untuk interaktivitas (form surat, cek status, chart). Dilayani via `routes/web.php`.
- **Admin** — Filament 3 panel di `/admin`, otorisasi berbasis Policy + peran.

```
Pengunjung ──▶ Route web ──▶ Controller/Livewire ──▶ Service ──▶ Model ──▶ DB
Operator   ──▶ /admin (Filament) ──▶ Resource ──▶ Model ──▶ DB
Notifikasi ──▶ Queue Job ──▶ WhatsApp gateway
```

## Keputusan desain
| Topik | Keputusan | Alasan |
|---|---|---|
| Peran | Tabel `roles` + `users.role_id`; opsi upgrade ke `spatie/permission` | Sederhana dulu, fleksibel nanti |
| Uang | Integer rupiah penuh + accessor format | Hindari galat float |
| Status | PHP enum + cast | Tipe aman, mudah dirender |
| Media | Kolom `*_path` (disk privat untuk PII) | Kontrol akses |
| Notifikasi | Queue job (bukan sinkron) | Tahan gagal, tidak blokir request |
| Audit | spatie/activitylog | Akuntabilitas |

## Model & relasi inti
Mengacu penuh pada `docs/DATABASE.md`. Model utama fondasi: `Role`, `User`, `Category`, `Post`,
`Budget`, `BudgetItem`, `Project`, `ProjectPhoto`, `Document`, `LetterType`, `LetterRequest`,
`LetterRequestAttachment`, `LetterRequestLog`, `Business`, `BusinessProduct`, dll.

## Enum
- `LetterStatus`: new, verifying, processing, signed, ready, done, rejected
- `ProjectStatus`: planned, ongoing, done
- `PostStatus`: draft, published, scheduled, archived
- `BudgetItemType`: pendapatan, belanja, pembiayaan
- `BusinessCategory`: kuliner, kerajinan, pertanian, jasa, perdagangan, lainnya

## Otorisasi (matriks ringkas)
| Modul | admin | editor | operator | bendahara |
|---|---|---|---|---|
| Berita/Galeri | ✔ | ✔ | — | — |
| APBDes/Kegiatan | ✔ | — | — | ✔ |
| Layanan Surat | ✔ | — | ✔ | — |
| Pengguna/Setting | ✔ | — | — | — |

## Halaman publik (Blade)
Terjemahan dari prototipe statis (`index.html`, dst.) menjadi layout Blade + komponen reusable
(`x-navbar`, `x-footer`, `x-news-card`, `x-before-after`). Chart.js untuk visualisasi APBDes & dashboard.

## Strategi pengujian
- Unit: enum, perhitungan realisasi, generator kode surat.
- Feature: login & otorisasi peran, akses resource Filament, alur form publik.
- Lihat steering `testing.md`.

## Penanganan error
- 404 ramah dengan navigasi kembali.
- Form publik: validasi via Form Request, pesan kesalahan Bahasa Indonesia.
- Rate limiting pada endpoint pengajuan & kontak.
