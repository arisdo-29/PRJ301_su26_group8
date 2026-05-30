
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login-AutoWashPro</title>
        <style>
            
            .page-body {
                max-width: 400px;
                margin: 50px auto;
                padding: 0 16px;
            }

            .page-body h2 {
                text-align: center;
                margin-bottom: 4px;
            }

            .page-body .subtitle {
                text-align: center;
                color: #666;
                font-size: 14px;
                margin-bottom: 24px;
            }
            .page-body .msg{
                text-align: center;
                color: #FF3300;
                font-size: 14px;
                margin-bottom: 24px;
            }

            .divider {
                height: 1px;
                background: #eee;
                margin: 16px 0;
            }

            .icon-box {
                text-align: center;
                margin-bottom: 14px;
                font-size: 36px;
            }
            .card {
                background-color: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            }
            .form-group {
                margin-bottom: 16px;
            }

            .form-group label {
                display: block;
                font-weight: bold;
                margin-bottom: 6px;
                font-size: 14px;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                box-sizing: border-box;
            }

            /* ===== BUTTONS ===== */
            .btn {
                display: block;
                width: 100%;
                padding: 12px;
                background-color: #1a7fc1;
                color: white;
                border: none;
                border-radius: 25px;
                font-size: 16px;
                cursor: pointer;
                text-align: center;
            }

            .btn:hover {
                background-color: #1566a0;
            }
            /* ===== LINK ROW ===== */
            .link-row {
                text-align: center;
                margin-top: 14px;
                font-size: 14px;
                color: #555;
            }

            .link-row a {
                color: #1a7fc1;
                font-weight: bold;
                text-decoration: none;
            }
        </style>
    </head>
    <body>

        <div class="page-body" id="login">

            <div class="icon-box">&#128167;</div>
            <h2>Welcome Back</h2>
            <p class="subtitle">Sign in to your AutoWash Pro account</p>

            <div class="card">
                <form action="login" method="post">

                    <div class="form-group">
                        <label>Your email</label>
                        <input type="text" name="txtemail" placeholder="abc@gmail.com" required="">
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="txtpassword" placeholder="Enter your password" required="">
                    </div>

                    <div class="divider"></div>

                    <button type="submit" class="btn" value="login">Sign In</button>
                </form>
            </div>

            <p class="link-row">Don't have an account? <a href="register_page.jsp">Create one free</a></p>
            <p class="msg"><%
            String msg = (String) request.getAttribute("ERROR");
            if (msg != null)
                out.print(msg);
            %></p>

        </div>



        
        
    </body>
</html>
