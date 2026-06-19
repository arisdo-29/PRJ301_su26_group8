USE AutoWashPro;
GO

-- ================================================================
--  SQLQuery1.sql – Dữ liệu mẫu (v2)
--
--  YÊU CẦU: Chạy AutoWashPro_Database.sql TRƯỚC file này
--            (cần có sẵn tiers + services trong DB)
--
--  ĐÃ SỬA:
--    + 'CANCEL'  → 'CANCELLED'   (ngữ pháp đúng: past participle)
--    + 'CHECKIN' → 'CHECKED_IN'  (ngữ pháp đúng: past participle)
--    + Thêm lại INSERT users/vehicles với kiểm tra trùng (IF NOT EXISTS)
--      → an toàn khi chạy dù schema đã seed hay chưa
--    + Dùng subquery lấy ID thay vì hardcode
--      → đúng cho dù IDENTITY bắt đầu từ số nào
--    + Sửa balance trong point_logs cho hợp lý (không bị âm)
--    + Sửa redemptions: account phải đủ điểm để đổi thưởng
-- ================================================================

-- ──────────────────────────────────────────────────────────────
-- 0. KIỂM TRA PREREQUISITES
-- ──────────────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM tiers WHERE name = 'Member')
BEGIN
    RAISERROR(N'LỖI: Chạy AutoWashPro_Database.sql trước khi chạy file này!', 16, 1);
    RETURN;
END
GO

-- ──────────────────────────────────────────────────────────────
-- 1. USERS  (4 khách hàng mẫu)
--    IF NOT EXISTS → an toàn khi schema đã seed sẵn
-- ──────────────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'an@gmail.com')
    INSERT INTO users (phone_number, email, password, role, full_name)
    VALUES ('0911111111', 'an@gmail.com', '123456', 'CUSTOMER', N'Nguyễn Văn An');

IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'binh@gmail.com')
    INSERT INTO users (phone_number, email, password, role, full_name)
    VALUES ('0922222222', 'binh@gmail.com', '123456', 'CUSTOMER', N'Trần Thị Bình');

IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'chau@gmail.com')
    INSERT INTO users (phone_number, email, password, role, full_name)
    VALUES ('0933333333', 'chau@gmail.com', '123456', 'CUSTOMER', N'Lê Minh Châu');

IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'dung@gmail.com')
    INSERT INTO users (phone_number, email, password, role, full_name)
    VALUES ('0944444444', 'dung@gmail.com', '123456', 'CUSTOMER', N'Phạm Quốc Dũng');
GO

-- ──────────────────────────────────────────────────────────────
-- 2. VEHICLES  (5 ô tô, chỉ ô tô – không xe máy)
--    IF NOT EXISTS kiểm tra theo biển số (UNIQUE)
-- ──────────────────────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM vehicles WHERE plate = '51H-12345')
    INSERT INTO vehicles (user_id, plate, type, brand, model, color, is_primary, is_active)
    SELECT id, '51H-12345', 'Sedan', 'Toyota', 'Vios', N'Trắng', 1, 1
    FROM users WHERE email = 'an@gmail.com';

IF NOT EXISTS (SELECT 1 FROM vehicles WHERE plate = '50F-22222')
    INSERT INTO vehicles (user_id, plate, type, brand, model, color, is_primary, is_active)
    SELECT id, '50F-22222', 'Sedan', 'Hyundai', 'Accent', N'Đỏ', 1, 1
    FROM users WHERE email = 'binh@gmail.com';

IF NOT EXISTS (SELECT 1 FROM vehicles WHERE plate = '61A-33333')
    INSERT INTO vehicles (user_id, plate, type, brand, model, color, is_primary, is_active)
    SELECT id, '61A-33333', 'SUV', 'Kia', 'Seltos', N'Xanh', 1, 1
    FROM users WHERE email = 'chau@gmail.com';

IF NOT EXISTS (SELECT 1 FROM vehicles WHERE plate = '62B-44444')
    INSERT INTO vehicles (user_id, plate, type, brand, model, color, is_primary, is_active)
    SELECT id, '62B-44444', 'SUV', 'Ford', 'EcoSport', N'Đen', 1, 1
    FROM users WHERE email = 'dung@gmail.com';

IF NOT EXISTS (SELECT 1 FROM vehicles WHERE plate = '51H-99999')
    INSERT INTO vehicles (user_id, plate, type, brand, model, color, is_primary, is_active)
    SELECT id, '51H-99999', 'Sedan', 'Honda', 'City', N'Bạc', 0, 1
    FROM users WHERE email = 'an@gmail.com';
GO

-- ──────────────────────────────────────────────────────────────
-- 3. LOYALTY_ACCOUNTS
--    Dùng subquery lấy user_id → không phụ thuộc vào IDENTITY
--    NOT EXISTS → không trùng khi chạy lại
--
--    Điểm nhất quán với point_logs bên dưới:
--      An   : 1 lần rửa, kiếm 180 điểm (Interior Deep sau giảm)
--      Bình : 6 lần rửa, hiện có 600đ (đã đổi thưởng lần trước)
--      Châu : 18 lần rửa, hiện có 1300đ (đã đổi thưởng lần trước)
--      Dũng : 1 lần rửa, kiếm 180 điểm (Engine Clean)
-- ──────────────────────────────────────────────────────────────
INSERT INTO loyalty_accounts (user_id, tier_id, points, total_points, total_spend, total_washes, tier_since, next_review)
SELECT id, 1, 180, 180, 200000, 1, '2026-01-01', '2027-01-01'
FROM users WHERE email = 'an@gmail.com'
  AND NOT EXISTS (SELECT 1 FROM loyalty_accounts la
                  WHERE la.user_id = (SELECT id FROM users WHERE email = 'an@gmail.com'));

INSERT INTO loyalty_accounts (user_id, tier_id, points, total_points, total_spend, total_washes, tier_since, next_review)
SELECT id, 2, 600, 1500, 2500000, 6, '2026-01-01', '2027-01-01'
FROM users WHERE email = 'binh@gmail.com'
  AND NOT EXISTS (SELECT 1 FROM loyalty_accounts la
                  WHERE la.user_id = (SELECT id FROM users WHERE email = 'binh@gmail.com'));

INSERT INTO loyalty_accounts (user_id, tier_id, points, total_points, total_spend, total_washes, tier_since, next_review)
SELECT id, 3, 1300, 5000, 8000000, 18, '2026-01-01', '2027-01-01'
FROM users WHERE email = 'chau@gmail.com'
  AND NOT EXISTS (SELECT 1 FROM loyalty_accounts la
                  WHERE la.user_id = (SELECT id FROM users WHERE email = 'chau@gmail.com'));

INSERT INTO loyalty_accounts (user_id, tier_id, points, total_points, total_spend, total_washes, tier_since, next_review)
SELECT id, 1, 180, 180, 180000, 1, '2026-01-01', '2027-01-01'
FROM users WHERE email = 'dung@gmail.com'
  AND NOT EXISTS (SELECT 1 FROM loyalty_accounts la
                  WHERE la.user_id = (SELECT id FROM users WHERE email = 'dung@gmail.com'));
GO

-- ──────────────────────────────────────────────────────────────
-- 4. BOOKINGS
--    Status đúng ngữ pháp:
--      PENDING    – đã đặt lịch, chưa đến
--      CANCELLED  – đã hủy  (sửa từ CANCEL)
--      CHECKED_IN – đã đến rửa xe  (sửa từ CHECKIN)
--
--    Dùng subquery cho user_id, vehicle_id, service_id
-- ──────────────────────────────────────────────────────────────
INSERT INTO bookings
    (user_id, vehicle_id, service_id,
     scheduled_date, scheduled_time,
     status, priority,
     price, discount, pay_method, points_earn, checkin_at)
VALUES
-- PENDING: chưa đến
(
    (SELECT id FROM users    WHERE email = 'an@gmail.com'),
    (SELECT id FROM vehicles WHERE plate = '51H-12345'),
    (SELECT id FROM services WHERE name  = N'Basic Wash'),
    '2026-06-20', '08:00', 'PENDING', 1,
    NULL, 0, NULL, 0, NULL
),
(
    (SELECT id FROM users    WHERE email = 'binh@gmail.com'),
    (SELECT id FROM vehicles WHERE plate = '50F-22222'),
    (SELECT id FROM services WHERE name  = N'Premium Wash'),
    '2026-06-20', '09:00', 'PENDING', 2,
    NULL, 0, NULL, 0, NULL
),

-- CHECKED_IN: đã đến rửa, điền đầy đủ thông tin thanh toán
(
    (SELECT id FROM users    WHERE email = 'chau@gmail.com'),
    (SELECT id FROM vehicles WHERE plate = '61A-33333'),
    (SELECT id FROM services WHERE name  = N'Deluxe Wash'),
    '2026-06-01', '10:00', 'CHECKED_IN', 3,
    250000, 10000, 'CARD', 240, '2026-06-01 10:05'
),
(
    (SELECT id FROM users    WHERE email = 'dung@gmail.com'),
    (SELECT id FROM vehicles WHERE plate = '62B-44444'),
    (SELECT id FROM services WHERE name  = N'Engine Clean'),
    '2026-06-02', '11:00', 'CHECKED_IN', 1,
    180000, 0, 'CASH', 180, '2026-06-02 11:02'
),
(
    (SELECT id FROM users    WHERE email = 'an@gmail.com'),
    (SELECT id FROM vehicles WHERE plate = '51H-99999'),
    (SELECT id FROM services WHERE name  = N'Interior Deep'),
    '2026-06-03', '13:00', 'CHECKED_IN', 1,
    200000, 20000, 'MOMO', 180, '2026-06-03 13:08'
),

-- CANCELLED: đã hủy (vẫn lưu lại trong DB)
(
    (SELECT id FROM users    WHERE email = 'binh@gmail.com'),
    (SELECT id FROM vehicles WHERE plate = '50F-22222'),
    (SELECT id FROM services WHERE name  = N'Basic Wash'),
    '2026-06-05', '14:00', 'CANCELLED', 2,
    NULL, 0, NULL, 0, NULL
);
GO

-- ──────────────────────────────────────────────────────────────
-- 5. POINT_LOGS
--    Gắn với 3 booking CHECKED_IN (Châu, Dũng, An)
--    balance = số dư SAU giao dịch (phải khớp loyalty_accounts.points)
--
--    Châu : kiếm 240đ  → balance = 1300 (khớp tài khoản)
--    Dũng : kiếm 180đ  → balance = 180  (khớp tài khoản, lần đầu rửa)
--    An   : kiếm 180đ  → balance = 180  (khớp tài khoản, lần đầu rửa)
-- ──────────────────────────────────────────────────────────────
INSERT INTO point_logs (account_id, booking_id, type, amount, balance, note)
VALUES
(
    (SELECT la.id FROM loyalty_accounts la
     JOIN users u ON la.user_id = u.id WHERE u.email = 'chau@gmail.com'),
    (SELECT b.id FROM bookings b
     JOIN users u ON b.user_id = u.id
     WHERE u.email = 'chau@gmail.com' AND b.status = 'CHECKED_IN'),
    'EARN', 240, 1300, N'Deluxe Wash – 2026-06-01'
),
(
    (SELECT la.id FROM loyalty_accounts la
     JOIN users u ON la.user_id = u.id WHERE u.email = 'dung@gmail.com'),
    (SELECT b.id FROM bookings b
     JOIN users u ON b.user_id = u.id
     WHERE u.email = 'dung@gmail.com' AND b.status = 'CHECKED_IN'),
    'EARN', 180, 180, N'Engine Clean – 2026-06-02'
),
(
    (SELECT la.id FROM loyalty_accounts la
     JOIN users u ON la.user_id = u.id WHERE u.email = 'an@gmail.com'),
    (SELECT b.id FROM bookings b
     JOIN users u ON b.user_id = u.id
     WHERE u.email = 'an@gmail.com' AND b.status = 'CHECKED_IN'),
    'EARN', 180, 180, N'Interior Deep – 2026-06-03'
);
GO

-- ──────────────────────────────────────────────────────────────
-- 6. REWARDS
--    points_cost > 0 : khách đổi điểm
--    points_cost = 0 : khuyến mãi admin (áp dụng tự động)
-- ──────────────────────────────────────────────────────────────
INSERT INTO rewards (name, description, type, points_cost, value, min_tier_id, start_date, end_date)
VALUES
-- Phần thưởng đổi điểm
(N'Miễn phí 1 lần rửa',
 N'Đổi điểm để được rửa xe miễn phí 1 lần',
 'FREE_WASH', 1000, NULL,
 (SELECT id FROM tiers WHERE name='Member'), NULL, NULL),

(N'Giảm 10%',
 N'Giảm 10% hóa đơn lần rửa kế tiếp',
 'DISC_PERCENT', 500, 10,
 (SELECT id FROM tiers WHERE name='Member'), NULL, NULL),

(N'Giảm 50.000đ',
 N'Giảm 50.000đ cho hạng Silver trở lên',
 'DISC_VND', 700, 50000,
 (SELECT id FROM tiers WHERE name='Silver'), NULL, NULL),

-- Khuyến mãi của admin (points_cost = 0)
(N'Summer Sale 10%',
 N'Khuyến mãi hè – giảm 10% tất cả dịch vụ',
 'DISC_PERCENT', 0, 10,
 NULL, '2026-06-01', '2026-08-31'),

(N'Gold Deal 20%',
 N'Ưu đãi riêng cho hạng Gold – giảm 20%',
 'DISC_PERCENT', 0, 20,
 (SELECT id FROM tiers WHERE name='Gold'), '2026-06-01', '2026-09-30');
GO

-- ──────────────────────────────────────────────────────────────
-- 7. REDEMPTIONS
--    Chỉ customer đủ điểm mới được đổi:
--      Bình (600đ) đổi 'Giảm 10%' (500đ) → PENDING (chưa dùng)
--      Châu (1300đ) đổi 'Miễn phí rửa' (1000đ) → USED (đã dùng)
-- ──────────────────────────────────────────────────────────────
INSERT INTO redemptions (account_id, reward_id, booking_id, points_spent, status)
VALUES
(
    (SELECT la.id FROM loyalty_accounts la
     JOIN users u ON la.user_id = u.id WHERE u.email = 'binh@gmail.com'),
    (SELECT id FROM rewards WHERE name = N'Giảm 10%'),
    NULL, 500, 'PENDING'
),
(
    (SELECT la.id FROM loyalty_accounts la
     JOIN users u ON la.user_id = u.id WHERE u.email = 'chau@gmail.com'),
    (SELECT id FROM rewards WHERE name = N'Miễn phí 1 lần rửa'),
    NULL, 1000, 'USED'
);
GO

-- ──────────────────────────────────────────────────────────────
-- Kiểm tra nhanh sau khi insert
-- ──────────────────────────────────────────────────────────────
SELECT 'users'            AS [Table], COUNT(*) AS [Rows] FROM users
UNION ALL
SELECT 'vehicles',          COUNT(*) FROM vehicles
UNION ALL
SELECT 'loyalty_accounts',  COUNT(*) FROM loyalty_accounts
UNION ALL
SELECT 'bookings',          COUNT(*) FROM bookings
UNION ALL
SELECT 'point_logs',        COUNT(*) FROM point_logs
UNION ALL
SELECT 'rewards',           COUNT(*) FROM rewards
UNION ALL
SELECT 'redemptions',       COUNT(*) FROM redemptions;
GO
