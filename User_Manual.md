
# 📘 User Manual – Flutter Bank Management App

This user manual explains how to use each feature of the Bank Management App built with Flutter.

---

## 🛠 Getting Started

### Login or Register
1. **Register** if you're a new user. Provide name, email, password, account type, and initial balance.
2. **Login** using your email and password.

Admin login is:
- **Email:** `admin@example.com`
- **Password:** `admin123`

---

## 🏠 Dashboard

The dashboard is your homepage after login. It includes:
- **Current Balance**
- **Quick Actions**
- **Exam Fee Status**
- **Registration Fee Status**
- **Recent Transactions**

### Quick Actions Icons:
- 💰 Deposit
- 🏧 Withdraw
- 🔁 Transfer
- 🏦 Loan
- 📝 Exam Fee
- 📘 Course Registration Fee
- 📜 Transactions
- 🛡 Admin Dashboard (Admin only)

---

## 💰 Deposit Funds

Steps:
1. Tap the **Deposit** icon.
2. Enter the amount.
3. Confirm to update balance.

---

## 🏧 Withdraw Funds

Steps:
1. Tap the **Withdraw** icon.
2. Enter amount.
3. Confirm if you have sufficient balance.

---

## 🔁 Transfer Funds

Steps:
1. Tap the **Transfer** icon.
2. Enter recipient’s account number and amount.
3. Confirm and complete the transfer.

---

## 📝 Pay Exam Fee

Steps:
1. Tap the **Exam Fee** icon.
2. Confirm to deduct one-time fee.
3. Dashboard will update to show ✅ **Paid**.

---

## 📘 Pay Course Registration Fee

Steps:
1. Tap the **Course Registration Fee** icon.
2. Confirm to deduct one-time fee.
3. Dashboard will update to show ✅ **Paid**.

---

## 🏦 Request a Loan

Steps:
1. Tap the **Loan** icon.
2. Enter the amount and months.
3. Confirm your loan request.

---

## 📜 View Transactions

Steps:
1. Tap **Transactions** from dashboard.
2. View list of all deposits, withdrawals, transfers, and loan requests.

---

## 🧍 View Profile

Steps:
1. Tap the person icon on the AppBar.
2. View your name, email, balance, account number, and account type.

---

## 🛡 Admin Dashboard (Admin Only)

Steps:
1. Login with admin credentials.
2. Tap **Admin** on the dashboard.
3. View all users, their balances, and emails.

---

## 🔐 Logout

Tap the logout icon in the AppBar to log out of your account securely.

---

## ℹ Notes

- Exam and Registration fee status is saved temporarily unless persistent storage is implemented.
- Transactions and balance updates are real-time in memory.
