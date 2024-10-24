<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource"%>
<!DOCTYPE html>
<html>
<head>
    <title>Request Software Access</title>
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
            justify-items: center;
        }
        select, textarea {
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
        label {
            display: block;
            margin-top: 10px;
            text-align: left;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Request Software Access</h2>
    <p>Welcome, <%= session.getAttribute("username") %>!</p>
    <form action="RequestServlet" method="post">
        <label for="software_id">Software:</label>
        <select id="software_id" name="software_id">
            <%
                try {
                    Context initContext = new InitialContext();
                    Context envContext = (Context) initContext.lookup("java:/comp/env");
                    DataSource ds = (DataSource) envContext.lookup("jdbc/PostgresDB");
                    if (ds == null) {
            %><option>No DataSource found</option><%
        } else {
            Connection conn = ds.getConnection();
            String sql = "SELECT id, name FROM software";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (!rs.isBeforeFirst()) {
        %><option>No software found</option><%
        } else {
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
        %><option value="<%= id %>"><%= name %></option><%
                    }
                }
                rs.close();
                stmt.close();
                conn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        %><option>Error retrieving software</option><%
            }
        %>
        </select>
        <label for="access_type">Access Type:</label>
        <select id="access_type" name="access_type">
            <option value="Read">Read</option>
            <option value="Write">Write</option>
            <option value="Admin">Admin</option>
        </select>
        <label for="reason">Reason:</label>
        <textarea id="reason" name="reason" required></textarea>
        <input type="submit" value="Submit Request">
    </form>
</div>
</body>
</html>
