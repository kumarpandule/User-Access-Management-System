package com.UserAccessManagementSystem;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId"); // Ensure userId is stored as Integer
        if (userId == null) {
            response.sendRedirect("login.jsp"); // User not logged in, redirect to login
            return;
        }

        // Proceed with accessing parameters from the request
        String softwareIdStr = request.getParameter("software_id");
        String accessType = request.getParameter("access_type");
        String reason = request.getParameter("reason");

        try {
            int softwareId = Integer.parseInt(softwareIdStr); // Convert softwareId to integer

            // Database connection
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "root");

            // SQL insert statement
            String sql = "INSERT INTO requests (user_id, software_id, access_type, reason, status) VALUES (?, ?, ?, ?, 'Pending')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId); // Use setInt for Integer value
            stmt.setInt(2, softwareId); // Use setInt for Integer value
            stmt.setString(3, accessType);
            stmt.setString(4, reason);

            // Execute the update
            stmt.executeUpdate();
            stmt.close();
            conn.close();

            // Set a success message in session and redirect
            session.setAttribute("successMessage", "Request submitted successfully!");
            response.sendRedirect("dashboard.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle SQL exception
            response.getWriter().println("Error: " + e.getMessage());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            // Handle number format exception
            response.getWriter().println("Error: Invalid software ID format");
        }
    }
}
