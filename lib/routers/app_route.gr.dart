// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:love_debate/features/create/create_page.dart' as _i1;
import 'package:love_debate/features/detail/detail_page.dart' as _i2;
import 'package:love_debate/features/home/home_page.dart' as _i3;
import 'package:love_debate/features/list/list_page.dart' as _i4;
import 'package:love_debate/features/match/match_page.dart' as _i5;
import 'package:love_debate/features/result/result_page.dart' as _i6;

/// generated route for
/// [_i1.CreatePage]
class CreateRoute extends _i7.PageRouteInfo<CreateRouteArgs> {
  CreateRoute({
    _i8.Key? key,
    required String debateId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         CreateRoute.name,
         args: CreateRouteArgs(key: key, debateId: debateId),
         initialChildren: children,
       );

  static const String name = 'CreateRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateRouteArgs>();
      return _i1.CreatePage(key: args.key, debateId: args.debateId);
    },
  );
}

class CreateRouteArgs {
  const CreateRouteArgs({this.key, required this.debateId});

  final _i8.Key? key;

  final String debateId;

  @override
  String toString() {
    return 'CreateRouteArgs{key: $key, debateId: $debateId}';
  }
}

/// generated route for
/// [_i2.DetailPage]
class DetailRoute extends _i7.PageRouteInfo<DetailRouteArgs> {
  DetailRoute({
    _i8.Key? key,
    required String debateId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         DetailRoute.name,
         args: DetailRouteArgs(key: key, debateId: debateId),
         initialChildren: children,
       );

  static const String name = 'DetailRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DetailRouteArgs>();
      return _i2.DetailPage(key: args.key, debateId: args.debateId);
    },
  );
}

class DetailRouteArgs {
  const DetailRouteArgs({this.key, required this.debateId});

  final _i8.Key? key;

  final String debateId;

  @override
  String toString() {
    return 'DetailRouteArgs{key: $key, debateId: $debateId}';
  }
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.ListPage]
class ListRoute extends _i7.PageRouteInfo<void> {
  const ListRoute({List<_i7.PageRouteInfo>? children})
    : super(ListRoute.name, initialChildren: children);

  static const String name = 'ListRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.ListPage();
    },
  );
}

/// generated route for
/// [_i5.MatchPage]
class MatchRoute extends _i7.PageRouteInfo<void> {
  const MatchRoute({List<_i7.PageRouteInfo>? children})
    : super(MatchRoute.name, initialChildren: children);

  static const String name = 'MatchRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.MatchPage();
    },
  );
}

/// generated route for
/// [_i6.ResultPage]
class ResultRoute extends _i7.PageRouteInfo<ResultRouteArgs> {
  ResultRoute({
    _i8.Key? key,
    required String debateId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         ResultRoute.name,
         args: ResultRouteArgs(key: key, debateId: debateId),
         initialChildren: children,
       );

  static const String name = 'ResultRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResultRouteArgs>();
      return _i6.ResultPage(key: args.key, debateId: args.debateId);
    },
  );
}

class ResultRouteArgs {
  const ResultRouteArgs({this.key, required this.debateId});

  final _i8.Key? key;

  final String debateId;

  @override
  String toString() {
    return 'ResultRouteArgs{key: $key, debateId: $debateId}';
  }
}
