import "apiexception.dart";
import "dart:convert";
import "package:http/http.dart" as http;

class DataModel {
    int userId;
    int id;
    String title;
    String body;

    DataModel(Map post) {
        this.userId = post["userId"];
        this.id = post["id"];
        this.title = post["title"];
        this.body = post["body"];
    }
}

class MemCache {
    int timestamp;
    String data;

    MemCache(String data, int timestamp) {
        this.data = data;
        this.timestamp = timestamp;
    }
}

class DataService {
    static const String baseUrl = "https://jsonplaceholder.typicode.com";
    static const int memCacheExpire = 60 * 100; // 10 secs

    int _elapsedMilliseconds;

    bool _enableMemCache = false;

    Map<String, MemCache> _memCache;

    Stopwatch _stopwatch;

    DataService(bool enableMemCache) {
        this._enableMemCache = enableMemCache;
        this._memCache = new Map<String, MemCache>();
        this._stopwatch = new Stopwatch();
    }

    Future<List<DataModel>> fetchPosts(String endpoint) async {
        final date = new DateTime.now();
        final cacheKey = baseUrl + endpoint;

        if (this._enableMemCache) {
            if (
                !this._memCache.containsKey(cacheKey) ||
                (date.millisecond - this._memCache[cacheKey].timestamp) >= DataService.memCacheExpire
            ) {
                await this._requestPosts(endpoint);
            } else {
                print("Reading from mem cache using key '$baseUrl$endpoint'");
            }
        }

        return this._convertToTypedList(
            jsonDecode(this._memCache[cacheKey].data)
        );
    }

    Future<List<DataModel>> _requestPosts(String endpoint) async {
        final postsUrl = baseUrl + endpoint;

        try {
            this._stopwatch.start();

            var response = await http.get(postsUrl, headers: {
                "Content-Type": "application/json"
            });

            this._stopwatch.stop();
            this._elapsedMilliseconds = this._stopwatch.elapsedMilliseconds;

            if (response.statusCode >= 400) {
                throw APIException("$postsUrl returned ${response.statusCode} status code");
            }

            print("Fetched data.");

            List posts = jsonDecode(response.body);

            if (this._enableMemCache) {
                this.storeInMem(postsUrl, response.body);
            }

            return this._convertToTypedList(posts);
        } catch (err) {
            print("DataService error");
            throw err;
        }
    }

    int get elapsedTime {
        return this._elapsedMilliseconds;
    }

    void storeInMem(String key, String data) {
        final date = new DateTime.now();

        this._memCache[key] = new MemCache(data, date.millisecond);
    }

    List<DataModel> _convertToTypedList(List posts) {
        List<DataModel> postList = new List<DataModel>();

        posts.forEach(
            (post) => postList.add(new DataModel(post))
        );

        return postList;
    }
}