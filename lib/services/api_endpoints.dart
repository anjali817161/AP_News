class ApiEndpoints {
  static const String baseUrl =
      'https://ap-news-b.onrender.com/api/'; 

  static const String liveVideos = 'youtube/live';
    static const String articleById = 'articles';
    static const String recentVideos = 'youtube/recent-videos';

    // Category endpoints
    static const String businessCategory = 'articles/category/Business';
    static const String bhojpuriCategory = 'articles/category/Bhojpuri';
    static const String technologyCategory = 'articles/category/Technology';
    static const String electionsCategory = 'articles/category/Elections';
    static const String sportsCategory = 'articles/category/Sports';
    static const String Joinnow = 'join-team';

      

  // Authentication endpoints
  static const String login = '$baseUrl/auth/login';
  static const String signup = '$baseUrl/auth/signup';
  static const String logout = '$baseUrl/auth/logout';


  // News endpoints
  static const String getNews = '$baseUrl/news';
  static const String getNewsByCategory = '$baseUrl/news/category';
  static const String articlesAll = 'articles/all';

  // NewsData.io API
  static const String newsDataApi = 'https://newsdata.io/api/1/latest';
  static const String newsApiKey = 'pub_150af8948d6a4c07ba37ab0f40a03d6a';
  static const String newsQuery = 'news';
}
