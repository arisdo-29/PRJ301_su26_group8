<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("USER");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<%--
    admin_page.jsp - Trang Dashboard cho Admin

    DA SUA (theo yeu cau):
    1) Truoc day tieu de chi ghi tinh "Admin Dashboard" / "Manage AutoWash
       Pro System" chung chung, khong co loi chao ca nhan hoa.
       -> Da them dong "Xin chao, <ten admin>!" (dung EL/scriptlet lay tu
          session, giong cach lam o cac trang manageReward.jsp,
          MemberDashboard_page.jsp,...) de dong bo trai nghiem nguoi dung.
    2) Dong bo font chu: them Google Fonts "Inter" giong cac trang khac
       trong he thong (truoc day trang nay dung font-family Arial mac dinh,
       khong dong bo voi giao dien chung).
--%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard - AutoWash Pro</title>

        <%-- DA SUA: them Google Fonts "Inter" de dong bo voi cac trang khac --%>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family: 'Inter', Arial, sans-serif;
        }

        body{
            background:#f4f6f9;
        }

        .container{
            width:90%;
            margin:30px auto;
        }

        .welcome{
            background:white;
            padding:24px 28px;
            border-radius:10px;
            margin-bottom:20px;
            box-shadow:0 2px 8px rgba(0,0,0,.06);
        }

        .welcome h1{
            font-size:22px;
            font-weight:800;
            color:#1A2B3C;
        }

        .welcome .sub{
            color:#718096;
            font-size:14px;
            margin-top:6px;
        }

        .cards{
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
            gap:20px;
        }

        .card{
            background:white;
            padding:25px;
            border-radius:10px;
            text-align:center;
            box-shadow:0 2px 8px rgba(0,0,0,.06);
        }

        .card h2{
            color:#2979C8;
            margin-bottom:10px;
            font-size:17px;
        }

        .card p{
            color:#718096;
            font-size:14px;
            margin-bottom:14px;
        }

        .card a{
            text-decoration:none;
            color:#2979C8;
            font-weight:700;
        }
    </style>
</head>

<body>
<jsp:include page="navbar.jsp"/>


    <div class="container">

        <%--
            DA SUA: them loi chao ca nhan hoa "Xin chao, <ten admin>!"
            EL Expression: ${sessionScope.USER.fullName}
            Tuong duong scriptlet: ((User) session.getAttribute("USER")).getFullName()
        --%>
        <div class="welcome">
            <h1>👋 Xin chào, <strong>${sessionScope.USER.fullName}</strong>!</h1>
            <p class="sub">Admin Dashboard · Quản lý hệ thống AutoWash Pro</p>
        </div>

        <div class="cards">

            <div class="card">
                <h2>👤 Users</h2>
                <p>Quản lý người dùng & đổi thưởng</p>
                <a href="UserManagementServlet">Xem ngay →</a>
            </div>

            <div class="card">
                <h2>🎁 Phần thưởng & Khuyến mãi</h2>
                <p>Quản lý phần thưởng và chương trình khuyến mãi</p>
                <a href="manageReward">Xem ngay →</a>
            </div>

        </div>

    </div>

</body>
</html>
