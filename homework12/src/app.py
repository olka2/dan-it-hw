from flask import Flask, request, jsonify
import csv, os

app = Flask(__name__)

CSV_PATH = "students.csv"
REQUIRED_FIELDS = ["id", "first_name", "last_name", "age"]


def err(msg, code=400):
    return jsonify({"error": msg}), code


def ensure_csv_is_ready():
    if not os.path.isfile(CSV_PATH):
        raise FileNotFoundError(
            f"CSV file '{CSV_PATH}' not found. Please provide an existing file."
        )
    with open(CSV_PATH, "r", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        header = reader.fieldnames or []
        missing = [c for c in REQUIRED_FIELDS if c not in header]
        if missing:
            raise ValueError(
                "CSV header must contain: "
                + ", ".join(REQUIRED_FIELDS)
                + f". Missing: {', '.join(missing)}"
            )


def read_all():
    ensure_csv_is_ready()
    rows = []
    with open(CSV_PATH, "r", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            try:
                rows.append({
                    "id": int(row["id"]),
                    "first_name": row["first_name"],
                    "last_name": row["last_name"],
                    "age": int(row["age"])
                })
            except (KeyError, ValueError):
                raise ValueError("Malformed CSV row. Check numbers and columns.")
    return rows


def write_all(rows):
    with open(CSV_PATH, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=REQUIRED_FIELDS)
        w.writeheader()
        for r in rows:
            w.writerow({
                "id": r["id"],
                "first_name": r["first_name"],
                "last_name": r["last_name"],
                "age": r["age"]
            })


def next_id(rows):
    return (max((r["id"] for r in rows), default=0) + 1)


@app.get("/students")
def list_or_filter():
    try:
        last = request.args.get("last_name")
        rows = read_all()
        if last:
            out = [r for r in rows if r["last_name"].lower() == last.lower()]
            if not out:
                return err(f"No students found with last_name '{last}'.", 404)
            return jsonify(out), 200
        return jsonify(rows), 200
    except FileNotFoundError as e:
        return err(str(e), 500)
    except ValueError as e:
        return err(str(e), 500)


@app.get("/students/<int:sid>")
def get_by_id(sid):
    try:
        rows = read_all()
        for r in rows:
            if r["id"] == sid:
                return jsonify(r), 200
        return err(f"Student with id {sid} not found.", 404)
    except FileNotFoundError as e:
        return err(str(e), 500)
    except ValueError as e:
        return err(str(e), 500)


@app.post("/students")
def create():
    data = request.get_json(silent=True)
    if not data:
        return err("Request body must be JSON.", 400)

    allowed = {"first_name", "last_name", "age"}
    if set(data.keys()) != allowed:
        missing = allowed - set(data.keys())
        extra = set(data.keys()) - allowed
        msg = []
        if missing: msg.append("Missing: " + ", ".join(sorted(missing)))
        if extra:   msg.append("Unknown: " + ", ".join(sorted(extra)))
        return err("; ".join(msg), 400)

    try:
        age = int(data["age"])
        if age < 0: return err("Age must be non-negative.", 400)
    except:
        return err("Age must be integer.", 400)

    try:
        rows = read_all()
        student = {
            "id": next_id(rows),
            "first_name": str(data["first_name"]).strip(),
            "last_name": str(data["last_name"]).strip(),
            "age": age
        }
        rows.append(student)
        write_all(rows)
        return jsonify(student), 201
    except (FileNotFoundError, ValueError) as e:
        return err(str(e), 500)


@app.put("/students/<int:sid>")
def put_update(sid):
    data = request.get_json(silent=True)
    if not data:
        return err("Request body must be JSON.", 400)

    allowed = {"first_name", "last_name", "age"}
    if set(data.keys()) != allowed:
        missing = allowed - set(data.keys())
        extra = set(data.keys()) - allowed
        msg = []
        if missing: msg.append("Missing: " + ", ".join(sorted(missing)))
        if extra:   msg.append("Unknown: " + ", ".join(sorted(extra)))
        return err("; ".join(msg), 400)

    try:
        age = int(data["age"])
        if age < 0: return err("Age must be non-negative.", 400)
    except:
        return err("Age must be integer.", 400)

    try:
        rows = read_all()
        for i, r in enumerate(rows):
            if r["id"] == sid:
                rows[i] = {
                    "id": sid,
                    "first_name": str(data["first_name"]).strip(),
                    "last_name": str(data["last_name"]).strip(),
                    "age": age
                }
                write_all(rows)
                return jsonify(rows[i]), 200
        return err(f"Student with id {sid} not found.", 404)
    except (FileNotFoundError, ValueError) as e:
        return err(str(e), 500)


@app.patch("/students/<int:sid>")
def patch_age(sid):
    data = request.get_json(silent=True)
    if not data:
        return err("Request body must be JSON.", 400)
    if set(data.keys()) != {"age"}:
        return err("PATCH expects only 'age'.", 400)
    try:
        age = int(data["age"])
        if age < 0: return err("Age must be non-negative.", 400)
    except:
        return err("Age must be integer.", 400)

    try:
        rows = read_all()
        for i, r in enumerate(rows):
            if r["id"] == sid:
                rows[i]["age"] = age
                write_all(rows)
                return jsonify(rows[i]), 200
        return err(f"Student with id {sid} not found.", 404)
    except (FileNotFoundError, ValueError) as e:
        return err(str(e), 500)


@app.delete("/students/<int:sid>")
def delete(sid):
    try:
        rows = read_all()
        for i, r in enumerate(rows):
            if r["id"] == sid:
                del rows[i]
                write_all(rows)
                return jsonify({"message": f"Student id {sid} deleted successfully."}), 200
        return err(f"Student with id {sid} not found.", 404)
    except (FileNotFoundError, ValueError) as e:
        return err(str(e), 500)


if __name__ == "__main__":
    app.run(debug=True)
