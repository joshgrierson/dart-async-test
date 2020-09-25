import "apiexception.dart";
import "memcache.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:meta/meta.dart";

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

class DataService {
    static const String baseUrl = "https://jsonplaceholder.typicode.com";

    int _elapsedMilliseconds;

    bool _enableMemCache = false;

    MemCache _memCache;

    Stopwatch _stopwatch;

    DataService({ @required MemCache memCache, bool enableMemCache }) {
        this._enableMemCache = enableMemCache;
        this._memCache = memCache;
        this._stopwatch = new Stopwatch();
    }

    Future<List<DataModel>> fetchPosts(String endpoint) async {
        final cacheKey = baseUrl + endpoint;

        if (this._enableMemCache) {
            await this._memCache.invalidate(
                cacheKey,
                () => this._requestPosts(endpoint)
            );
        }

        return this._convertToTypedList(
            jsonDecode(this._memCache.getCachedData(cacheKey))
        );
    }

    Future<void> _requestPosts(String endpoint) async {
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

            if (this._enableMemCache) {
                this._memCache.store(postsUrl, response.body);
            }
        } catch (err) {
            print("DataService error");
            throw err;
        }
    }

    int get elapsedTime {
        return this._elapsedMilliseconds;
    }

    List<DataModel> _convertToTypedList(List posts) {
        List<DataModel> postList = new List<DataModel>();

        posts.forEach(
            (post) => postList.add(new DataModel(post))
        );

        return postList;
    }
}