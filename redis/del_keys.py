import redis

from config import REDIS_HOST, REDIS_PORT, REDIS_DB, REDIS_PASSWORD

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DB, password=REDIS_PASSWORD, decode_responses=True)
print(f"Total keys: {r.dbsize()}")

matched_keys = []
redis_match = "key_*"

for key in r.scan_iter(redis_match):
    matched_keys.append(key)

matched_keys.sort()

print(f"Matched keys: {len(matched_keys)}")

print(matched_keys)

delete_confirmation = input("Do you want to delete these keys? Type 'delete' in uppercase to confirm: ")

if delete_confirmation == "DELETE":
    for key in matched_keys:
        r.delete(key)
        print(f"Deleted key: {key}")
else:
    print("Deletion cancelled.")
