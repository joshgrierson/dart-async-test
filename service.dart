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

    Future<List<DataModel>> requestPosts() async {
        const postsUrl = "$baseUrl/posts";

        try {
            var response = await http.get(postsUrl);

            if (response.statusCode >= 400) {
                throw APIException("$postsUrl returned ${response.statusCode} status code");
            }

            print("Fetched data.");

            List posts = jsonDecode(response.body);
            List<DataModel> postList = new List<DataModel>();

            posts.forEach(
                (post) => postList.add(new DataModel(post))
            );

            return postList;
        } catch (err) {
            print("DataService error");
            throw err;
        }
    }
}