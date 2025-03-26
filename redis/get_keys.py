import redis

from config import REDIS_HOST, REDIS_PORT, REDIS_DB, REDIS_PASSWORD

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DB, password=REDIS_PASSWORD, decode_responses=True)
print(f"Total keys: {r.dbsize()}")

matched_keys = []
redis_match = "*"

for key in r.scan_iter(redis_match):
    matched_keys.append(key)

matched_keys.sort()

print(f"Matched keys: {len(matched_keys)}")

for key in matched_keys:
    key_type = r.type(key)

    key_type_handlers = {
        "string": lambda key: r.get(key),
        "list": lambda key: r.lrange(key, 0, -1),
        "set": lambda key: r.smembers(key),
        "hash": lambda key: r.hgetall(key),
        "zset": lambda key: r.zrange(key, 0, -1, withscores=True),
    }

    value = key_type_handlers.get(key_type, lambda key: "Unsupported type")(key)
    print(f"{key} ({key_type}) => {value}")
