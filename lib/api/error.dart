import 'package:http/http.dart';

abstract class HttpError extends Error {
  final Response response;

  final String message;

  HttpError(
      this.response, {
        this.message = 'Oops! Something went wrong',
      });

  @override
  String toString() => 'ERROR: $message';
}

// throw this error when http status code is 401
class UnauthorizedError extends HttpError {
  UnauthorizedError(Response response, {String message})
      : super(response, message: message ?? 'Unauthorized error.');
}
class BadRequestError extends HttpError {
  BadRequestError(Response response, {String message})
      : super(response, message: message ?? 'Bad request error.');
}
class AccessDeniedError extends HttpError {
  AccessDeniedError(Response response, {String message})
      : super(response, message: message ?? 'Access denied error.');
}
class NotFoundError extends HttpError {
  NotFoundError(Response response, {String message})
      : super(response, message: message ?? 'Not found error.');
}
class InternalError extends HttpError {
  InternalError(Response response, {String message})
      : super(response, message: message ?? 'Internal error.');
}