# CHANGELOG – AutoWashPro Database v2

> File này ghi lại **toàn bộ thay đổi** so với phiên bản v1, kèm lý do và những chỗ cần sửa trong code Java/JSP.

---

## 1. Bảng `promotions` và `promotion_services` → XÓA

### Thay đổi trong Database
- **Xóa** bảng `promotions`
- **Xóa** bảng `promotion_services`
- Khuyến mãi của admin giờ được lưu thẳng vào bảng `rewards` với **`points_cost = 0`**
  - `points_cost > 0` → phần thưởng thông thường, customer đổi bằng điểm
  - `points_cost = 0` → khuyến mãi admin cấu hình, áp dụng tự động

### Kiểm tra Java / JSP
| File | Có liên quan promotions? | Cần sửa? |
|------|--------------------------|----------|
| `my_points.jsp` | ❌ Không | Không cần sửa |
| `LoyaltyDAO.java` | ❌ Không | Chỉ sửa tên cột (xem mục 2) |
| `UserDAO.java` | ❌ Không | Không liên quan |
| `VehicleDao.java` | ❌ Không | Không liên quan |
| `SQLQuery1.sql` | ✅ Có | Đã xóa INSERT vào promotions/promotion_services |

### Thay đổi trong `rewards` (gộp promotion vào)
| Cột cũ | Cột mới | Ghi chú |
|--------|---------|---------|
| `valid_from` | `start_date` | Đổi tên cho nhất quán với promotion cũ |
| `valid_to` | `end_date` | Đổi tên cho nhất quán với promotion cũ |
| _(không có)_ | `description` | Thêm mô tả ngắn |
| `points_cost DEFAULT 1` | `points_cost DEFAULT 0` | 0 = khuyến mãi, > 0 = đổi điểm |

---

## 2. Bảng `wash_sessions` → XÓA, gộp vào `bookings`

### Thay đổi trong Database
- **Xóa** bảng `wash_sessions`
- **Thêm các cột sau vào `bookings`** (điền khi staff đổi trạng thái → CHECKIN):

| Cột thêm vào bookings | Kiểu | Ghi chú |
|-----------------------|------|---------|
| `price` | DECIMAL(18,0) NULL | Giá thực tế |
| `discount` | DECIMAL(18,0) NOT NULL DEFAULT 0 | Giảm giá |
| `pay_method` | NVARCHAR(30) NULL | CASH / MOMO / CARD / BANK |
| `points_earn` | INT NOT NULL DEFAULT 0 | Điểm tích được |
| `checkin_at` | DATETIME2 NULL | Thời điểm khách thực tế đến |

### Trạng thái booking mới
| Status cũ | Status mới | Ý nghĩa |
|-----------|------------|---------|
| PENDING | PENDING | Đã đặt, chưa đến |
| CONFIRMED | _(bỏ)_ | Gộp vào PENDING |
| COMPLETED | CHECKIN | Đã đến và đã rửa |
| CANCELLED | CANCEL | Đã hủy (giữ nguyên trong DB) |

### Tier-based booking window
Đã có sẵn cột `book_days` trong bảng `tiers` từ v1:
- Member: 7 ngày | Silver: 10 ngày | Gold: 12 ngày | Platinum: 14 ngày

Xử lý ở **application layer (Servlet)**: khi customer tạo booking, kiểm tra:
```java
// Pseudo-code trong BookingServlet
int maxDays = tier.getBookDays();
LocalDate maxDate = LocalDate.now().plusDays(maxDays);
if (scheduledDate.isAfter(maxDate)) {
    // Báo lỗi: "Hạng [X] chỉ được đặt trước tối đa [N] ngày"
}
```

### Cần làm gì trong Java
1. **Tạo mới** `BookingDAO.java` với các method:
   - `createBooking(Booking b)` – tạo booking mới
   - `getBookingsByUser(int userId)` – lịch sử booking (tất cả trạng thái)
   - `getWashHistory(int userId)` – lịch sử rửa xe (chỉ CHECKIN)
   - `cancelBooking(int bookingId, int userId)` – đổi status → CANCEL
   - `checkin(int bookingId, BigDecimal price, String payMethod, ...)` – đổi status → CHECKIN, điền thông tin thanh toán, cộng điểm

2. **File `Booking.java`** đã được tạo mới (xem file output).

3. **Không cần sửa** `LoyaltyDAO.java` cho phần booking (chỉ sửa tên cột reward).

---

## 3. Bảng `vehicles` – Thêm `is_active` (Soft Delete)

### Thay đổi trong Database
```sql
-- Cột mới thêm vào
is_active  BIT  NOT NULL DEFAULT 1   -- 0 = xe đã "xóa"
```

- **Hệ thống chỉ phục vụ Ô TÔ**: xóa dữ liệu mẫu có type = 'Motorbike'
- Cột `type` vẫn giữ, dùng cho: `Sedan | SUV | Truck | ...`

### Thay đổi trong `Vehicle.java`
```java
// THÊM trường mới
private boolean isActive;

// THÊM getter/setter
public boolean isActive()               { return isActive; }
public void    setActive(boolean v)     { this.isActive = v; }

// CẬP NHẬT constructor: thêm tham số isActive
public Vehicle(int id, int userId, String plate, String type,
               String brand, String model, String color,
               boolean isActive, Date createdAt) { ... }
```

### Thay đổi trong `VehicleDao.java`
```java
// getCars(): thêm điều kiện lọc xe còn hoạt động
"WHERE [user_id] = ? AND [is_active] = 1"

// deleteCar(): ĐỔI từ DELETE thành soft delete
// TRƯỚC (v1):
"DELETE FROM [dbo].[vehicles] WHERE [id] = ?"
// SAU (v2):
"UPDATE [dbo].[vehicles] SET [is_active] = 0 WHERE [id] = ?"
```

### Thay đổi trong `UserDAO.getVehicleByPlate()`
```java
// SỬA BUG: v1 không có [type] và [is_active] trong SELECT nhưng lại dùng trong constructor
// TRƯỚC (v1 – lỗi):
"select [id], [user_id], [plate], [brand], [model], [color], [created_at] ..."
// SAU (v2 – đúng):
"SELECT [id],[user_id],[plate],[type],[brand],[model],[color],[is_active],[created_at] ..."
// Thêm: AND [is_active]=1 để không trả về xe đã xóa
```

---

## 4. Bảng `users` – Xóa `login_id`

### Thay đổi trong Database
```sql
-- XÓA cột
login_id  NVARCHAR(100)  NOT NULL UNIQUE

-- Đăng nhập bằng email HOẶC phone_number
-- phone_number: CUSTOMER
-- email: CUSTOMER hoặc STAFF/ADMIN
```

### Luồng đăng nhập mới
```
Nhập: { identifier, password }
  → Thử getUser(email, password)   -- nếu identifier chứa @
  → Thử getUserByPhone(phone, password) -- nếu identifier là số điện thoại
  → Không tìm thấy → báo lỗi đăng nhập
```

### Thay đổi trong `User.java`
```java
// XÓA: private String loginId;
// XÓA: public String getLoginId() / setLoginId()
// XÓA: constructor có loginId

// ĐỔI TÊN: phoneName → phoneNumber (giữ getPhoneName() làm alias)
private String phoneNumber;   // was: phoneName
```

### Thay đổi trong `UserDAO.java`
```java
// createNewUser(): bỏ login_id khỏi INSERT
// TRƯỚC:
"INSERT INTO dbo.users(login_id, phone_number, password, role, full_name, email, is_active) VALUES(?,?,?,?,?,?,?)"
// SAU:
"INSERT INTO dbo.users(phone_number, email, password, role, full_name, is_active) VALUES(?,?,?,?,?,?)"

// getUser(email, password): bỏ [login_id] khỏi SELECT
// getUser(email): bỏ [login_id] khỏi SELECT
// getUserByPhone(): bỏ [login_id] khỏi SELECT, thêm tham số password
//                  → getUserByPhone(String phone, String password) cho đăng nhập
//                  → getUserByPhone(String phone) overload cho tra cứu nội bộ
```

---

## Tổng hợp file đã thay đổi

| File | Trạng thái | Nội dung thay đổi |
|------|------------|-------------------|
| `AutoWashPro_Database.sql` | ✅ Đã sửa | Schema v2: 9 bảng (bỏ 3 bảng cũ), sửa users/vehicles/bookings/rewards |
| `SQLQuery1.sql` | ✅ Đã sửa | Xóa INSERT promotions/wash_sessions, cập nhật format data |
| `Vehicle.java` | ✅ Đã sửa | Thêm `isActive`, cập nhật constructor |
| `User.java` | ✅ Đã sửa | Xóa `loginId`, đổi tên `phoneName → phoneNumber` |
| `Reward.java` | ✅ Đã sửa | Thêm `description`, đổi tên `validFrom→startDate`, `validTo→endDate` |
| `VehicleDao.java` | ✅ Đã sửa | `getCars()` lọc active, `deleteCar()` soft delete |
| `UserDAO.java` | ✅ Đã sửa | Bỏ `login_id` khỏi mọi query, fix bug `getVehicleByPlate()` |
| `LoyaltyDAO.java` | ✅ Đã sửa | Đổi tên cột `valid_from→start_date`, `valid_to→end_date` |
| `Booking.java` | 🆕 Tạo mới | DTO cho bảng bookings (v2) với đầy đủ các trường mới |
| `my_points.jsp` | ✅ Không cần sửa | Không dùng promotions, chỉ dùng Reward/PointLog |
