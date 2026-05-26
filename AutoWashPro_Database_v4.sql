-- ============================================================
--  AutoWash Pro  –  Database Schema  v4.0
--  SQL Server (T-SQL)
--  Thay đổi so với v3.0:
--    + Gộp bảng admins + customers thành 1 bảng users (Cách C)
--      users: id, login_id, password_hash, role, full_name, email
--      → 1 bảng lo hết mọi thứ: login, phân quyền, profile
--      → Login chỉ cần query 1 bảng, không JOIN, không 2 lần query
--      → Tạo JWT { user_id, role } đơn giản, nhanh
-- ============================================================
--  Constraints: PK · FK · UNIQUE only
--  Business validation → handled by application layer (BE)
-- ============================================================
--  12 Tables:
--   01. tiers                – Loyalty tier definitions
--   02. users                – Tất cả tài khoản: admin + customer (⭐ mới)
--   03. vehicles             – Registered vehicles (LPR key: plate)
--   04. loyalty_accounts     – 1:1 points wallet per customer
--   05. point_logs           – Points ledger / audit trail
--   06. services             – Wash service catalog
--   07. bookings             – Advance bookings (tier-priority)
--   08. wash_sessions        – Actual wash execution records
--   09. rewards              – Redeemable reward catalog
--   10. redemptions          – Point redemption events
--   11. promotions           – Targeted promotional campaigns
--   12. promotion_services   – Junction: promotions ↔ services
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'AutoWashPro')
    CREATE DATABASE AutoWashPro;
GO

USE AutoWashPro;
GO

-- ── Drop in reverse FK order (safe re-run) ──────────────────
IF OBJECT_ID('promotion_services','U') IS NOT NULL DROP TABLE promotion_services;
IF OBJECT_ID('promotions',        'U') IS NOT NULL DROP TABLE promotions;
IF OBJECT_ID('redemptions',       'U') IS NOT NULL DROP TABLE redemptions;
IF OBJECT_ID('rewards',           'U') IS NOT NULL DROP TABLE rewards;
IF OBJECT_ID('wash_sessions',     'U') IS NOT NULL DROP TABLE wash_sessions;
IF OBJECT_ID('point_logs',        'U') IS NOT NULL DROP TABLE point_logs;
IF OBJECT_ID('bookings',          'U') IS NOT NULL DROP TABLE bookings;
IF OBJECT_ID('loyalty_accounts',  'U') IS NOT NULL DROP TABLE loyalty_accounts;
IF OBJECT_ID('vehicles',          'U') IS NOT NULL DROP TABLE vehicles;
IF OBJECT_ID('services',          'U') IS NOT NULL DROP TABLE services;
IF OBJECT_ID('users',             'U') IS NOT NULL DROP TABLE users;
IF OBJECT_ID('tiers',             'U') IS NOT NULL DROP TABLE tiers;
GO

-- ============================================================
-- 01. tiers
-- ============================================================
CREATE TABLE tiers (
    id           INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name         NVARCHAR(20)   NOT NULL UNIQUE,
    min_washes   INT            NOT NULL DEFAULT 0,
    min_spend    DECIMAL(18,0)  NOT NULL DEFAULT 0,
    point_rate   DECIMAL(3,2)   NOT NULL DEFAULT 1.00,
    book_days    INT            NOT NULL DEFAULT 7,
    free_upgrade BIT            NOT NULL DEFAULT 0,
    free_wash    BIT            NOT NULL DEFAULT 0,
    priority     INT            NOT NULL DEFAULT 1
);
GO

-- ============================================================
-- 02. users  ⭐ (gộp admins + customers)
--
--  role:
--    SUPER_ADMIN | MANAGER | STAFF  → truy cập /api/admin/**
--    CUSTOMER                       → truy cập /api/customer/**
--
--  login_id:
--    Với CUSTOMER  → số điện thoại  (VD: "0901234567")
--    Với admin     → username       (VD: "superadmin")
--
--  email:
--    Với CUSTOMER  → email nhận hóa đơn (NULL được phép)
--    Với admin     → không dùng (NULL)
--
--  Luồng login (POST /api/auth/login):
--    1. Query users theo login_id → lấy role + full_name + email trong 1 query
--    2. Verify password_hash
--    3. Tạo JWT { user_id, role } → xong
-- ============================================================
CREATE TABLE users (
    id            INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    login_id      NVARCHAR(100)  NOT NULL UNIQUE,   -- phone hoặc username
    password_hash NVARCHAR(255)  NOT NULL,
    role          NVARCHAR(20)   NOT NULL DEFAULT 'CUSTOMER',
    full_name     NVARCHAR(100)  NOT NULL,
    email         NVARCHAR(100)  NULL     UNIQUE,
    is_active     BIT            NOT NULL DEFAULT 1,
    created_at    DATETIME2      NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- 03. vehicles
--     plate = LPR recognition key (camera nhận diện < 10s)
-- ============================================================
CREATE TABLE vehicles (
    id          INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_id     INT            NOT NULL,
    plate       NVARCHAR(20)   NOT NULL UNIQUE,
    type        NVARCHAR(20)   NULL,
    brand       NVARCHAR(50)   NULL,
    model       NVARCHAR(50)   NULL,
    color       NVARCHAR(30)   NULL,
    is_primary  BIT            NOT NULL DEFAULT 0,
    created_at  DATETIME2      NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES users(id)
);
GO

-- ============================================================
-- 04. loyalty_accounts
--     1:1 với users có role = CUSTOMER (UNIQUE trên user_id)
--     total_spend + total_washes → xét nâng/hạ bậc
-- ============================================================
CREATE TABLE loyalty_accounts (
    id             INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_id        INT            NOT NULL UNIQUE,
    tier_id        INT            NOT NULL,
    points         INT            NOT NULL DEFAULT 0,
    total_points   INT            NOT NULL DEFAULT 0,
    total_spend    DECIMAL(18,0)  NOT NULL DEFAULT 0,
    total_washes   INT            NOT NULL DEFAULT 0,
    tier_since     DATE           NULL,
    next_review    DATE           NULL,
    free_wash_used BIT            NOT NULL DEFAULT 0,
    free_upg_used  BIT            NOT NULL DEFAULT 0,
    updated_at     DATETIME2      NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (user_id)  REFERENCES users(id),
    FOREIGN KEY (tier_id)  REFERENCES tiers(id)
);
GO

-- ============================================================
-- 05. services
-- ============================================================
CREATE TABLE services (
    id           INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name         NVARCHAR(100)  NOT NULL,
    description  NVARCHAR(500)  NULL,
    price        DECIMAL(18,0)  NOT NULL,
    duration_min INT            NOT NULL,
    is_active    BIT            NOT NULL DEFAULT 1
);
GO

-- ============================================================
-- 06. bookings
--     priority sao chép từ tiers.priority khi đặt lịch
--     → xếp hàng chờ ưu tiên trong cùng ngày
-- ============================================================
CREATE TABLE bookings (
    id             INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_id        INT            NOT NULL,
    vehicle_id     INT            NOT NULL,
    service_id     INT            NOT NULL,
    scheduled_date DATE           NOT NULL,
    scheduled_time TIME           NOT NULL,
    status         NVARCHAR(20)   NOT NULL DEFAULT 'PENDING',
    priority       INT            NOT NULL DEFAULT 1,
    notes          NVARCHAR(500)  NULL,
    created_at     DATETIME2      NOT NULL DEFAULT GETDATE(),
    updated_at     DATETIME2      NULL,

    FOREIGN KEY (user_id)    REFERENCES users(id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (service_id) REFERENCES services(id)
);
GO

-- ============================================================
-- 07. point_logs
--     Nhật ký bất biến mọi biến động điểm
--     type: EARN | REDEEM | EXPIRE | ADJUST
-- ============================================================
CREATE TABLE point_logs (
    id         INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    account_id INT            NOT NULL,
    booking_id INT            NULL,
    type       NVARCHAR(10)   NOT NULL,
    amount     INT            NOT NULL,   -- dương = cộng, âm = trừ
    balance    INT            NOT NULL,   -- số dư sau giao dịch
    note       NVARCHAR(255)  NULL,
    expires_at DATE           NULL,       -- điểm EARN hết hạn sau 12 tháng
    created_at DATETIME2      NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (account_id) REFERENCES loyalty_accounts(id),
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
GO

-- ============================================================
-- 08. wash_sessions
--     booking_id nullable → hỗ trợ khách vãng lai
--     lpr_plate → biển số camera nhận diện
-- ============================================================
CREATE TABLE wash_sessions (
    id          INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    booking_id  INT            NULL,
    vehicle_id  INT            NOT NULL,
    service_id  INT            NOT NULL,
    lpr_plate   NVARCHAR(20)   NULL,
    started_at  DATETIME2      NULL,
    ended_at    DATETIME2      NULL,
    price       DECIMAL(18,0)  NULL,
    points_earn INT            NOT NULL DEFAULT 0,
    discount    DECIMAL(18,0)  NOT NULL DEFAULT 0,
    pay_method  NVARCHAR(30)   NULL,

    FOREIGN KEY (booking_id) REFERENCES bookings(id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (service_id) REFERENCES services(id)
);
GO

-- ============================================================
-- 09. rewards
--     min_tier_id NULL = tất cả bậc đổi được
-- ============================================================
CREATE TABLE rewards (
    id          INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name        NVARCHAR(100)  NOT NULL,
    type        NVARCHAR(20)   NOT NULL,   -- FREE_WASH | DISC_PERCENT | DISC_VND | FREE_UPGRADE
    points_cost INT            NOT NULL,
    value       DECIMAL(10,2)  NULL,
    min_tier_id INT            NULL,
    valid_from  DATE           NULL,
    valid_to    DATE           NULL,
    is_active   BIT            NOT NULL DEFAULT 1,

    FOREIGN KEY (min_tier_id) REFERENCES tiers(id)
);
GO

-- ============================================================
-- 10. redemptions
--     status: PENDING | USED | EXPIRED
-- ============================================================
CREATE TABLE redemptions (
    id           INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    account_id   INT            NOT NULL,
    reward_id    INT            NOT NULL,
    booking_id   INT            NULL,
    points_spent INT            NOT NULL,
    status       NVARCHAR(20)   NOT NULL DEFAULT 'PENDING',
    expires_at   DATE           NULL,
    created_at   DATETIME2      NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (account_id) REFERENCES loyalty_accounts(id),
    FOREIGN KEY (reward_id)  REFERENCES rewards(id),
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
GO

-- ============================================================
-- 11. promotions
--     min_tier_id NULL = tất cả bậc áp dụng được
--     type: PERCENT | VND | FREE_SERVICE
--     created_by → FK về users (admin tạo)
-- ============================================================
CREATE TABLE promotions (
    id          INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name        NVARCHAR(100)  NOT NULL,
    description NVARCHAR(500)  NULL,
    type        NVARCHAR(20)   NOT NULL,
    value       DECIMAL(10,2)  NULL,
    min_tier_id INT            NULL,
    start_date  DATE           NOT NULL,
    end_date    DATE           NOT NULL,
    is_active   BIT            NOT NULL DEFAULT 1,
    created_by  INT            NOT NULL,

    FOREIGN KEY (min_tier_id) REFERENCES tiers(id),
    FOREIGN KEY (created_by)  REFERENCES users(id)
);
GO

-- ============================================================
-- 12. promotion_services  (junction table)
-- ============================================================
CREATE TABLE promotion_services (
    id           INT  NOT NULL IDENTITY(1,1) PRIMARY KEY,
    promotion_id INT  NOT NULL,
    service_id   INT  NOT NULL,
    UNIQUE (promotion_id, service_id),

    FOREIGN KEY (promotion_id) REFERENCES promotions(id),
    FOREIGN KEY (service_id)   REFERENCES services(id)
);
GO

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX IX_users_role        ON users       (role);
CREATE INDEX IX_vehicles_plate    ON vehicles    (plate);
CREATE INDEX IX_bookings_date     ON bookings    (scheduled_date, status);
CREATE INDEX IX_bookings_user     ON bookings    (user_id);
CREATE INDEX IX_point_logs_exp    ON point_logs  (expires_at) WHERE expires_at IS NOT NULL;
CREATE INDEX IX_promotions_active ON promotions  (is_active, start_date, end_date);
GO

-- ============================================================
-- SEED DATA
-- ============================================================

-- Tiers
INSERT INTO tiers (name, min_washes, min_spend, point_rate, book_days, free_upgrade, free_wash, priority)
VALUES
    ('Member',   1,  0,         1.00, 7,  0, 0, 1),
    ('Silver',   5,  2000000,   1.10, 10, 0, 0, 2),
    ('Gold',     15, 6000000,   1.20, 12, 1, 0, 3),
    ('Platinum', 30, 15000000,  1.30, 14, 0, 1, 4);
GO

-- Users mặc định (thay password_hash trước khi deploy)
-- Admin: login bằng username
-- Customer: login bằng số điện thoại
INSERT INTO users (login_id, password_hash, role, full_name, email)
VALUES
    ('superadmin',  '$2b$12$REPLACE_WITH_REAL_BCRYPT_HASH', 'SUPER_ADMIN', N'System Administrator', NULL),
    ('manager01',   '$2b$12$REPLACE_WITH_REAL_BCRYPT_HASH', 'MANAGER',     N'Nguyễn Văn Quản Lý',   NULL),
    ('0901234567',  '$2b$12$REPLACE_WITH_REAL_BCRYPT_HASH', 'CUSTOMER',    N'Trần Thị Khách Hàng',  'khachhang@email.com');
GO

-- Dịch vụ mẫu
INSERT INTO services (name, description, price, duration_min)
VALUES
    (N'Basic Wash',    N'Rửa ngoại thất + sấy khô',                  70000,  15),
    (N'Premium Wash',  N'Rửa + vệ sinh nội thất + lau kính',          120000, 30),
    (N'Deluxe Wash',   N'Premium + đánh bóng + phủ nano bảo vệ',      250000, 60),
    (N'Engine Clean',  N'Vệ sinh khoang máy chuyên nghiệp',           180000, 45),
    (N'Interior Deep', N'Hút bụi sâu + khử mùi + dưỡng da nội thất', 200000, 50);
GO

-- ============================================================
-- ROLE REFERENCE (không tạo bảng, BE dùng enum)
-- ============================================================
-- users.role  : 'CUSTOMER' | 'STAFF' | 'MANAGER' | 'SUPER_ADMIN'
-- users.login_id:
--   CUSTOMER  → số điện thoại  (VD: "0901234567")
--   admin     → username       (VD: "superadmin")
--
-- Luồng login (1 endpoint POST /api/auth/login):
--   Input: { login_id, password }
--   1. Query users theo login_id
--      → lấy id, password_hash, role, full_name, email (1 query, không JOIN)
--   2. Verify BCrypt(password, password_hash)
--   3. Tạo JWT { user_id, role } → trả về client
--
-- JwtFilter (chạy trước mọi request):
--   - /api/admin/**    → role IN ('SUPER_ADMIN', 'MANAGER', 'STAFF')
--   - /api/customer/** → role = 'CUSTOMER'
--   - Sai role → 403 Forbidden ngay lập tức (không query DB)
-- ============================================================

PRINT '============================================================';
PRINT ' AutoWashPro v4.0 ready.';
PRINT ' 12 tables | 6 indexes | 4 tiers | 3 users | 5 services';
PRINT ' Cach C: admins + customers → 1 bang users';
PRINT '============================================================';
GO
