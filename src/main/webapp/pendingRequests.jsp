<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.DataSource"%>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Access Requests</title>
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
            width: 80%;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        button {
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .approve {
            background-color: #4CAF50;
            color: white;
        }
        .reject {
            background-color: #f44336;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Pending Access Requests</h2>
    <table>
        <tr>
            <th>Employee</th>
            <th>Software</th>
            <th>Access Type</th>
            <th>Reason</th>
            <th>Action</th>
        </tr>
        <%
            try {
                Context initContext = new InitialContext();
                Context envContext = (Context) initContext.lookup("java:/comp/env");
                DataSource ds = (DataSource) envContext.lookup("jdbc/PostgresDB");
                Connection conn = ds.getConnection();
                String sql = "SELECT requests.id, users.username, software.name, requests.access_type, requests.reason FROM requests JOIN users ON requests.user_id = users.id JOIN software ON requests.software_id = software.id WHERE requests.status = 'Pending'";
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    int requestId = rs.getInt("id");
                    String employee = rs.getString("username");
                    String software = rs.getString("name");
                    String accessType = rs.getString("access_type");
                    String reason = rs.getString("reason");
        %>
        <tr>
            <td><%= employee %></td>
            <td><%= software %></td>
            <td><%= accessType %></td>
            <td><%= reason %></td>
            <td>
                <form action="ApprovalServlet" method="post">
                    <input type="hidden" name="request_id" value="<%= requestId %>">
                    <button type="submit" name="action" value="approve" class="approve">Approve</button>
                    <button type="submit" name="action" value="reject" class="reject">Reject</button>
                </form>
            </td>
        </tr>
        <%
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <tr>
            <td colspan="5">Error retrieving requests.</td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
