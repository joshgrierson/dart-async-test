import "service.dart";

void main() async {
    // initialise class
    final dataService = new DataService(true);

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
