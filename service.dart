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

class DataService {
    static const String baseUrl = "https://jsonplaceholder.typicode.com";

    DataService() {}

    Future<List> requestPosts() async {
        const postsUrl = "$baseUrl/posts";

        try {
            var response = await http.get(postsUrl);

            if (response.statusCode >= 400) {
                throw APIException("$baseUrl returned ${response.statusCode} status code");
            }

            print("Fetched data.");

            List posts = jsonDecode(response.body);
            List postList = new List();

            posts.forEach(
                (post) => postList.add(DataModel(post))
            );

            return postList;
        } catch (err) {
            print("Exception: $err");
            throw err;
        }
    }
}