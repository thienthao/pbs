class BaseApi {
  // static const String BASE_URL = 'https://pbs-webapi.herokuapp.com/api/';
  static const String BASE_URL = 'http://194.59.165.195:8080/pbs-webapi/api/';
  //photographer, calendar, profile
  static const String PHOTOGRAPHER_URL = BASE_URL + 'photographers';

  static const String USER_URL = BASE_URL + 'users';

  static const String PACKAGE_URL = BASE_URL + 'packages';

  static const String ALBUM_URL = BASE_URL + 'albums';

  static const String CATEGORY_URL = BASE_URL + 'categories';

  static const String BOOKING_URL = BASE_URL + 'bookings';

  static const String THREAD_URL = BASE_URL + 'threads';

  static const String THREAD_TOPIC_URL = BASE_URL + 'thread-topics';

  static const String LOGIN_URL = BASE_URL + 'auth/signin';

  static const String SIGNUP_URL = BASE_URL + 'auth/signup';
}
