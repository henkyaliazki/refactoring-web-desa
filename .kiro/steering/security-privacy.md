---
inclusion: fileMatch
fileMatchPattern: '**/*{Letter,letter,Aspiration,aspiration,User,user,Auth,auth}*'
---

# Keamanan & Privasi Data (UU PDP)

Berlaku khusus untuk kode yang menyentuh data pribadi: pengajuan surat (NIK, KK, KTP),
aspirasi/aduan warga, dan akun pengguna.

## Wajib
- **Minimalkan data**: kumpulkan hanya yang diperlukan untuk memproses surat.
- **Akses dibatasi**: data pemohon hanya untuk role `operator` & `admin` (gunakan Policy).
- **Soft delete + retensi**: `letter_requests` & lampiran menggunakan soft delete; terapkan kebijakan hapus permanen setelah masa retensi.
- **Lampiran (KTP/KK)** disimpan di disk privat (bukan `public`), diakses via route terautentikasi.
- **Masking** NIK/telepon di daftar admin bila tidak sedang diproses.
- **Audit**: catat perubahan status & akses data sensitif (spatie/activitylog).
- **Notifikasi WhatsApp**: kirim via queue; jangan log isi pesan yang memuat PII.

## Larangan
- Jangan menaruh file lampiran di `storage/app/public` atau folder yang bisa diakses langsung.
- Jangan menampilkan NIK lengkap di halaman publik atau di log.
- Jangan mengekspor data warga tanpa kontrol akses & pencatatan.
