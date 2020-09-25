import "service.dart";
import "memcache.dart";

void main() async {
    // initialise class
    final memCache = new MemCache();
    final dataService = new DataService(memCache: memCache, enableMemCache: true);

    print("Fetching data...");

    // fetch posts from API
    try {
        final posts = await dataService.fetchPosts("/posts");

        print("Process took ${dataService.elapsedTime}ms");
        print("Delaying for 5 seconds...");

        await Future.delayed(Duration(seconds: 5));

        print("Fetching data...");
        await dataService.fetchPosts("/posts");

        print("Returned posts size [${posts.length}]");
        print("First post title: '${posts[0].title}'");
    } catch (err) {
        print(err);
    }
}
