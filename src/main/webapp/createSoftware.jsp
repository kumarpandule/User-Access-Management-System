<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Software</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 400px;
            text-align: center;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .message {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Create Software</h1>
    <form action="SoftwareServlet" method="post">
        <label for="name">Software Name:</label>
        <input type="text" id="name" name="name" required><br>
        <label for="description">Description:</label>
        <textarea id="description" name="description"></textarea><br>
        <label for="access_levels">Access Levels:</label>
        <input type="text" id="access_levels" name="access_levels" required><br>
        <input type="submit" value="Create Software">
    </form>
    <div class="message">
        <% String message = (String) request.getAttribute("message"); %>
        <%= message != null ? message : "" %>
    </div>
</div>
</body>
</html>
