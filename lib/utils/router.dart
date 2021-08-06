import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starterkit/guards/auth_guard.dart';
import 'package:starterkit/repositories/auth_repository.dart';
import 'package:starterkit/views/auth/login.dart';
import 'package:starterkit/views/pages/dashboard.dart';
import 'package:starterkit/views/pages/home.dart';
import 'package:starterkit/views/partials/loading.dart';

Object appRoutes = {
  '/': (context) => AuthGuard(
      child: DashboardPage()
  ),
//  '/auth': (context) => Router(),

// pages
//   '/splash': (context) => SplashScreenPage(),
//   '/refer-a-friend': (context) => ReferAFriendPage(),
//   '/about': (context) => AboutPage(),
//   '/rate-app': (context) => RateApp(),
//   '/flutter-tips': (context) => FlutterTipsPage(),

  // auth
  // '/login': (context) => LoginPage(),
  // '/dashboard': (context) => DashboardPage(),

  // backend

};
