import "package:cloud_functions/cloud_functions.dart";

class Backend {
  static Future<List<Map>> fetchNearby(List location, List categories) async {
    var callable = FirebaseFunctions.instance.httpsCallable('nearby',
        options: HttpsCallableOptions(timeout: Duration(seconds: 5)));

    var result = (await callable.call({
      "location": "${location[0]},${location[1]}",
      "categories": categories
    }));
    print(result.toString());
    return [];
  }

  static Future<String> fetchImage(String imageRef) async {
    var callable = FirebaseFunctions.instance.httpsCallable("photo/$imageRef",
        options: HttpsCallableOptions(timeout: Duration(seconds: 5)));

    return (await callable.call()).data;
  }
}
