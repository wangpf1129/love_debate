import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@Freezed(genericArgumentFactories: true)
sealed class BaseResponse<T> with _$BaseResponse<T> {
  const factory BaseResponse({
    required int code,
    required String info,
    required T data,
  }) = _BaseResponse<T>;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);
}

@Freezed(genericArgumentFactories: true)
sealed class ListResponse<T> with _$ListResponse<T> {
  const factory ListResponse({
    required int code,
    required String info,
    required List<T> data,
    required int count,
    required bool next,
    required bool previous,
  }) = _ListResponse<T>;

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ListResponseFromJson(json, fromJsonT);
}
