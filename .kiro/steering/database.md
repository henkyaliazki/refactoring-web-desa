---
inclusion: manual
---

# Acuan Database

Sumber kebenaran skema ada di dua file (selalu jaga keduanya sinkron):
- Dokumentasi & ERD: `docs/DATABASE.md`
- DDL MySQL: `database/schema.sql`

## Aturan saat mengubah skema
1. Perbarui **migration** Laravel (sumber kebenaran untuk aplikasi).
2. Sinkronkan **`database/schema.sql`** dan **`docs/DATABASE.md`** (termasuk diagram ERD).
3. Tambah/ubah **factory** & **seeder** terkait.
4. Validasi DDL bila diubah manual (parser MySQL).

## Prinsip
- Uang: `BIGINT` rupiah penuh.
- Kolom `status`/`type`/`category`: `ENUM` di SQL, PHP `enum` di model.
- Foreign key eksplisit dengan aksi `ON DELETE` yang sesuai (`CASCADE` untuk child, `SET NULL`/`RESTRICT` untuk referensi).
- Data agregat kependudukan saja — tidak ada tabel data per individu.
- Tabel ber-PII (`letter_requests`, lampiran) wajib soft delete.

#[[file:docs/DATABASE.md]]
#[[file:database/schema.sql]]
