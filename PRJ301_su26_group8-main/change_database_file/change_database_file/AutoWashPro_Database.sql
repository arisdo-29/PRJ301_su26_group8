-- ============================================================
--  AutoWashPro  –  Database Schema  (v2 – Simplified)
-- ============================================================
--  09 Tables (giảm từ 12):
--   01. tiers                – Định nghĩa hạng thành viên
--   02. users                – Tài khoản admin + customer  [BỎ login_id]
--   03. vehicles             – Xe đã đăng ký               [THÊM is_active - soft delete]
--   04. loyalty_accounts     – Ví điểm 1:1 với customer
--   05. point_logs           – Lịch sử biến động điểm
--   06. services             – Danh mục dịch vụ rửa xe
--   07. bookings             – Lịch đặt                    [THÊM price/discount/pay_method/points_earn/checkin_at]
--                                                           [Status: PENDING | CANCEL | CHECKIN]
--   08. rewards              – Phần thưởng + khuyến mãi    [GỘP promotion vào đây]
--                                                           [points_cost=0 → khuyến mãi của admin]
--   09. redemptions          – Lịch sử đổi thưởng
--
--  ĐÃ XÓA:
--   - wash_sessions    → các trường cần thiết đã gộp vào bookings
--   - promotions       → gộp vào bảng rewards (points_cost = 0)
--   - promotion_services → không còn cần thiết
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'AutoWashPro')
    CREATE DATABASE AutoWashPro;
GO

USE AutoWashPro;
GO

-- ── Drop theo thứ tự FK ngược (chạy lại an toàn) ───────────
IF OBJECT_ID('redemptions',      'U') IS NOT NULL DROP TABLE redemptions;
IF OBJECT_ID('rewards',          'U') IS NOT NULL DROP TABLE rewards;
IF OBJECT_ID('point_logs',       'U') IS NOT NULL DROP TABLE point_logs;
IF OBJECT_ID('bookings',         'U') IS NOT NULL DROP TABLE bookings;
IF OBJECT_ID('loyalty_accounts', 'U') IS NOT NULL DROP TABLE loyalty_accounts;
IF OBJECT_ID('vehicles',         'U') IS NOT NULL DROP TABLE vehicles;
IF OBJECT_ID('services',         'U') IS NOT NULL DROP TABLE services;
IF OBJECT_ID('users',            'U') IS NOT NULL DROP TABLE users;
IF OBJECT_ID('tiers',            'U') IS NOT NULL DROP TABLE tiers;
GO

-- ============================================================
-- 01. tiers
--     book_days: số ngày trước tối đa được phép đặt lịch theo hạng
--     priority : số càng cao → được ưu tiên xếp hàng hơn
-- ============================================================
CREATE TABLE tiers (
    id           INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name         NVARCHAR(20)   NOT NULL UNIQUE,
    min_washes   INT            NOT NULL DEFAULT 0,
    min_spend    DECIMAL(18,0)  NOT NULL DEFAULT 0,
    point_rate   DECIMAL(3,2)   NOT NULL DEFAULT 1.00,
    book_days    INT            NOT NULL DEFAULT 7,   -- Member:7 Silver:10 Gold:12 Platinum:14
    free_upgrade BIT            NOT NULL DEFAULT 0,
    free_wash    BIT            NOT NULL DEFAULT 0,
    priority     INT            NOT NULL DEFAULT 1    -- Member:1 Silver:2 Gold:3 Platinum:4
);
GO

-- ============================================================
-- 02. users  [THAY ĐỔI: xóa cột login_id]
--
--  Đăng nhập:
--    CUSTOMER  → dùng phone_number hoặc email + password
--    STAFF/ADMIN → dùng email + password
--
--  Lưu ý: phone_number và email đều nullable nhưng application
--          phải đảm bảo ít nhất 1 trong 2 phải có giá trị.
--          CUSTOMER bắt buộc có phone_number khi đăng ký.
-- ============================================================
CREATE TABLE users (
    id           INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    phone_number NVARCHAR(20)   NULL     UNIQUE,   -- CUSTOMER đăng nhập bằng số điện thoại
    email        NVARCHAR(100)  NULL     UNIQUE,   -- CUSTOMER hoặc admin đăng nhập bằng email
    password     NVARCHAR(100)  NOT NULL,
    role         NVARCHAR(20)   NOT NULL DEFAULT 'CUSTOMER',  -- CUSTOMER | STAFF | MANAGER | SUPER_ADMIN
    full_name    NVARCHAR(100)  NOT NULL,
    is_active    BIT            NOT NULL DEFAULT 1,
    created_at   DATETIME2      NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- 03. vehicles  [THAY ĐỔI: thêm is_active – soft delete]
--
--  Hệ thống chỉ phục vụ Ô TÔ (không có xe máy).
--  Khi "xóa xe", chỉ đặt is_active = 0.
--  Booking cũ vẫn giữ nguyên vehicle_id, không bị mất dữ liệu.
--  type: có thể dùng cho "Sedan", "SUV", "Truck", v.v.
-- ============================================================
CREATE TABLE vehicles (
    id          INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_id     INT            NOT NULL,
    plate       NVARCHAR(20)   NOT NULL UNIQUE,
    type        NVARCHAR(20)   NULL,       -- Sedan | SUV | Truck | ...
    brand       NVARCHAR(50)   NULL,
    model       NVARCHAR(50)   NULL,
    color       NVARCHAR(30)   NULL,
    is_primary  BIT            NOT NULL DEFAULT 0,
    is_active   BIT            NOT NULL DEFAULT 1,  -- 0 = đã xóa (soft delete)
    created_at  DATETIME2      NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES users(id)
);
GO

-- ============================================================
-- 04. loyalty_accounts
--     1:1 với users có role = CUSTOMER
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

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (tier_id) REFERENCES tiers(id)
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
-- 06. bookings  [THAY ĐỔI LỚN]
--
--  Trạng thái mới: PENDING → CANCEL hoặc CHECKIN
--    PENDING : đã đặt lịch, chưa đến
--    CANCEL  : hủy (vẫn lưu trong DB, không xóa)
--    CHECKIN : khách đã đến, xe đã được rửa
--
--  Gộp từ wash_sessions:
--    price, discount, pay_method, points_earn, checkin_at
--    → điền khi nhân viên đổi trạng thái sang CHECKIN
--
--  Tier-based booking window (xử lý ở application layer):
--    scheduled_date <= GETDATE() + tiers.book_days
--
--  Priority queue: copy từ tiers.priority lúc đặt lịch
--    → trong cùng 1 ngày, priority cao hơn phục vụ trước
-- ============================================================
CREATE TABLE bookings (
    id             INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_id        INT            NOT NULL,
    vehicle_id     INT            NOT NULL,
    service_id     INT            NOT NULL,
    scheduled_date DATE           NOT NULL,
    scheduled_time TIME           NOT NULL,
    status         NVARCHAR(20)   NOT NULL DEFAULT 'PENDING',  -- PENDING | CANCEL | CHECKIN
    priority       INT            NOT NULL DEFAULT 1,
    notes          NVARCHAR(500)  NULL,

    -- Thông tin thanh toán – điền khi status = CHECKIN
    price          DECIMAL(18,0)  NULL,
    discount       DECIMAL(18,0)  NOT NULL DEFAULT 0,
    pay_method     NVARCHAR(30)   NULL,    -- CASH | MOMO | CARD | BANK
    points_earn    INT            NOT NULL DEFAULT 0,
    checkin_at     DATETIME2      NULL,    -- thời điểm thực tế khách đến

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
    expires_at DATE           NULL,
    created_at DATETIME2      NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (account_id) REFERENCES loyalty_accounts(id),
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
GO

-- ============================================================
-- 08. rewards  [THAY ĐỔI: gộp promotions vào đây]
--
--  Phân biệt 2 loại bằng points_cost:
--    points_cost > 0  → phần thưởng đổi điểm (customer tự đổi)
--    points_cost = 0  → khuyến mãi của admin (áp dụng tự động)
--
--  type: FREE_WASH | DISC_PERCENT | DISC_VND | FREE_UPGRADE
--
--  min_tier_id NULL = tất cả hạng đều được hưởng/đổi
--
--  Đổi tên cột: valid_from → start_date, valid_to → end_date
--  (thống nhất tên với promotions cũ)
-- ============================================================
CREATE TABLE rewards (
    id          INT            NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name        NVARCHAR(100)  NOT NULL,
    description NVARCHAR(255)  NULL,                -- thêm mô tả ngắn
    type        NVARCHAR(20)   NOT NULL,            -- FREE_WASH | DISC_PERCENT | DISC_VND | FREE_UPGRADE
    points_cost INT            NOT NULL DEFAULT 0,  -- 0 = khuyến mãi (admin), > 0 = đổi điểm (customer)
    value       DECIMAL(10,2)  NULL,
    min_tier_id INT            NULL,
    start_date  DATE           NULL,                -- đổi tên từ valid_from
    end_date    DATE           NULL,                -- đổi tên từ valid_to
    is_active   BIT            NOT NULL DEFAULT 1,

    FOREIGN KEY (min_tier_id) REFERENCES tiers(id)
);
GO

-- ============================================================
-- 09. redemptions
--     Lịch sử đổi thưởng (chỉ dành cho rewards có points_cost > 0)
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
-- INDEXES
-- ============================================================
CREATE INDEX IX_users_role      ON users    (role);
CREATE INDEX IX_vehicles_plate  ON vehicles (plate);
CREATE INDEX IX_vehicles_active ON vehicles (user_id, is_active);  -- lọc xe hoạt động
CREATE INDEX IX_bookings_date   ON bookings (scheduled_date, status);
CREATE INDEX IX_bookings_user   ON bookings (user_id);
CREATE INDEX IX_point_logs_exp  ON point_logs (expires_at) WHERE expires_at IS NOT NULL;
CREATE INDEX IX_rewards_active  ON rewards (is_active, start_date, end_date);
GO

-- ============================================================
-- SEED DATA
-- ============================================================

-- Tiers
INSERT INTO tiers (name, min_washes, min_spend, point_rate, book_days, free_upgrade, free_wash, priority)
VALUES
    ('Member',    1,  0,         1.00,  7, 0, 0, 1),
    ('Silver',    5,  2000000,   1.10, 10, 0, 0, 2),
    ('Gold',     15,  6000000,   1.20, 12, 1, 0, 3),
    ('Platinum', 30, 15000000,   1.30, 14, 0, 1, 4);
GO

-- Users (không còn login_id)
-- Admin đăng nhập bằng email, Customer đăng nhập bằng phone hoặc email
INSERT INTO users (phone_number, email, password, role, full_name)
VALUES
-- Admin
(NULL,          'admin@autowash.com',  '123456', 'SUPER_ADMIN', N'System Administrator'),
-- Customers
('0911111111',  'an@gmail.com',        '123456', 'CUSTOMER',    N'Nguyễn Văn An'),
('0922222222',  'binh@gmail.com',      '123456', 'CUSTOMER',    N'Trần Thị Bình'),
('0933333333',  'chau@gmail.com',      '123456', 'CUSTOMER',    N'Lê Minh Châu'),
('0944444444',  'dung@gmail.com',      '123456', 'CUSTOMER',    N'Phạm Quốc Dũng');
GO

-- Services
INSERT INTO services (name, description, price, duration_min)
VALUES
    (N'Basic Wash',    N'Rửa ngoại thất + sấy khô',                   70000,  15),
    (N'Premium Wash',  N'Rửa + vệ sinh nội thất + lau kính',          120000,  30),
    (N'Deluxe Wash',   N'Premium + đánh bóng + phủ nano bảo vệ',      250000,  60),
    (N'Engine Clean',  N'Vệ sinh khoang máy chuyên nghiệp',           180000,  45),
    (N'Interior Deep', N'Hút bụi sâu + khử mùi + dưỡng da nội thất', 200000,  50);
GO

-- Vehicles (ô tô chỉ, không xe máy)
-- user_id: 2=An, 3=Bình, 4=Châu, 5=Dũng
INSERT INTO vehicles (user_id, plate, type, brand, model, color, is_primary, is_active)
VALUES
(2, '51H-12345', 'Sedan', 'Toyota',  'Vios',   N'Trắng', 1, 1),
(3, '50F-22222', 'Sedan', 'Hyundai', 'Accent', N'Đỏ',    1, 1),
(4, '61A-33333', 'SUV',   'Kia',     'Seltos', N'Xanh',  1, 1),
(5, '62B-44444', 'SUV',   'Ford',    'EcoSport',N'Đen',  1, 1),
(2, '51H-99999', 'Sedan', 'Honda',   'City',   N'Bạc',   0, 1);  -- An có 2 xe
GO

PRINT '============================================================';
PRINT ' AutoWashPro v2 ready.';
PRINT ' 09 tables | 7 indexes | 4 tiers | 5 users | 5 services';
PRINT '============================================================';
GO
