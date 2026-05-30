<%-- 
    Document   : register_page
    Created on : May 29, 2026, 9:18:14 PM
    Author     : NKLT
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>AutoWash Pro</title>

    <style>

        /* =========================
           GLOBAL
        ========================== */

        body {
            margin: 0;
            background: #F0F8FF;
            font-family: Inter, sans-serif;
        }

        .wrapper {
            min-height: 100vh;
            display: flex;
        }

        /* =========================
           LEFT PANEL
        ========================== */

        .left {
            flex: 1;
            background: #1A8FE3;
            color: white;
            padding: 60px;
        }

        .left h1 {
            font-size: 40px;
        }

        .benefit {
            margin-top: 25px;
        }

        .benefit li {
            margin-bottom: 15px;
        }

        .illustration {
            font-size: 140px;
            margin-top: 50px;
            text-align: center;
        }

        /* =========================
           RIGHT PANEL
        ========================== */

        .right {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .card {
            width: 500px;
            padding: 40px;
            background: white;
            border: 1px solid #C9DFF0;
            border-radius: 10px;
        }

        .card h2 {
            margin-bottom: 25px;
        }

        /* =========================
           FORM
        ========================== */

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        input,
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #C9DFF0;
            border-radius: 8px;
            box-sizing: border-box;
        }

        .input-error {
            border: 1px solid #E53E3E;
        }

        .error {
            margin-top: 5px;
            color: #E53E3E;
            font-size: 13px;
        }

        /* =========================
           BUTTON
        ========================== */

        .btn {
            width: 100%;
            border: none;
            padding: 14px;
            cursor: pointer;
            font-weight: 600;
            color: white;
            background: #1A8FE3;
            border-radius: 24px;
        }

        .login-link {
            margin-top: 20px;
            text-align: center;
        }

        .login-link a {
            color: #1A8FE3;
            text-decoration: none;
        }

        /* =========================
           RESPONSIVE
        ========================== */

        @media (max-width: 900px) {

            .wrapper {
                flex-direction: column;
            }

            .left {
                display: none;
            }

            .card {
                width: 90%;
            }
        }

    </style>

</head>

<body>

    <div class="wrapper">

        <!-- LEFT SIDE -->

        <div class="left">

            <h1>AutoWash Pro</h1>

            <ul class="benefit">
                <li>✔ Easy online booking</li>
                <li>✔ Save vehicle information</li>
                <li>✔ Loyalty rewards program</li>
                <li>✔ Fast and secure service</li>
            </ul>

            <div class="illustration">
                🚗
            </div>

        </div>

        <!-- RIGHT SIDE -->

        <div class="right">

            <div class="card">

                <h2>Create Account</h2>

                <form action="register" method="post" accept-charset="UTF-8">

                    <div class="form-group">
                        <label>Full Name</label>
                        <input
                            type="text"
                            name="txtfullName"
                            placeholder="Enter full name"
                            required>
                    </div>

                    <div class="form-group">

                        <label>Email</label>

                        <input
                            type="email"
                            name="txtemail"
                            placeholder="Enter email"
                            class="${not empty emailError ? 'input-error' : ''}"
                            value="${param.email}"
                            required>

                        <c:if test="${not empty emailError}">
                            <div class="error">
                                ${emailError}
                            </div>
                        </c:if>

                    </div>

                    <div class="form-group">
                        <label>Password</label>

                        <input
                            type="password"
                            name="txtpassword"
                            placeholder="Enter password"
                            required>
                    </div>

                    <div class="form-group">
                        <label>Confirm Password</label>

                        <input
                            type="password"
                            name="txtconfirmPassword"
                            placeholder="Confirm password"
                            required>
                    </div>

                    <div class="form-group">
                        <label>License Plate (Optional)</label>

                        <input
                            type="text"
                            name="licensePlate"
                            placeholder="51A-12345">
                    </div>

                    <div class="form-group">

                        <label>Vehicle Type</label>

                        <select name="vehicleType">

                            <option value="">
                                Select Vehicle
                            </option>

                            <option value="Motorbike">
                                Motorbike
                            </option>

                            <option value="Car">
                                Car
                            </option>

                            <option value="SUV">
                                SUV
                            </option>

                            <option value="Truck">
                                Truck
                            </option>

                        </select>

                    </div>

                    <button class="btn" type="submit">
                        Create Account
                    </button>

                </form>

                <div class="login-link">

                    Already have an account?

                    <a href="login.jsp">
                        Login
                    </a>

                </div>

            </div>

        </div>

    </div>

</body>

</html>