---
inclusion: always
---

# Struktur Proyek & Konvensi

## Tata letak (target setelah scaffold Laravel)
```
app/
  Models/                 # Eloquent model (Budget, Project, LetterRequest, ...)
  Filament/
    Resources/            # CRUD admin per model
    Widgets/              # widget dashboard (statistik, chart)
    Pages/                # halaman admin kustom
  Http/
    Controllers/          # controller sisi publik
    Requests/             # Form Request (validasi)
  Livewire/               # komponen interaktif publik (form surat, cek status)
  Services/               # logika domain (mis. LetterRequestService, WhatsAppNotifier)
  Enums/                  # enum status (LetterStatus, ProjectStatus, ...)
resources/
  views/
    public/               # halaman publik (Blade) — terjemahan dari /mockup
    components/           # komponen Blade reusable (navbar, footer, card)
  css/ js/
routes/
  web.php                 # rute publik
database/
  migrations/             # turunan dari database/schema.sql
  seeders/
  factories/
tests/
  Feature/ Unit/
docs/                     # dokumentasi (DATABASE.md, dll.)
```

## Konvensi penamaan
- **Model**: singular PascalCase (`LetterRequest`). **Tabel**: plural snake_case (`letter_requests`).
- **Rute publik**: bahasa Indonesia sesuai PRD (`/transparansi/apbdes`, `/layanan/ajukan/{type}`, `/umkm/kuliner`).
- **Enum**: gunakan PHP enum + cast di model untuk semua kolom `status`/`type`/`category`.
- **Komponen Blade publik**: prefiks `x-` (mis. `<x-news-card>`).
- **Filament Resource**: satu resource per model utama.

## Aturan organisasi kode
- Logika bisnis non-trivial → `app/Services`, bukan di controller atau model.
- Validasi input → `Http/Requests`, jangan inline di controller.
- Query berulang → scope Eloquent atau repository sederhana.
- Sisi publik (Blade/Livewire) terpisah dari sisi admin (Filament).
- Acuan struktur data: lihat `docs/DATABASE.md` dan `database/schema.sql`.

#[[file:docs/DATABASE.md]]
