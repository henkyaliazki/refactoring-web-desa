-- =====================================================================
--  Skema Database — Website Desa Jatirokeh
--  DBMS: MySQL 8 (utf8mb4). Referensi untuk migration Laravel 12.
--  Uang: BIGINT (rupiah penuh). Waktu: created_at/updated_at di tiap tabel.
-- =====================================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------
-- 1. AUTENTIKASI & HAK AKSES
-- ---------------------------------------------------------------------
CREATE TABLE roles (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50)  NOT NULL,
    slug        VARCHAR(50)  NOT NULL,
    description VARCHAR(255) NULL,
    created_at  TIMESTAMP NULL,
    updated_at  TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_roles_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE users (
    id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    role_id           BIGINT UNSIGNED NOT NULL,
    name              VARCHAR(120) NOT NULL,
    email             VARCHAR(150) NOT NULL,
    email_verified_at TIMESTAMP NULL,
    password          VARCHAR(255) NOT NULL,
    phone             VARCHAR(20)  NULL,
    avatar            VARCHAR(255) NULL,
    is_active         TINYINT(1)   NOT NULL DEFAULT 1,
    last_login_at     TIMESTAMP NULL,
    remember_token    VARCHAR(100) NULL,
    created_at        TIMESTAMP NULL,
    updated_at        TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_email (email),
    KEY idx_users_role (role_id),
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 2. KONTEN: BERITA & PENGUMUMAN
-- ---------------------------------------------------------------------
CREATE TABLE categories (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name       VARCHAR(80) NOT NULL,
    slug       VARCHAR(80) NOT NULL,
    type       ENUM('berita','pengumuman') NOT NULL DEFAULT 'berita',
    color      VARCHAR(20) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_categories_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE posts (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    category_id BIGINT UNSIGNED NULL,
    user_id     BIGINT UNSIGNED NOT NULL,
    title       VARCHAR(200) NOT NULL,
    slug        VARCHAR(220) NOT NULL,
    excerpt     VARCHAR(300) NULL,
    body        LONGTEXT NOT NULL,
    cover_image VARCHAR(255) NULL,
    type        ENUM('berita','pengumuman') NOT NULL DEFAULT 'berita',
    status      ENUM('draft','published','scheduled','archived') NOT NULL DEFAULT 'draft',
    is_featured TINYINT(1) NOT NULL DEFAULT 0,
    views       INT UNSIGNED NOT NULL DEFAULT 0,
    published_at TIMESTAMP NULL,
    expired_at   TIMESTAMP NULL,
    created_at  TIMESTAMP NULL,
    updated_at  TIMESTAMP NULL,
    deleted_at  TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_posts_slug (slug),
    KEY idx_posts_status_pub (status, published_at),
    KEY idx_posts_type (type),
    KEY idx_posts_category (category_id),
    CONSTRAINT fk_posts_category FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL,
    CONSTRAINT fk_posts_user     FOREIGN KEY (user_id)     REFERENCES users (id)      ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 3. TRANSPARANSI APBDes
-- ---------------------------------------------------------------------
CREATE TABLE budgets (
    id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    year             SMALLINT UNSIGNED NOT NULL,
    status           ENUM('draft','published') NOT NULL DEFAULT 'draft',
    total_pendapatan BIGINT NOT NULL DEFAULT 0,
    total_belanja    BIGINT NOT NULL DEFAULT 0,
    total_pembiayaan BIGINT NOT NULL DEFAULT 0,
    perdes_number    VARCHAR(100) NULL,
    note             TEXT NULL,
    source_note      VARCHAR(255) NULL,   -- mis. "Sumber: APBDes & DJPK Kemenkeu"
    published_at     TIMESTAMP NULL,
    created_at       TIMESTAMP NULL,
    updated_at       TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_budgets_year (year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE budget_items (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    budget_id       BIGINT UNSIGNED NOT NULL,
    parent_id       BIGINT UNSIGNED NULL,
    type            ENUM('pendapatan','belanja','pembiayaan') NOT NULL,
    bidang          ENUM('pemerintahan','pembangunan','pembinaan','pemberdayaan','tak_terduga') NULL,
    code            VARCHAR(30) NULL,
    name            VARCHAR(200) NOT NULL,
    planned_amount  BIGINT NOT NULL DEFAULT 0,
    realized_amount BIGINT NOT NULL DEFAULT 0,
    sort_order      INT UNSIGNED NOT NULL DEFAULT 0,
    created_at      TIMESTAMP NULL,
    updated_at      TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_bitems_budget_type (budget_id, type),
    KEY idx_bitems_parent (parent_id),
    CONSTRAINT fk_bitems_budget FOREIGN KEY (budget_id) REFERENCES budgets (id)      ON DELETE CASCADE,
    CONSTRAINT fk_bitems_parent FOREIGN KEY (parent_id) REFERENCES budget_items (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE documents (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    budget_id   BIGINT UNSIGNED NULL,
    title       VARCHAR(200) NOT NULL,
    type        ENUM('perdes_apbdes','laporan_realisasi','lainnya') NOT NULL DEFAULT 'lainnya',
    file_path   VARCHAR(255) NOT NULL,
    file_size   INT UNSIGNED NULL,
    mime        VARCHAR(100) NULL,
    year        SMALLINT UNSIGNED NULL,
    uploaded_by BIGINT UNSIGNED NULL,
    created_at  TIMESTAMP NULL,
    updated_at  TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_documents_budget (budget_id),
    CONSTRAINT fk_documents_budget FOREIGN KEY (budget_id)   REFERENCES budgets (id) ON DELETE SET NULL,
    CONSTRAINT fk_documents_user   FOREIGN KEY (uploaded_by) REFERENCES users (id)   ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 4. BUKTI KEGIATAN PEMBANGUNAN (before/after)
-- ---------------------------------------------------------------------
CREATE TABLE projects (
    id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    budget_id        BIGINT UNSIGNED NULL,
    budget_item_id   BIGINT UNSIGNED NULL,
    name             VARCHAR(200) NOT NULL,
    slug             VARCHAR(220) NOT NULL,
    location         VARCHAR(150) NULL,
    volume           VARCHAR(100) NULL,            -- mis. "1,2 km x 3 m"
    executor         VARCHAR(120) NULL,            -- TPK / Swakelola
    start_date       DATE NULL,
    end_date         DATE NULL,
    status           ENUM('planned','ongoing','done') NOT NULL DEFAULT 'planned',
    physical_progress TINYINT UNSIGNED NOT NULL DEFAULT 0,  -- 0..100
    planned_cost     BIGINT NOT NULL DEFAULT 0,
    realized_cost    BIGINT NOT NULL DEFAULT 0,
    description      TEXT NULL,
    note             VARCHAR(255) NULL,            -- mis. catatan fisik vs keuangan
    is_published     TINYINT(1) NOT NULL DEFAULT 0,
    created_at       TIMESTAMP NULL,
    updated_at       TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_projects_slug (slug),
    KEY idx_projects_budget (budget_id),
    KEY idx_projects_status (status),
    CONSTRAINT fk_projects_budget FOREIGN KEY (budget_id)      REFERENCES budgets (id)      ON DELETE SET NULL,
    CONSTRAINT fk_projects_bitem  FOREIGN KEY (budget_item_id) REFERENCES budget_items (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_photos (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    project_id BIGINT UNSIGNED NOT NULL,
    type       ENUM('before','after','process') NOT NULL DEFAULT 'process',
    image_path VARCHAR(255) NOT NULL,
    caption    VARCHAR(200) NULL,
    taken_at   DATE NULL,
    sort_order INT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_pphotos_project_type (project_id, type),
    CONSTRAINT fk_pphotos_project FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 5. LAYANAN SURAT ONLINE
-- ---------------------------------------------------------------------
CREATE TABLE letter_types (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name           VARCHAR(120) NOT NULL,
    slug           VARCHAR(120) NOT NULL,
    description    VARCHAR(255) NULL,
    estimated_days TINYINT UNSIGNED NOT NULL DEFAULT 1,
    requirements   JSON NULL,                 -- ["Scan KTP","Scan KK", ...]
    template       LONGTEXT NULL,             -- template isi surat (opsional)
    is_active      TINYINT(1) NOT NULL DEFAULT 1,
    sort_order     INT UNSIGNED NOT NULL DEFAULT 0,
    created_at     TIMESTAMP NULL,
    updated_at     TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_letter_types_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE letter_requests (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    code           VARCHAR(20)  NOT NULL,     -- JTR-2026-0142
    letter_type_id BIGINT UNSIGNED NOT NULL,
    assigned_to    BIGINT UNSIGNED NULL,      -- operator yang menangani
    applicant_name VARCHAR(120) NOT NULL,
    nik            VARCHAR(16)  NOT NULL,
    birth_place    VARCHAR(100) NULL,
    birth_date     DATE NULL,
    address_rt     VARCHAR(5)   NULL,
    address_rw     VARCHAR(5)   NULL,
    dukuh          VARCHAR(100) NULL,
    phone          VARCHAR(20)  NOT NULL,
    purpose        VARCHAR(255) NOT NULL,
    status         ENUM('new','verifying','processing','signed','ready','done','rejected') NOT NULL DEFAULT 'new',
    reject_reason  VARCHAR(255) NULL,
    notify_whatsapp TINYINT(1) NOT NULL DEFAULT 1,
    completed_at   TIMESTAMP NULL,
    created_at     TIMESTAMP NULL,
    updated_at     TIMESTAMP NULL,
    deleted_at     TIMESTAMP NULL,            -- soft delete (PII)
    PRIMARY KEY (id),
    UNIQUE KEY uq_lreq_code (code),
    KEY idx_lreq_status (status),
    KEY idx_lreq_type (letter_type_id),
    CONSTRAINT fk_lreq_type     FOREIGN KEY (letter_type_id) REFERENCES letter_types (id) ON DELETE RESTRICT,
    CONSTRAINT fk_lreq_assigned FOREIGN KEY (assigned_to)    REFERENCES users (id)        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE letter_request_attachments (
    id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    letter_request_id BIGINT UNSIGNED NOT NULL,
    kind              ENUM('ktp','kk','lainnya') NOT NULL DEFAULT 'lainnya',
    file_path         VARCHAR(255) NOT NULL,
    mime              VARCHAR(100) NULL,
    file_size         INT UNSIGNED NULL,
    created_at        TIMESTAMP NULL,
    updated_at        TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_lattach_request (letter_request_id),
    CONSTRAINT fk_lattach_request FOREIGN KEY (letter_request_id) REFERENCES letter_requests (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE letter_request_logs (
    id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    letter_request_id BIGINT UNSIGNED NOT NULL,
    changed_by        BIGINT UNSIGNED NULL,
    from_status       VARCHAR(20) NULL,
    to_status         VARCHAR(20) NOT NULL,
    note              VARCHAR(255) NULL,
    notified_at       TIMESTAMP NULL,          -- kapan notif WA dikirim
    created_at        TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_llog_request (letter_request_id),
    CONSTRAINT fk_llog_request FOREIGN KEY (letter_request_id) REFERENCES letter_requests (id) ON DELETE CASCADE,
    CONSTRAINT fk_llog_user    FOREIGN KEY (changed_by)        REFERENCES users (id)           ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 6. STATISTIK KEPENDUDUKAN (agregat, tanpa data individu)
-- ---------------------------------------------------------------------
CREATE TABLE population_snapshots (
    id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    snapshot_date    DATE NOT NULL,
    total_population INT UNSIGNED NOT NULL DEFAULT 0,
    total_families   INT UNSIGNED NOT NULL DEFAULT 0,
    total_rt         SMALLINT UNSIGNED NULL,
    total_rw         SMALLINT UNSIGNED NULL,
    area_ha          INT UNSIGNED NULL,
    note             VARCHAR(255) NULL,
    created_at       TIMESTAMP NULL,
    updated_at       TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_popsnap_date (snapshot_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE population_breakdowns (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    snapshot_id BIGINT UNSIGNED NOT NULL,
    dimension   ENUM('gender','age_group','religion','education','occupation') NOT NULL,
    label       VARCHAR(80) NOT NULL,        -- "Laki-laki", "0-5 thn", "Islam", ...
    value       INT UNSIGNED NOT NULL DEFAULT 0,
    sort_order  INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_popbreak_snap_dim (snapshot_id, dimension),
    CONSTRAINT fk_popbreak_snap FOREIGN KEY (snapshot_id) REFERENCES population_snapshots (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 7. PROFIL & PEMERINTAHAN
-- ---------------------------------------------------------------------
CREATE TABLE officials (
    id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name         VARCHAR(120) NOT NULL,
    position     VARCHAR(120) NOT NULL,
    level        ENUM('kades','sekdes','kaur','kasi','kadus','staf') NOT NULL DEFAULT 'staf',
    photo        VARCHAR(255) NULL,
    period_start YEAR NULL,
    period_end   YEAR NULL,
    sort_order   INT UNSIGNED NOT NULL DEFAULT 0,
    is_active    TINYINT(1) NOT NULL DEFAULT 1,
    created_at   TIMESTAMP NULL,
    updated_at   TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_officials_active (is_active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE village_boundaries (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    direction  ENUM('utara','selatan','timur','barat') NOT NULL,
    name       VARCHAR(150) NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_boundary_direction (direction)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE institutions (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name        VARCHAR(150) NOT NULL,
    description TEXT NULL,
    logo        VARCHAR(255) NULL,
    sort_order  INT UNSIGNED NOT NULL DEFAULT 0,
    created_at  TIMESTAMP NULL,
    updated_at  TIMESTAMP NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 8. POTENSI DESA
-- ---------------------------------------------------------------------
CREATE TABLE potentials (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    sector      ENUM('pertanian','perdagangan','pendidikan','wisata') NOT NULL,
    title       VARCHAR(150) NOT NULL,
    slug        VARCHAR(170) NOT NULL,
    description TEXT NULL,
    stats       JSON NULL,                   -- {"lahan_ha":210,"panen_per_tahun":2}
    image       VARCHAR(255) NULL,
    sort_order  INT UNSIGNED NOT NULL DEFAULT 0,
    is_published TINYINT(1) NOT NULL DEFAULT 1,
    created_at  TIMESTAMP NULL,
    updated_at  TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_potentials_slug (slug),
    KEY idx_potentials_sector (sector)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 9. GALERI
-- ---------------------------------------------------------------------
CREATE TABLE galleries (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    title       VARCHAR(150) NOT NULL,
    description TEXT NULL,
    category    VARCHAR(80) NULL,
    event_date  DATE NULL,
    cover_image VARCHAR(255) NULL,
    created_at  TIMESTAMP NULL,
    updated_at  TIMESTAMP NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE gallery_photos (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    gallery_id BIGINT UNSIGNED NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    caption    VARCHAR(200) NULL,
    sort_order INT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_gphotos_gallery (gallery_id),
    CONSTRAINT fk_gphotos_gallery FOREIGN KEY (gallery_id) REFERENCES galleries (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 10. ASPIRASI / PENGADUAN (termasuk "Lapor jika tidak sesuai")
-- ---------------------------------------------------------------------
CREATE TABLE aspirations (
    id                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    related_project_id BIGINT UNSIGNED NULL,
    category           ENUM('pertanyaan','saran','aduan','kerjasama','lapor_kegiatan') NOT NULL DEFAULT 'pertanyaan',
    name               VARCHAR(120) NOT NULL,
    phone              VARCHAR(20) NULL,
    email              VARCHAR(150) NULL,
    subject            VARCHAR(200) NULL,
    message            TEXT NOT NULL,
    status             ENUM('new','read','responded','closed') NOT NULL DEFAULT 'new',
    response           TEXT NULL,
    responded_by       BIGINT UNSIGNED NULL,
    responded_at       TIMESTAMP NULL,
    created_at         TIMESTAMP NULL,
    updated_at         TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_aspirations_status (status),
    KEY idx_aspirations_project (related_project_id),
    CONSTRAINT fk_aspirations_project FOREIGN KEY (related_project_id) REFERENCES projects (id) ON DELETE SET NULL,
    CONSTRAINT fk_aspirations_user    FOREIGN KEY (responded_by)       REFERENCES users (id)    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 11. KONFIGURASI SITUS
-- ---------------------------------------------------------------------
CREATE TABLE settings (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `key`      VARCHAR(100) NOT NULL,        -- site.phone, site.hero_image, ...
    value      TEXT NULL,
    `group`    VARCHAR(50) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_settings_key (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 12. UMKM / DIREKTORI USAHA LOKAL (kuliner, kerajinan, dll)
-- ---------------------------------------------------------------------
CREATE TABLE businesses (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    category        ENUM('kuliner','kerajinan','pertanian','jasa','perdagangan','lainnya') NOT NULL DEFAULT 'kuliner',
    name            VARCHAR(150) NOT NULL,
    slug            VARCHAR(170) NOT NULL,
    owner_name      VARCHAR(120) NULL,
    description     TEXT NULL,
    logo            VARCHAR(255) NULL,
    cover_image     VARCHAR(255) NULL,
    address         VARCHAR(255) NULL,        -- RT/RW, Dukuh
    phone           VARCHAR(20)  NULL,
    whatsapp        VARCHAR(20)  NULL,
    maps_url        VARCHAR(255) NULL,
    latitude        DECIMAL(10,7) NULL,
    longitude       DECIMAL(10,7) NULL,
    price_range     VARCHAR(50)  NULL,        -- mis. "Rp5rb - Rp25rb"
    operating_hours VARCHAR(100) NULL,        -- mis. "Setiap hari 08.00-21.00"
    is_featured     TINYINT(1) NOT NULL DEFAULT 0,
    is_published    TINYINT(1) NOT NULL DEFAULT 1,
    sort_order      INT UNSIGNED NOT NULL DEFAULT 0,
    created_at      TIMESTAMP NULL,
    updated_at      TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_businesses_slug (slug),
    KEY idx_businesses_category (category, is_published)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE business_products (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id BIGINT UNSIGNED NOT NULL,
    name        VARCHAR(150) NOT NULL,       -- nama menu/produk
    price       BIGINT NULL,                 -- rupiah penuh (NULL = tanpa harga)
    photo       VARCHAR(255) NULL,
    description VARCHAR(255) NULL,
    is_available TINYINT(1) NOT NULL DEFAULT 1,
    sort_order  INT UNSIGNED NOT NULL DEFAULT 0,
    created_at  TIMESTAMP NULL,
    updated_at  TIMESTAMP NULL,
    PRIMARY KEY (id),
    KEY idx_bproducts_business (business_id),
    CONSTRAINT fk_bproducts_business FOREIGN KEY (business_id) REFERENCES businesses (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================================
-- DATA AWAL (seed) — contoh nilai
-- =====================================================================
INSERT INTO roles (name, slug, description, created_at, updated_at) VALUES
 ('Admin Utama', 'admin',     'Akses penuh ke seluruh modul', NOW(), NOW()),
 ('Editor',      'editor',    'Kelola berita, pengumuman, galeri', NOW(), NOW()),
 ('Operator',    'operator',  'Proses pengajuan surat warga', NOW(), NOW()),
 ('Bendahara',   'bendahara', 'Kelola data APBDes & realisasi', NOW(), NOW());

INSERT INTO village_boundaries (direction, name, created_at, updated_at) VALUES
 ('utara',   'Desa Karangsembung',        NOW(), NOW()),
 ('selatan', 'Desa Jatimakmur',           NOW(), NOW()),
 ('barat',   'Desa Wanatawang & Cenang',  NOW(), NOW()),
 ('timur',   'Kabupaten Tegal',           NOW(), NOW());
