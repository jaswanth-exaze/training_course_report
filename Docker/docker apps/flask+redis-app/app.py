from flask import Flask
import redis
import time

app = Flask(__name__)

# Connect to Redis (service name = "redis")

cache = redis.Redis(host='redis', port=6379)

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr("hits")
        except redis.exceptions.ConnectionError:
            if retries == 0:
                raise
            retries -= 1
            time.sleep(0.5)

@app.route("/")
def home():
    count = get_hit_count()
    return f"Hello! You have visited {count} times.\n"

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False)