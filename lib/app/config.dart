import 'package:dio/dio.dart';

class Config {
  static const String apiUrl = 'https://www.hypnosisdownloads.com/api';

  static final baseOptions = BaseOptions(
    baseUrl: apiUrl,
  );

  static const String userSessionsPath = "userdownloadhistory";
  static const String userPlaylistsPath = "hdphplaylistuser";
  static String userSessionAction = "listjson";
  static String userRetrievePlaylistsAction = "loadlistsjson";
  static String userSavePlaylistAction = "savelistjson";
  static String userDeletePlaylistAction = "deletelistjson";
  static String addToPlaylistAction = "addlistentriesjson";
  static String removeFromPlaylistAction = "deletelistentriesjson";

  static const String userAccountPath = "hdaccountsuser";

  static String userAccountAction = "getprofilejson";
  static String resetPasswordAction = "resetpasswordjson";
}
