class ApiEndpoints {
  static const String baseUrl =
      'https://api.example.com'; // Replace with your API base URL

  // Authentication endpoints
  static const String login = '$baseUrl/auth/login';
  static const String signup = '$baseUrl/auth/signup';
  static const String logout = '$baseUrl/auth/logout';

  // News endpoints
  static const String getNews = '$baseUrl/news';
  static const String getNewsByCategory = '$baseUrl/news/category';
}
