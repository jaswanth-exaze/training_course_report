import os
from flask import Flask, render_template, request, redirect, url_for
from db import get_connection, init_db

app = Flask(__name__, template_folder="../templates", static_folder="../static")


# Flask 3.0 fix: before_first_request removed
@app.before_request
def setup():
    if not hasattr(app, "db_initialized"):
        init_db()
        app.db_initialized = True


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/add", methods=["GET", "POST"])
def add_expense():
    if request.method == "POST":
        title = request.form["title"]
        amount = request.form["amount"]
        category = request.form["category"]

        conn = get_connection()
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO expenses (title, amount, category) VALUES (%s, %s, %s)",
            (title, amount, category),
        )
        conn.commit()
        cur.close()
        conn.close()

        return redirect(url_for("view_expenses"))

    return render_template("add.html")


@app.route("/view")
def view_expenses():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, title, amount, category, created_at FROM expenses ORDER BY created_at DESC")
    rows = cur.fetchall()
    cur.close()
    conn.close()

    return render_template("view.html", expenses=rows)


@app.route("/delete/<int:expense_id>", methods=["POST"])
def delete_expense(expense_id):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("DELETE FROM expenses WHERE id = %s", (expense_id,))
    conn.commit()
    cur.close()
    conn.close()
    return redirect(url_for("view_expenses"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
