package com.UserAccessManagementSystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class ApprovalServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestIdStr = request.getParameter("request_id");
        String action = request.getParameter("action"); // "approve" or "reject"
        String status = action.equals("approve") ? "Approved" : "Rejected";

        try {
            int requestId = Integer.parseInt(requestIdStr); // Convert requestId to integer

            // Database connection
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "root");

            // Update the request status based on the manager's action
            String sql = "UPDATE requests SET status = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, requestId); // Use setInt for Integer value
            stmt.executeUpdate();
            stmt.close();

            // Check if there are any pending requests left
            sql = "SELECT COUNT(*) FROM requests WHERE status = 'Pending'";
            stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            rs.next();
            int pendingCount = rs.getInt(1);
            rs.close();
            stmt.close();
            conn.close();

            // Redirect based on the number of pending requests
            if (pendingCount == 0) {
                response.sendRedirect("dashboard.jsp"); // Redirect to dashboard if no pending requests
            } else {
                response.sendRedirect("pendingRequests.jsp"); // Otherwise, reload pending requests page
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
