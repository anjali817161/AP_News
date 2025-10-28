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

  // NewsData.io API
  static const String newsDataApi = 'https://newsdata.io/api/1/latest';
  static const String newsApiKey = 'pub_150af8948d6a4c07ba37ab0f40a03d6a';
  static const String newsQuery = 'news';
}
