# User Access Management System

# About:
This is a basic User Access Management system. 
This system allows users to sign up, request access to software applications, and enables managers to approve or reject these requests. 
The document aims to provide a clear understanding of the system's functionalities, user roles, and how they interact within the system.

# Demo link - https://drive.google.com/file/d/1IPgC5dQg3udpny2-tzFE-nCWOcVau0y9/view?usp=sharing

# How to run this project
# 1 SQL Script to create tables:
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL
);

CREATE TABLE software (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    access_levels VARCHAR(50)
);

CREATE TABLE requests (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    software_id INTEGER REFERENCES software(id),
    access_type VARCHAR(20),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);

# 2 Connect the project to the database and Deploy it to Tomcat

# 3 Open your browser and go to http://localhost:8080/UserAccessManagementSystem/login.jsp to access the login page.

