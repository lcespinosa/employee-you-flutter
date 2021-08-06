import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'error.dart';

class ApiBaseHelper extends BaseClient {

  final String CACHED_USER = 'AUTH_USER';

  final Client _http;
  StreamController<Error> _onError;

  ApiBaseHelper(this._http);

  Stream<Error> get onError {
    _onError ??= StreamController<Error>.broadcast();
    return _onError.stream;
  }

  dispose() {
    _onError.sink.close();
  }

  Future<bool> saveUserToken(String token) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(CACHED_USER, token);
  }

  // if (userAccessToken?.isNotEmpty) {
  // request.headers.putIfAbsent('Authorization', () => userAccessToken);
  // }
  @override
  Future<StreamedResponse> send(BaseRequest request) => _http.send(request);

  @override
  Future<Response> get(url, {Map<String, String> headers}) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final resp = await super.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': sharedPrefs.getString(CACHED_USER),
    });
    return _throwIfError(resp);
  }

  @override
  Future<Response> post(url, {
    Map<String, String> headers,
    body,
    Encoding encoding,
  }) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final resp = await super.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': sharedPrefs.getString(CACHED_USER),
      },
      body: body,
      encoding: encoding,
    );
    return _throwIfError(resp);
  }

  /// Return same response if 200 < statusCode < 400
  /// otherwise throws an HttpError
  Response _throwIfError(Response response) {
    if (response.statusCode >= 400) {
      final error = () {
        switch (response.statusCode) {
          case 400:
            return BadRequestError(response);

          case 401:
            return UnauthorizedError(response);

          case 403:
            return AccessDeniedError(response);

          case 404:
            return NotFoundError(response);

          default:
            return InternalError(response);
        }
      }();
      _onError?.add(error);
      throw error;
    }
    return response;
  }
}
