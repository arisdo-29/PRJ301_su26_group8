<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AutoWash Pro – Smart Car Wash</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #1A8FE3 0%, #0D5BA8 100%);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .page-body {
                max-width: 420px;
                width: 100%;
                padding: 0 20px;
            }

            .page-body h2 {
                text-align: center;
                margin-bottom: 8px;
                color: white;
                font-size: 28px;
                font-weight: 600;
            }

            .page-body .subtitle {
                text-align: center;
                color: rgba(255,255,255,0.8);
                font-size: 15px;
                margin-bottom: 30px;
            }

            .page-body .msg {
                text-align: center;
                color: #ff6b6b;
                font-size: 14px;
                margin-top: 16px;
                display: none;
            }

            .page-body .msg:not(:empty) {
                display: block;
            }

            .icon-box {
                text-align: center;
                margin-bottom: 20px;
                font-size: 48px;
                animation: bounce 2s infinite;
            }

            @keyframes bounce {
                0%, 100% { transform: translateY(0); }
                50% { transform: translateY(-10px); }
            }

            .card {
                background-color: white;
                border-radius: 12px;
                padding: 40px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.15);
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                font-size: 14px;
                color: #333;
            }

            .form-group input {
                width: 100%;
                padding: 12px 14px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s ease;
                font-family: inherit;
            }

            .form-group input:focus {
                outline: none;
                border-color: #1A8FE3;
                box-shadow: 0 0 0 3px rgba(26, 143, 227, 0.1);
            }

            .form-group input::placeholder {
                color: #999;
            }

            
            .btn {
                display: block;
                width: 100%;
                padding: 14px;
                background: linear-gradient(135deg, #1A8FE3 0%, #0D5BA8 100%);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                text-align: center;
                transition: all 0.3s ease;
                margin-top: 10px;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(26, 143, 227, 0.3);
            }

            
            .link-row {
                text-align: center;
                margin-top: 20px;
                font-size: 14px;
                color: rgba(255,255,255,0.8);
            }

            .link-row a {
                color: #ffd700;
                font-weight: 600;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .link-row a:hover {
                color: white;
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="page-body" id="login">

            <div class="icon-box">&#128167;</div>
            <h2>Chào mừng quay trở lại!</h2>
            <p class="subtitle">Đăng nhập vào tài khoản AutoWash Pro của bạn</p>

            <div class="card">
                <form action="login" method="post">

                    <div class="form-group">
                        <label>Email</label>
                        <input type="text" name="txtemail" placeholder="Nhập email của bạn" required="">
                    </div>

                    <div class="form-group">
                        <label>Mật khẩu</label>
                        <input type="password" name="txtpassword" placeholder="Nhập mật khẩu" required="">
                    </div>

                    <button type="submit" class="btn" value="login">Đăng nhập</button>
                </form>
            </div>

            <p class="link-row">Bạn chưa có tài khoản? <a href="register_page.jsp">Tạo tài khoản miễn phí</a></p>
            <p class="msg">
            <%
            String msg = (String) request.getAttribute("ERROR");
            if (msg != null)
                out.print(msg);
            %>
            </p>

        </div>
      
    </body>
</html>
