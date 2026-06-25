---
inclusion: manual
---

# Powers & MCP

**Powers** adalah paket kemampuan Kiro (dokumentasi + steering + opsional MCP server).
Powers dipasang/dikelola lewat panel **Powers** di Kiro, bukan file biasa di repo.

## Power yang dipakai proyek ini
- **GitHub** — alur source control: clone, push branch, buat Pull Request, review PR, kelola issue.
  - Gunakan tool power GitHub (bukan `git push` mentah) untuk push & PR.
  - Selalu push ke branch baru, lalu buka PR ke `main`.

## MCP (Model Context Protocol)
Konfigurasi MCP per-workspace ada di `.kiro/settings/mcp.json`.
Contoh server yang berguna untuk proyek ini (nonaktif secara default — aktifkan sesuai kebutuhan & isi kredensial sendiri):
- Server dokumentasi (mis. context7) untuk referensi API Laravel/Filament terbaru.

### Aturan MCP
- Jangan commit token/kredensial ke repo. Gunakan variabel lingkungan.
- Tambahkan tool baru ke `autoApprove` hanya bila aman & sering dipakai.
- Setelah mengubah `mcp.json`, server akan ter-reconnect otomatis (tidak perlu restart).

Lihat: `.kiro/settings/mcp.json`
