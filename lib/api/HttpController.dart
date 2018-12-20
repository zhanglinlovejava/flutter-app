import 'package:dio/dio.dart';

//在 方法参数中，使用'{}' 包围的参数属于可选命名参数，可以为可选参数添加默认值
class HttpController {
  Dio dio;
  Options options;
  static HttpController instance;
  Map<String, CancelToken> mCancelTokens = new Map();

  static HttpController getInstance() {
    if (instance == null) {
      instance = new HttpController();
    }
    return instance;
  }

  HttpController() {
    options = Options(
      baseUrl: 'http://baobab.kaiyanapp.com/api/',
      connectTimeout: 10000,
      receiveTimeout: 2000,
      headers: {
        "User-Agent":
            "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63",
      },
    );
    dio = new Dio(options);
  }

  void cancelRequest(String token) {
    var cancelToken = mCancelTokens[token];
    if (cancelToken != null) {
      cancelToken.cancel(token);
    }
  }

  _createCancelToken(String token) {
    CancelToken cancelToken;
    if (!mCancelTokens.containsKey(token)) {
      cancelToken = CancelToken();
      mCancelTokens[token] = cancelToken;
    } else {
      cancelToken = mCancelTokens[token];
    }
    return cancelToken;
  }

  void get(String url, Function callback,
      {Map<String, String> params,
      Function errorCallback,
      String token}) async {
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }
    Response response;
    try {
      response = await dio.get(url,
          data: params, cancelToken: _createCancelToken(token));
      if (callback != null) {
        callback(response.data);
        print('response:==${response.data}');
      }
    } on DioError catch (e) {
      print('error:===$e');
      if (CancelToken.isCancel(e)) {
        print('get请求取消!---------- ' + e.message);
        return;
      }
      if (errorCallback != null) {
        errorCallback(e);
      }
    }
  }

  static void post(String url, Function callback,
      {Map<String, String> params, Function errorCallback}) async {
//    try {
//      http.Response res = await http.post(url, body: params);
//      if (callback != null) {
//        callback(res.body);
//      }
//    } catch (e) {
//      if (errorCallback != null) {
//        errorCallback(e);
//      }
//    }
  }
}
