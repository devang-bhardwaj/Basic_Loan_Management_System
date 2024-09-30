from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)

# Database connection
from database_config import db_config

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/check_eligibility', methods=['POST'])
def check_eligibility():
    user_id = request.form['user_id']
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()

    # Fetch user and loan details
    cursor.execute(f"""
        SELECT customers.user_name, customers.credit_score, loans.loan_remaining 
        FROM customers 
        LEFT JOIN loans ON customers.loan_no = loans.loan_no 
        WHERE customers.user_id = %s
    """, (user_id,))
    result = cursor.fetchone()
    conn.close()

    if result:
        name, credit_score, loan_remaining = result
        eligibility = "Eligible" if credit_score >= 700 and (loan_remaining == 0 or loan_remaining is None) else "Not Eligible"
        return render_template('loan_status.html', name=name, credit_score=credit_score, eligibility=eligibility, loan_remaining=loan_remaining)
    else:
        return "User not found"

@app.route('/view_customer', methods=['POST'])
def view_customer():
    user_id = request.form['user_id']
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()

    # Fetch all details from both tables
    cursor.execute(f"""
        SELECT customers.user_name, customers.account_no, customers.balance, customers.credit_score, 
               loans.total_loan_amount, loans.loan_repaid, loans.loan_remaining, loans.due_date 
        FROM customers 
        LEFT JOIN loans ON customers.loan_no = loans.loan_no 
        WHERE customers.user_id = %s
    """, (user_id,))
    result = cursor.fetchone()
    conn.close()

    if result:
        return render_template('customer_info.html', data=result)
    else:
        return "User not found"

@app.route('/update_repayment', methods=['POST'])
def update_repayment():
    user_id = request.form['user_id']
    amount = request.form['amount']
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()

    # Update repayment and remaining loan
    cursor.execute(f"""
        UPDATE loans 
        SET loan_repaid = loan_repaid + %s, loan_remaining = loan_remaining - %s 
        WHERE loan_no = (SELECT loan_no FROM customers WHERE user_id = %s)
    """, (amount, amount, user_id))
    conn.commit()
    conn.close()

    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
