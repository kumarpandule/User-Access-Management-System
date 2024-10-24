package com.UserAccessManagementSystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class SignUpServlet extends HttpServlet {
    private static final Logger logger = LogManager.getLogger(SignUpServlet.class);
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
            logger.warn("Username or password is empty");
            response.getWriter().println("Username and password cannot be empty.");
            return;
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        try (Connection conn = dataSource.getConnection()) {
            String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'Employee')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);
            stmt.executeUpdate();
            logger.info("User {} registered successfully", username);
            response.sendRedirect("login.jsp");
        } catch (Exception e) {
            logger.error("Error during user registration", e);
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
