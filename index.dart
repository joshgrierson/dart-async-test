import "service.dart";

void main() async {
    // initialise class
    final dataService = new DataService();

    print("Fetching data...");

    // fetch posts from API
    final List posts = await dataService.requestPosts();

    print("Returned posts size [${posts.length}]");
    print("First post title: '${posts[0].title}'");
}
