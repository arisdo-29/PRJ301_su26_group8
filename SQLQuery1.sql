USE AutoWashPro;
GO

--------------------------------------------------
-- USERS
--------------------------------------------------
INSERT INTO users
(login_id, phone_number, password, role, full_name, email)
VALUES
('0911111111', '0911111111', '123456', 'CUSTOMER', N'Nguyễn Văn An', 'an@gmail.com'),
('0922222222', '0922222222', '123456', 'CUSTOMER', N'Trần Thị Bình', 'binh@gmail.com'),
('0933333333', '0933333333', '123456', 'CUSTOMER', N'Lê Minh Châu', 'chau@gmail.com'),
('0944444444', '0944444444', '123456', 'CUSTOMER', N'Phạm Quốc Dũng', 'dung@gmail.com');

--------------------------------------------------
-- VEHICLES
--------------------------------------------------
INSERT INTO vehicles
(user_id,plate,type,brand,model,color,is_primary)
VALUES
(2,'51H12345','Car','Toyota','Vios','White',1),
(3,'50F22222','Car','Hyundai','Accent','Red',1),
(4,'61A33333','Car','Kia','Seltos','Blue',1),
(5,'62B44444','Motorbike','Honda','SH','Black',1),
(6,'59A55555','Motorbike','Yamaha','Exciter','Gray',1);

--------------------------------------------------
-- LOYALTY_ACCOUNTS
--------------------------------------------------
INSERT INTO loyalty_accounts
(user_id,tier_id,points,total_points,total_spend,total_washes,tier_since,next_review)
VALUES
(2,1,120,120,500000,2,'2026-01-01','2027-01-01'),
(3,2,600,1500,2500000,6,'2026-01-01','2027-01-01'),
(4,3,1300,5000,8000000,18,'2026-01-01','2027-01-01'),
(5,1,50,50,200000,1,'2026-01-01','2027-01-01'),
(6,4,2500,12000,18000000,35,'2026-01-01','2027-01-01');

--------------------------------------------------
-- BOOKINGS
--------------------------------------------------
INSERT INTO bookings
(user_id,vehicle_id,service_id,scheduled_date,scheduled_time,status,priority)
VALUES
(2,1,1,'2026-06-01','08:00','PENDING',1),
(3,2,2,'2026-06-01','09:00','CONFIRMED',2),
(4,3,3,'2026-06-02','10:00','COMPLETED',3),
(5,4,4,'2026-06-02','11:00','PENDING',1),
(6,5,5,'2026-06-03','13:00','CONFIRMED',4);

--------------------------------------------------
-- POINT_LOGS
--------------------------------------------------
INSERT INTO point_logs
(account_id,booking_id,type,amount,balance,note)
VALUES
(1,1,'EARN',70,120,N'Basic Wash'),
(2,2,'EARN',120,600,N'Premium Wash'),
(3,3,'EARN',250,1300,N'Deluxe Wash'),
(4,4,'EARN',180,50,N'Engine Clean'),
(5,5,'EARN',200,2500,N'Interior Deep');

--------------------------------------------------
-- WASH_SESSIONS
--------------------------------------------------
INSERT INTO wash_sessions
(booking_id,vehicle_id,service_id,lpr_plate,
 started_at,ended_at,price,points_earn,discount,pay_method)
VALUES
(1,1,1,'51H12345',
 '2026-06-01 08:00','2026-06-01 08:15',
 70000,70,0,'CASH'),

(2,2,2,'50F22222',
 '2026-06-01 09:00','2026-06-01 09:30',
 120000,120,0,'MOMO'),

(3,3,3,'61A33333',
 '2026-06-02 10:00','2026-06-02 11:00',
 250000,250,10000,'CARD'),

(4,4,4,'62B44444',
 '2026-06-02 11:00','2026-06-02 11:45',
 180000,180,0,'CASH'),

(5,5,5,'59A55555',
 '2026-06-03 13:00','2026-06-03 13:50',
 200000,200,20000,'BANK');

--------------------------------------------------
-- REWARDS
--------------------------------------------------
INSERT INTO rewards
(name,type,points_cost,value,min_tier_id)
VALUES
(N'Miễn phí 1 lần rửa','FREE_WASH',1000,NULL,1),
(N'Giảm 10%','DISC_PERCENT',500,10,1),
(N'Giảm 50.000đ','DISC_VND',700,50000,2),
(N'Nâng cấp dịch vụ','FREE_UPGRADE',1200,NULL,3),
(N'Giảm 100.000đ','DISC_VND',1500,100000,4);

--------------------------------------------------
-- REDEMPTIONS
--------------------------------------------------
INSERT INTO redemptions
(account_id,reward_id,booking_id,points_spent,status)
VALUES
(1,2,1,500,'USED'),
(2,1,2,1000,'PENDING'),
(3,3,3,700,'USED'),
(4,2,4,500,'PENDING'),
(5,5,5,1500,'USED');

--------------------------------------------------
-- PROMOTIONS
--------------------------------------------------
INSERT INTO promotions
(name,description,type,value,min_tier_id,
 start_date,end_date,created_by)
VALUES
(N'Summer Sale',N'Khuyến mãi hè','PERCENT',10,1,
 '2026-06-01','2026-08-31',1),

(N'Silver Deal',N'Ưu đãi Silver','VND',50000,2,
 '2026-06-01','2026-07-31',1),

(N'Gold Deal',N'Ưu đãi Gold','PERCENT',20,3,
 '2026-06-01','2026-09-30',1),

(N'Platinum VIP',N'Ưu đãi Platinum','FREE_SERVICE',NULL,4,
 '2026-06-01','2026-12-31',1),

(N'Weekend Sale',N'Cuối tuần giảm giá','PERCENT',15,NULL,
 '2026-06-01','2026-12-31',1);

--------------------------------------------------
-- PROMOTION_SERVICES
--------------------------------------------------
INSERT INTO promotion_services
(promotion_id,service_id)
VALUES
(1,1),
(1,2),
(2,3),
(3,4),
(5,5);
GO