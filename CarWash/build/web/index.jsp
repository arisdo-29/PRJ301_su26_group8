<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>AutoWash Pro – Smart Car Wash</title>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --blue: #2979C8; --blue-dark: #1B5FA3; --blue-light: #EBF3FB;
      --orange: #F5A623; --navy: #1A2332; --white: #FFFFFF;
      --text-dark: #0D1B2A; --text-light: #718096; --green: #2ECC71; --radius: 14px;
    }
    body { font-family: 'Nunito', sans-serif; color: var(--text-dark); background: var(--white); }
    a { text-decoration: none; color: inherit; }

    /* NAVBAR */
    .navbar {
      position: sticky; top: 0; z-index: 100;
      background: var(--blue);
      display: flex; align-items: center; justify-content: space-between;
      padding: 0 3rem; height: 68px;
    }
    .navbar-brand { display: flex; align-items: center; gap: 10px; font-size: 1.2rem; font-weight: 800; color: var(--white); }
    .brand-icon { width: 40px; height: 40px; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
    .navbar-links { display: flex; align-items: center; gap: 2rem; }
    .navbar-links a { color: var(--white); font-weight: 600; font-size: 0.95rem; opacity: 0.9; transition: opacity .2s; }
    .navbar-links a:hover { opacity: 1; }
    .navbar-actions { display: flex; gap: 0.75rem; }
    .btn-outline-white { padding: 0.45rem 1.3rem; border: 2px solid var(--white); border-radius: 50px; color: var(--white); font-weight: 700; font-size: 0.9rem; background: transparent; cursor: pointer; transition: background .2s, color .2s; }
    .btn-outline-white:hover { background: var(--white); color: var(--blue); }
    .btn-white { padding: 0.45rem 1.3rem; border: 2px solid var(--white); border-radius: 50px; color: var(--blue); font-weight: 700; font-size: 0.9rem; background: var(--white); cursor: pointer; }

    /* HERO */
    .hero { background: var(--blue); min-height: calc(100vh - 68px); display: flex; align-items: center; padding: 3rem; position: relative; overflow: hidden; }
    .hero-content { flex: 1; max-width: 560px; z-index: 2; }
    .hero-badge { display: inline-flex; align-items: center; gap: 6px; background: rgba(255,255,255,0.18); border: 1px solid rgba(255,255,255,0.35); padding: 6px 14px; border-radius: 50px; color: var(--white); font-size: 0.85rem; font-weight: 600; margin-bottom: 1.5rem; }
    .hero h1 { font-size: clamp(2.4rem, 5vw, 3.2rem); font-weight: 900; line-height: 1.1; color: var(--white); margin-bottom: 1.2rem; }
    .hero p { font-size: 1.05rem; color: rgba(255,255,255,0.85); line-height: 1.7; margin-bottom: 2rem; max-width: 440px; }
    .hero-btns { display: flex; gap: 1rem; flex-wrap: wrap; margin-bottom: 3rem; }
    .btn-hero-primary { padding: 0.85rem 1.8rem; background: var(--white); color: var(--blue); border: none; border-radius: 50px; font-weight: 800; font-size: 1rem; cursor: pointer; transition: transform .15s, box-shadow .15s; }
    .btn-hero-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,.15); }
    .btn-hero-secondary { padding: 0.85rem 1.8rem; background: transparent; color: var(--white); border: 2px solid rgba(255,255,255,.6); border-radius: 50px; font-weight: 700; font-size: 1rem; cursor: pointer; }
    .hero-stats { display: flex; gap: 2.5rem; }
    .stat-val { font-size: 1.8rem; font-weight: 900; color: var(--white); }
    .stat-lbl { font-size: 0.8rem; color: rgba(255,255,255,.75); margin-top: 2px; }
    .hero-car { flex: 1; display: flex; align-items: center; justify-content: center; z-index: 2; }
    .car-svg { width: min(420px, 90%); }
    .drop { position: absolute; border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%; background: rgba(255,255,255,0.25); animation: float 3s ease-in-out infinite; }
    @keyframes float { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-12px); } }

    /* PROMO BANNER */
    .promo-banner { background: var(--orange); text-align: center; padding: 0.85rem 1rem; font-size: 0.95rem; font-weight: 600; color: var(--text-dark); }
    .promo-banner a { color: var(--blue-dark); font-weight: 800; margin-left: 4px; }

    /* SERVICES */
    .services { background: var(--blue-light); padding: 5rem 3rem; }
    .section-tag { text-align: center; font-size: 0.8rem; font-weight: 800; letter-spacing: .12em; text-transform: uppercase; color: var(--blue); margin-bottom: 0.6rem; }
    .section-title { text-align: center; font-size: clamp(1.6rem, 3vw, 2.2rem); font-weight: 900; color: var(--text-dark); margin-bottom: 0.6rem; }
    .section-sub { text-align: center; color: var(--text-light); font-size: 0.95rem; margin-bottom: 2.5rem; }
    .services-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1.25rem; max-width: 1100px; margin: 0 auto; }
    .service-card { background: var(--white); border-radius: var(--radius); padding: 1.6rem; position: relative; box-shadow: 0 2px 12px rgba(0,0,0,.06); transition: transform .2s, box-shadow .2s; }
    .service-card:hover { transform: translateY(-4px); box-shadow: 0 8px 28px rgba(0,0,0,.1); }
    .popular-badge { position: absolute; top: 1rem; right: 1rem; background: var(--blue); color: var(--white); font-size: 0.72rem; font-weight: 800; padding: 3px 10px; border-radius: 50px; }
    .service-icon { width: 52px; height: 52px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 1rem; }
    .icon-blue { background: #EBF3FB; } .icon-green { background: #E8F8EF; } .icon-yellow { background: #FEF9E7; } .icon-purple { background: #F3EFFE; }
    .service-card h3 { font-size: 1.05rem; font-weight: 800; margin-bottom: 0.5rem; }
    .service-card p { font-size: 0.85rem; color: var(--text-light); line-height: 1.6; margin-bottom: 1rem; }
    .service-footer { display: flex; align-items: center; justify-content: space-between; }
    .service-price { font-size: 1.15rem; font-weight: 900; color: var(--blue); }
    .btn-book { padding: 0.5rem 1.2rem; background: var(--blue); color: var(--white); border: none; border-radius: 50px; font-weight: 700; font-size: 0.85rem; cursor: pointer; }
    .btn-book:hover { background: var(--blue-dark); }

    /* WHY US */
    .why-us { background: var(--blue); padding: 5rem 3rem; }
    .why-us .section-title { color: var(--white); }
    .why-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1.5rem; max-width: 1000px; margin: 2.5rem auto 0; }
    .why-card { background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,.2); border-radius: var(--radius); padding: 2rem 1.5rem; text-align: center; }
    .why-icon { font-size: 2.2rem; margin-bottom: 1rem; display: block; }
    .why-card h3 { font-size: 1rem; font-weight: 800; color: var(--white); margin-bottom: 0.6rem; }
    .why-card p { font-size: 0.85rem; color: rgba(255,255,255,.75); line-height: 1.6; }

    /* JOIN CTA */
    .join-section { background: var(--blue-light); padding: 4rem 3rem; }
    .join-card { max-width: 780px; margin: 0 auto; background: var(--white); border-radius: 18px; padding: 3rem 2rem; text-align: center; box-shadow: 0 4px 24px rgba(0,0,0,.07); }
    .join-card h2 { font-size: 1.8rem; font-weight: 900; margin-bottom: 0.6rem; }
    .join-card > p { color: var(--text-light); font-size: 0.95rem; margin-bottom: 1.5rem; }
    .join-perks { display: flex; flex-wrap: wrap; justify-content: center; gap: 1.2rem; margin-bottom: 2rem; }
    .perk { display: flex; align-items: center; gap: 6px; font-size: 0.9rem; font-weight: 600; }
    .perk-check { color: var(--green); font-size: 1.1rem; }
    .btn-cta { padding: 0.9rem 2.5rem; background: var(--blue); color: var(--white); border: none; border-radius: 50px; font-weight: 800; font-size: 1rem; cursor: pointer; }
    .btn-cta:hover { background: var(--blue-dark); }

    /* FOOTER */
    .footer { background: var(--navy); color: rgba(255,255,255,.65); padding: 3.5rem 3rem 2rem; }
    .footer-grid { display: grid; grid-template-columns: 1.5fr 1fr 1fr; gap: 2rem; max-width: 1100px; margin: 0 auto 2rem; }
    .footer-brand { display: flex; align-items: center; gap: 10px; margin-bottom: 1rem; }
    .footer-brand span { font-size: 1.05rem; font-weight: 800; color: var(--white); }
    .footer p { font-size: 0.85rem; line-height: 1.7; }
    .footer h4 { color: var(--white); font-weight: 800; font-size: 0.95rem; margin-bottom: 1rem; }
    .footer ul { list-style: none; display: flex; flex-direction: column; gap: 0.6rem; }
    .footer ul li a { font-size: 0.85rem; color: rgba(255,255,255,.6); transition: color .2s; }
    .footer ul li a:hover { color: var(--white); }
    .contact-item { display: flex; align-items: center; gap: 8px; font-size: 0.85rem; margin-bottom: 0.7rem; }
    .footer-bottom { border-top: 1px solid rgba(255,255,255,.1); padding-top: 1.5rem; text-align: center; font-size: 0.8rem; color: rgba(255,255,255,.35); max-width: 1100px; margin: 0 auto; }
  </style>
</head>
<body>

<%
    // Nếu user đã login thì redirect thẳng vào dashboard
    User loggedIn = (User) session.getAttribute("USER");
    if (loggedIn != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
%>

<!-- NAVBAR -->
<nav class="navbar">
  <a href="index.jsp" class="navbar-brand">
    <div class="brand-icon">💧</div>
    AutoWash Pro
  </a>
  <div class="navbar-links">
    <a href="#hero">Trang chủ</a>
    <a href="#services">Dịch vụ</a>
  </div>
  <div class="navbar-actions">
    <a href="login_page.jsp"><button class="btn-outline-white">Đăng nhập</button></a>
    <a href="register_page.jsp"><button class="btn-white">Đăng ký</button></a>
  </div>
</nav>

<!-- HERO -->
<section class="hero" id="hero">
  <div class="drop" style="width:18px;height:22px;top:22%;left:58%;animation-delay:.4s"></div>
  <div class="drop" style="width:12px;height:15px;top:35%;left:72%;animation-delay:.9s"></div>
  <div class="drop" style="width:10px;height:13px;top:55%;left:65%;animation-delay:.2s"></div>
  <div class="drop" style="width:14px;height:18px;top:18%;left:85%;animation-delay:1.1s"></div>

  <div class="hero-content">
    <div class="hero-badge">⭐ Dịch vụ rửa xe chuyên nghiệp &nbsp;·&nbsp; 4.9★</div>
    <h1>Smart Car Wash,<br>Anytime.</h1>
    <p>Đặt lịch rửa xe online, tích điểm thành viên, nhận ưu đãi hấp dẫn mỗi ngày.</p>
    <div class="hero-btns">
      <a href="register_page.jsp"><button class="btn-hero-primary">Đăng ký miễn phí &rarr;</button></a>
      <a href="#services"><button class="btn-hero-secondary">Xem dịch vụ</button></a>
    </div>
    <div class="hero-stats">
      <div><div class="stat-val">5,000+</div><div class="stat-lbl">Khách hàng</div></div>
      <div><div class="stat-val">12</div><div class="stat-lbl">Chi nhánh</div></div>
      <div><div class="stat-val">50k+</div><div class="stat-lbl">Lượt rửa</div></div>
    </div>
  </div>

  <div class="hero-car">
    <svg class="car-svg" viewBox="0 0 460 280" fill="none" xmlns="http://www.w3.org/2000/svg">
      <ellipse cx="230" cy="258" rx="170" ry="14" fill="rgba(0,0,0,0.18)"/>
      <rect x="50" y="155" width="360" height="90" rx="18" fill="#E8F4FF"/>
      <path d="M120 155 C130 100 160 75 200 72 L280 72 C320 72 345 100 350 155 Z" fill="#DDEEFF"/>
      <path d="M138 150 C144 108 164 88 198 86 L234 86 L234 150 Z" fill="#B8D8F5" opacity=".8"/>
      <path d="M246 86 L282 86 C316 88 334 108 342 150 L246 150 Z" fill="#B8D8F5" opacity=".8"/>
      <rect x="238" y="86" width="6" height="64" rx="3" fill="#A0C8EE"/>
      <line x1="238" y1="160" x2="238" y2="238" stroke="#C5DCEE" stroke-width="2"/>
      <ellipse cx="130" cy="248" rx="52" ry="52" fill="#1a2332"/>
      <ellipse cx="130" cy="248" rx="38" ry="38" fill="#2d3a4a"/>
      <ellipse cx="130" cy="248" rx="24" ry="24" fill="#1a2332"/>
      <ellipse cx="130" cy="248" rx="10" ry="10" fill="#4a5568"/>
      <line x1="130" y1="224" x2="130" y2="272" stroke="#4a5568" stroke-width="3"/>
      <line x1="106" y1="248" x2="154" y2="248" stroke="#4a5568" stroke-width="3"/>
      <line x1="113" y1="231" x2="147" y2="265" stroke="#4a5568" stroke-width="2"/>
      <line x1="147" y1="231" x2="113" y2="265" stroke="#4a5568" stroke-width="2"/>
      <ellipse cx="330" cy="248" rx="52" ry="52" fill="#1a2332"/>
      <ellipse cx="330" cy="248" rx="38" ry="38" fill="#2d3a4a"/>
      <ellipse cx="330" cy="248" rx="24" ry="24" fill="#1a2332"/>
      <ellipse cx="330" cy="248" rx="10" ry="10" fill="#4a5568"/>
      <line x1="330" y1="224" x2="330" y2="272" stroke="#4a5568" stroke-width="3"/>
      <line x1="306" y1="248" x2="354" y2="248" stroke="#4a5568" stroke-width="3"/>
      <line x1="313" y1="231" x2="347" y2="265" stroke="#4a5568" stroke-width="2"/>
      <line x1="347" y1="231" x2="313" y2="265" stroke="#4a5568" stroke-width="2"/>
      <rect x="54" y="172" width="28" height="16" rx="8" fill="#FFE066"/>
      <rect x="378" y="172" width="28" height="16" rx="8" fill="#FF6B6B"/>
      <rect x="158" y="196" width="24" height="6" rx="3" fill="#A0C8EE"/>
      <rect x="268" y="196" width="24" height="6" rx="3" fill="#A0C8EE"/>
      <circle cx="68" cy="120" r="5" fill="rgba(255,255,255,0.5)">
        <animate attributeName="cy" values="120;140;120" dur="2.5s" repeatCount="indefinite"/>
        <animate attributeName="opacity" values="0.5;0;0.5" dur="2.5s" repeatCount="indefinite"/>
      </circle>
      <circle cx="390" cy="100" r="4" fill="rgba(255,255,255,0.4)">
        <animate attributeName="cy" values="100;125;100" dur="3s" repeatCount="indefinite"/>
        <animate attributeName="opacity" values="0.4;0;0.4" dur="3s" repeatCount="indefinite"/>
      </circle>
      <text x="390" y="75" font-size="20" fill="#FFD700">✦</text>
    </svg>
  </div>
</section>

<!-- PROMO BANNER -->
<div class="promo-banner">
  🎉 Thành viên mới được <strong>rửa xe miễn phí</strong> + 200 điểm thưởng!
  <a href="register_page.jsp">Đăng ký ngay &rarr;</a>
</div>

<!-- SERVICES -->
<section class="services" id="services">
  <p class="section-tag">Dịch vụ</p>
  <h2 class="section-title">Chọn gói rửa xe phù hợp</h2>
  <p class="section-sub">Dịch vụ chuyên nghiệp cho mọi nhu cầu và ngân sách</p>
  <div class="services-grid">
    <div class="service-card">
      <div class="service-icon icon-blue">💧</div>
      <h3>Basic Wash</h3>
      <p>Rửa ngoại thất, tráng nước và lau khô. Phù hợp dùng hàng tuần.</p>
      <div class="service-footer"><span class="service-price">50.000đ</span><button class="btn-book">Đặt lịch</button></div>
    </div>
    <div class="service-card">
      <span class="popular-badge">Phổ biến</span>
      <div class="service-icon icon-green">🌀</div>
      <h3>Wash + Vacuum</h3>
      <p>Rửa ngoại thất + hút bụi nội thất và lau tấm taplo.</p>
      <div class="service-footer"><span class="service-price">80.000đ</span><button class="btn-book">Đặt lịch</button></div>
    </div>
    <div class="service-card">
      <div class="service-icon icon-yellow">✨</div>
      <h3>Premium Polish</h3>
      <p>Rửa toàn diện + đánh bóng + phủ wax carnauba bảo vệ sơn.</p>
      <div class="service-footer"><span class="service-price">150.000đ</span><button class="btn-book">Đặt lịch</button></div>
    </div>
    <div class="service-card">
      <div class="service-icon icon-purple">🛡️</div>
      <h3>Nano Coating</h3>
      <p>Phủ nano ceramic bảo vệ sơn 12 tháng, chống UV và bám nước.</p>
      <div class="service-footer"><span class="service-price">200.000đ</span><button class="btn-book">Đặt lịch</button></div>
    </div>
  </div>
</section>

<!-- WHY US -->
<section class="why-us">
  <h2 class="section-title">Tại sao chọn AutoWash Pro?</h2>
  <div class="why-grid">
    <div class="why-card"><span class="why-icon">⚡</span><h3>Nhanh 30 phút</h3><p>Tiết kiệm thời gian — ra vào nhanh gọn.</p></div>
    <div class="why-card"><span class="why-icon">🛡️</span><h3>Bảo hiểm toàn phần</h3><p>Mỗi lần rửa đều được bảo hiểm. Rủi ro bằng 0.</p></div>
    <div class="why-card"><span class="why-icon">♻️</span><h3>Thân thiện môi trường</h3><p>Tiết kiệm 80% nước nhờ hệ thống tái chế thông minh.</p></div>
  </div>
</section>

<!-- JOIN CTA -->
<section class="join-section">
  <div class="join-card">
    <h2>Tham gia AutoWash Pro Club</h2>
    <p>Tích điểm mỗi lần rửa xe, đổi ưu đãi hấp dẫn và leo hạng Platinum.</p>
    <div class="join-perks">
      <div class="perk"><span class="perk-check">✅</span> Rửa xe miễn phí lần đầu</div>
      <div class="perk"><span class="perk-check">✅</span> Tích điểm thưởng</div>
      <div class="perk"><span class="perk-check">✅</span> Giảm giá thành viên</div>
      <div class="perk"><span class="perk-check">✅</span> Đặt lịch ưu tiên</div>
    </div>
    <a href="register_page.jsp"><button class="btn-cta">Tạo tài khoản miễn phí</button></a>
  </div>
</section>

<!-- FOOTER -->
<footer class="footer">
  <div class="footer-grid">
    <div>
      <div class="footer-brand"><div class="brand-icon">💧</div><span>AutoWash Pro</span></div>
      <p>Dịch vụ rửa xe tự động với đặt lịch thông minh và chương trình tích điểm.</p>
    </div>
    <div>
      <h4>Liên kết nhanh</h4>
      <ul>
        <li><a href="#hero">Trang chủ</a></li>
        <li><a href="#services">Dịch vụ</a></li>
        <li><a href="login_page.jsp">Đăng nhập</a></li>
        <li><a href="register_page.jsp">Đăng ký</a></li>
      </ul>
    </div>
    <div>
      <h4>Liên hệ</h4>
      <div class="contact-item"><span>📞</span> 028 1234 5678</div>
      <div class="contact-item"><span>✉️</span> hello@autowashpro.vn</div>
      <div class="contact-item"><span>📍</span> TP. Hồ Chí Minh</div>
    </div>
  </div>
  <div class="footer-bottom">&copy; 2026 AutoWash Pro. All rights reserved.</div>
</footer>

</body>
</html>
