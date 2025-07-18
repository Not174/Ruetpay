📱 Flutter Bank Management App
A fully functional Bank Management System built using Flutter with local state and data persistence. It includes features for account management, secure login, fund transfers, exam and registration fee payments, loans, admin dashboard, and more.

📌 Description
This app simulates core banking functionalities like balance management, deposits, withdrawals, fund transfers, and loan applications, along with educational fee payments and an admin interface. It’s ideal for academic simulations, prototypes, or as a base for production-level finance apps.

🚀 Features List
👤 User Features
User Registration & Login – Create a secure account with balance and account type.

Dashboard – Overview of balance, quick actions, and recent transactions.

Deposit & Withdraw – Add or withdraw funds with validation.

Fund Transfer – Send money to other users using their account number.

Loan Request – Apply for a loan with custom amount and duration.

Transactions History – View all financial activity.

Profile View – Access your user profile.

Exam Fee Payment – One-time fee payment with dashboard confirmation.

Course Registration Fee – Separate registration fee tracker.

🛠️ Admin Features
Admin Dashboard – Only accessible to admin@example.com with password admin123.

User List View – See all registered users and account details.

🧰 Technologies & Versions Used
Tool	Version
Flutter	3.22.1
Dart	3.3.1
SharedPreferences	✅ (if persistent storage needed)
Provider	✅ (for state management, optional)

🧑‍💻 Installation Instructions
Prerequisites
Flutter SDK (≥ 3.10)

Dart SDK (≥ 3.0)

Android Studio or VS Code with Flutter plugin

Steps
bash
Copy
Edit
git clone <your_repo_url>
cd bank-management-app
flutter pub get
flutter run
👥 Default Admin Login
Email: admin@example.com

Password: admin123

📖 User Manual
🔐 Login & Register
Use the Register screen to create a new account.

Admin must log in using the pre-set credentials.

🏠 Dashboard
Shows current balance, quick access buttons, and 5 most recent transactions.

Displays whether you have paid:

✅ Exam Fee

✅ Course Registration Fee

💸 Deposit
Add funds to your account.

Enter amount and submit.

🏧 Withdraw
Withdraw money from your balance.

Validates if you have enough funds.

🔁 Transfer
Send money to another user by account number.

Includes balance validation and recipient existence check.

📝 Exam Fee
One-time payment (flag is set in memory).

Once paid, dashboard shows ✅.

🧾 Course Registration Fee
Similar to exam fee, one-time action.

Shown on dashboard once completed.

💼 Loan
Apply for a loan by specifying amount and months.

Saved under your account and visible on admin panel.

🧍 Profile
View your account details: name, email, account number, and balance.

🗂 Transactions
View full history of:

Deposits

Withdrawals

Transfers

Loan requests

🛡 Admin Panel (for Admin Only)
Accessible only by admin@example.com.

View full list of all users and their balances.

Review all registered accounts and their roles.

🧪 Testing Notes
Data is stored in memory unless enhanced with SharedPreferences.

Flags like exam/registration fee are session-based unless you choose persistence.

📬 Contributions & Feedback
For feature requests, improvements, or bugs, feel free to open an issue or pull request.
