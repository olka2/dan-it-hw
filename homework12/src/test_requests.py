import os
import json
import requests

BASE_URL = os.environ.get("BASE_URL", "http://127.0.0.1:5000")
LOG_PATH = "results.txt"

def show(step_title: str, resp: requests.Response, logf):
    print(f"\n=== {step_title} ===")
    print(f"STATUS: {resp.status_code}")

    try:
        body = json.dumps(resp.json(), ensure_ascii=False, separators=(",", ":"))
    except Exception:
        body = resp.text or "<empty>"

    print(body)
    logf.write(f"\n=== {step_title} ===\nSTATUS: {resp.status_code}\n{body}\n")

def req(method: str, path: str, payload=None) -> requests.Response:
    url = f"{BASE_URL}{path}"
    return requests.request(method, url, json=payload)

def main():
    created_ids = []

    with open(LOG_PATH, "w", encoding="utf-8") as log:
        show("1) GET all students", req("GET", "/students"), log)

        for payload in [
            {"first_name": "Olga", "last_name": "Pl", "age": 20},
            {"first_name": "Ivan", "last_name": "Kr", "age": 22},
            {"first_name": "Petro", "last_name": "Kv", "age": 19},
        ]:
            r = req("POST", "/students", payload)
            show("2) POST create student", r, log)
            try:
                created_ids.append(r.json().get("id"))
            except Exception:
                created_ids.append(None)

        show("3) GET all students", req("GET", "/students"), log)

        if len(created_ids) >= 2 and created_ids[1]:
            show("4) PATCH age of 2nd created",
                 req("PATCH", f"/students/{created_ids[1]}", {"age": 33}), log)

        if len(created_ids) >= 2 and created_ids[1]:
            show("5) GET 2nd created",
                 req("GET", f"/students/{created_ids[1]}"), log)

        if len(created_ids) >= 3 and created_ids[2]:
            show("6) PUT update 3rd created",
                 req("PUT", f"/students/{created_ids[2]}",
                     {"first_name": "Petro", "last_name": "Lucky", "age": 25}), log)
            
        if len(created_ids) >= 3 and created_ids[2]:
            show("7) GET 3rd created",
                 req("GET", f"/students/{created_ids[2]}"), log)

        show("8) GET all students", req("GET", "/students"), log)

        if created_ids and created_ids[0]:
            show("9) DELETE 1st created",
                 req("DELETE", f"/students/{created_ids[0]}"), log)

        show("10) GET all students", req("GET", "/students"), log)

        print(f"\nFull logs saved in {LOG_PATH}")

if __name__ == "__main__":
    main()