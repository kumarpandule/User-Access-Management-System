<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource"%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
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
            width: 600px;
            text-align: center;
        }
        .button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 10px;
        }
        .button:hover {
            background-color: #45a049;
        }
        .software-list, .request-list {
            margin-top: 20px;
            text-align: left;
        }
        .logout {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Dashboard</h2>
    <p>Welcome, <%= session.getAttribute("username") %>!</p>
    <p>Role: <%= session.getAttribute("role") %></p>
    <%
        String role = (String) session.getAttribute("role");
        if (role != null) {
    %>
    <%
        if ("Employee".equals(role)) {
    %>
    <button class="button" onclick="location.href='requestAccess.jsp'">Request Software Access</button>
    <div class="request-list">
        <h3>Your Access Requests</h3>
        <ul>
            <%
                try {
                    Context initContext = new InitialContext();
                    Context envContext = (Context) initContext.lookup("java:/comp/env");
                    DataSource ds = (DataSource) envContext.lookup("jdbc/PostgresDB");
                    Connection conn = ds.getConnection();
                    String sql = "SELECT software.name, requests.access_type, requests.status FROM requests JOIN software ON requests.software_id = software.id WHERE requests.user_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, (Integer) session.getAttribute("userId"));
                    ResultSet rs = stmt.executeQuery();
                    if (!rs.isBeforeFirst()) {
            %><li>No requests found</li><%
        } else {
            while (rs.next()) {
                String softwareName = rs.getString("name");
                String accessType = rs.getString("access_type");
                String status = rs.getString("status");
        %><li><%= softwareName %> - <%= accessType %> - <%= status %></li><%
                }
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        %><li>Error retrieving requests</li><%
            }
        %>
        </ul>
    </div>
    <%
    } else if ("Manager".equals(role)) {
    %>
    <button class="button" onclick="location.href='pendingRequests.jsp'">View Pending Requests</button>
    <%
    } else if ("Admin".equals(role)) {
    %>
    <button class="button" onclick="location.href='createSoftware.jsp'">Add New Software</button>
    <div class="software-list">
        <h3>All Software</h3>
        <ul>
            <%
                try {
                    Context initContext = new InitialContext();
                    Context envContext = (Context) initContext.lookup("java:/comp/env");
                    DataSource ds = (DataSource) envContext.lookup("jdbc/PostgresDB");
                    Connection conn = ds.getConnection();
                    String sql = "SELECT id, name FROM software";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery();
                    if (!rs.isBeforeFirst()) {
            %><li>No software found</li><%
        } else {
            while (rs.next()) {
                String softwareName = rs.getString("name");
        %><li><%= softwareName %></li><%
                }
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        %><li>Error retrieving software</li><%
            }
        %>
        </ul>
    </div>
    <%
        }
    %>
    <div class="logout">
        <form action="LogoutServlet" method="post">
            <input type="submit" value="Logout" class="button">
        </form>
    </div>
    <%
        } else {
            // If role is null, which means the user might not be logged in
            response.sendRedirect("login.jsp");
        }
    %>
</div>
</body>
</html>
