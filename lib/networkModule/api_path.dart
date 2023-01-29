enum APIPath {
  fetchAlbum,
}

class APIPathHelper {
  static String getValue(APIPath url) {
    switch (url) {
      case APIPath.fetchAlbum:
        return "/posts/1";
      default:
        return "";
    }
  }
}
