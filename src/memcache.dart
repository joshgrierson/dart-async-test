class MemCacheModel {
    int timestamp;
    String data;

    MemCacheModel(String data, int timestamp) {
        this.data = data;
        this.timestamp = timestamp;
    }
}

class MemCache {
    int _memCacheExpire;

    Map<String, MemCacheModel> _memCache;

    MemCache({ int memCacheExpire = 60 * 100 }) { // 10 secs
        this._memCacheExpire = memCacheExpire;
        this._memCache = new Map<String, MemCacheModel>();
    }

    Future<void> invalidate(String key, Function() fn) async {
        if (!this._memCache.containsKey(key)) {
            return fn();
        }

        final date = new DateTime.now();

        if ((date.millisecond - this._memCache[key].timestamp) >= this._memCacheExpire) {
            return fn();
        }

        print("Reading from mem cache using key '$key'");
    }

    String getCachedData(String key) {
        return this._memCache[key].data;
    }

    void store(String key, String data) {
        final date = new DateTime.now();

        this._memCache[key] = new MemCacheModel(data, date.millisecond);
    }
}