import os
import psycopg2
from flask import Flask, jsonify, request

app = Flask(__name__)

def get_db():
    return psycopg2.connect(os.environ["DATABASE_URL"])

def init_db():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS products (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            price NUMERIC(10,2) NOT NULL
        );
        CREATE TABLE IF NOT EXISTS orders (
            id SERIAL PRIMARY KEY,
            product_id INTEGER REFERENCES products(id),
            quantity INTEGER NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        );
    """)
    conn.commit()
    cur.close()
    conn.close()

@app.route("/health")
def health():
    return jsonify({"status": "ok"})

@app.route("/products")
def list_products():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT id, name, price FROM products;")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify([{"id": r[0], "name": r[1], "price": float(r[2])} for r in rows])

@app.route("/orders", methods=["POST"])
def create_order():
    data = request.get_json()
    conn = get_db()
    cur = conn.cursor()
    # Transação garante que o pedido não é perdido em caso de falha
    cur.execute(
        "INSERT INTO orders (product_id, quantity) VALUES (%s, %s) RETURNING id;",
        (data["product_id"], data["quantity"])
    )
    order_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"order_id": order_id}), 201

@app.route("/orders/<int:order_id>")
def get_order(order_id):
    conn = get_db()
    cur = conn.cursor()
    cur.execute(
        "SELECT o.id, p.name, o.quantity, o.created_at FROM orders o JOIN products p ON o.product_id = p.id WHERE o.id = %s;",
        (order_id,)
    )
    row = cur.fetchone()
    cur.close()
    conn.close()
    if not row:
        return jsonify({"error": "order not found"}), 404
    return jsonify({"id": row[0], "product": row[1], "quantity": row[2], "created_at": str(row[3])})

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)
