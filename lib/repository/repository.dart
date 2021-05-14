import 'package:http/http.dart' as http;

class Repository {
  static final Repository _repository = Repository._();

  //static const String
  static const _perPage = 10;

  Repository._();

  factory Repository() {
    return _repository;
  }

  Future<dynamic> getImages({required int page}) async {
    try {
      return await http.get(Uri.https('api.punkapi.com', '/v2/beers/',
          {'page': '$page', 'per_page': '$_perPage'}));
    } catch (e) {
      print(e.toString());
    }
  }
}
