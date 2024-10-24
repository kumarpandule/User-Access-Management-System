package com.UserAccessManagementSystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class LoginServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(LoginServlet.class);
    private DataSource dataSource;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/PostgresDB");
        } catch (NamingException e) {
            logger.error("DataSource lookup failed", e);
            throw new ServletException("DataSource lookup failed", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            response.getWriter().println("Username and password cannot be empty.");
            return;
        }

        try (Connection conn = dataSource.getConnection()) {
            String sql = "SELECT id, password, role FROM users WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (BCrypt.checkpw(password, storedPassword)) {
                    int userId = rs.getInt("id");
                    String role = rs.getString("role");
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);
                    session.setAttribute("userId", userId);

                    logger.info("User {} logged in as {}", username, role);

                    response.sendRedirect("dashboard.jsp");
                } else {
                    response.getWriter().println("Invalid credentials!");
                }
            } else {
                response.getWriter().println("Invalid credentials!");
            }
        } catch (Exception e) {
            logger.error("Error during login process", e);
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
