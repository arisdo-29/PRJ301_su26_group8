<%@ page import="dto.User" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AutoWash Pro – Smart Car Wash</title>

    <style>
        body {
            margin:0;
            font-family:Inter,sans-serif;
            background:#F0F8FF;
        }

        .container {
            max-width:500px;
            margin:60px auto;
            background:white;
            padding:40px;
            border-radius:12px;
            box-shadow:0 2px 16px rgba(0,0,0,.08);
        }

        h2 {
            margin-bottom:24px;
            color:#1A2B3C;
        }

        .form-group {
            margin-bottom:16px;
        }

        label {
            display:block;
            font-weight:600;
            font-size:14px;
            margin-bottom:6px;
            color:#1A2B3C;
        }

        input[type=text],
        input[type=email] {
            width:100%;
            padding:10px 12px;
            border:1px solid #C9DFF0;
            border-radius:8px;
            font-size:14px;
            box-sizing:border-box;
        }

        input[readonly] {
            background:#f3f7fb;
            color:#888;
        }

        .btn {
            width:100%;
            padding:13px;
            background:#2979C8;
            color:white;
            border:none;
            border-radius:50px;
            font-size:16px;
            font-weight:700;
            cursor:pointer;
            margin-top:8px;
        }

        .btn:hover {
            background:#1B5FA3;
        }

        .back {
            display:inline-block;
            margin-bottom:20px;
            color:#2979C8;
            font-size:14px;
            text-decoration:none;
            font-weight:600;
        }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<%
    User user = (User) request.getAttribute("USER");

    if(user == null){
        response.sendRedirect("MemberDashboard.jsp");
        return;
    }
%>

<div class="container">

    <a class="back" href="MemberDashboard_page.jsp">
        &larr; Quay lại Dashboard
    </a>

    <h2>✏️ Chỉnh sửa hồ sơ</h2>

    <form action="SaveProfile" method="post">

        <div class="form-group">
            <label>User ID</label>
            <input type="text"
                   name="txtUserId"
                   value="<%= user.getId() %>"
                   readonly>
        </div>

        <div class="form-group">
            <label>Họ và tên</label>
            <input type="text"
                   name="txtFullName"
                   value="<%= user.getFullName() %>">
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email"
                   name="txtEmail"
                   value="<%= user.getEmail() %>"
                   readonly>
        </div>

        <div class="form-group">
            <label>Số điện thoại</label>
            <input type="text"
                   name="txtPhone"
                   value="<%= user.getPhoneNumber() == null ? "" : user.getPhoneNumber() %>">
        </div>

        <button class="btn" type="submit">
            Lưu thay đổi
        </button>

    </form>

</div>

</body>
</html>