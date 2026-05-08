# Flutter Web + .NET Backend Dashboard

Welcome to the full-stack admin dashboard project! This repository contains a complete, functional web application with a **Flutter Web** frontend and a **.NET 8** backend API connected to a **PostgreSQL (Neon)** database. 

## 🚀 Project Overview
This project is an **Admin Dashboard** application with role-based access control. It features:
- Secure JWT-based Authentication (Login/Register).
- A sleek, fully responsive Flutter Web UI with the extremely cute **Nunito** font.
- Role-based views: Regular users see a standard dashboard, while Admins see an "Admin Dashboard".
- Admins have access to a complete user list and can **click to update any user's personal details**.

## 📁 Repository Structure
- **`/flutter_web_app`**: The frontend application built with Flutter Web.
- **`/BackendAPI`**: The backend RESTful API built with .NET 8 (C#) and Entity Framework Core.

---

## 🛠️ How to Run Locally

To get this project running on your local machine, you will need to run both the Backend API and the Frontend Web App simultaneously in two separate terminals.

### 1. Starting the .NET Backend
Before running the backend, ensure you have the `.env` file correctly configured inside the `BackendAPI` folder with your `DATABASE_URL` (Neon PostgreSQL) and `JWT_SECRET`.

1. Open a new terminal.
2. Navigate to the backend directory:
   ```bash
   cd BackendAPI
   ```
3. Run the application:
   ```bash
   dotnet run
   ```
4. The API will start, typically on `http://localhost:5005`. 
   > **Note:** You can view the full Swagger documentation for the API by navigating to `http://localhost:5005/swagger` in your browser.

### 2. Starting the Flutter Web App
1. Open a *second* new terminal.
2. Navigate to the frontend directory:
   ```bash
   cd flutter_web_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the web app:
   ```bash
   flutter run -d chrome
   ```
5. Google Chrome will automatically open and navigate to the application. 

### 🔐 Default Accounts (Example)
- Admin Login: `admin@admin.com`
- User Login: `test_user@example.com`
*(Check your database for actual user credentials)*
