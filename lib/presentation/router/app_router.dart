import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/books_screen.dart';
import '../screens/chapters_screen.dart';
import '../screens/slokas_screen.dart';
import '../screens/sloka_form_screen.dart';
import '../screens/quotes_screen.dart';
import '../screens/languages_screen.dart';
import '../screens/import_screen.dart';
import '../screens/devices_screen.dart';
import '../widgets/main_layout.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        return '/books';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/books',
            builder: (context, state) => const BooksScreen(),
          ),
          GoRoute(
            path: '/chapters',
            builder: (context, state) => const ChaptersScreen(),
          ),
          GoRoute(
            path: '/slokas',
            builder: (context, state) => const SlokasScreen(),
          ),
          GoRoute(
            path: '/slokas/new',
            builder: (context, state) {
              final chapterId = state.uri.queryParameters['chapterId'];
              return SlokaFormScreen(
                chapterId: chapterId != null ? int.tryParse(chapterId) : null,
              );
            },
          ),
          GoRoute(
            path: '/slokas/:id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return SlokaFormScreen(slokaId: id);
            },
          ),
          GoRoute(
            path: '/quotes',
            builder: (context, state) => const QuotesScreen(),
          ),
          GoRoute(
            path: '/languages',
            builder: (context, state) => const LanguagesScreen(),
          ),
          GoRoute(
            path: '/import',
            builder: (context, state) => const ImportScreen(),
          ),
          GoRoute(
            path: '/devices',
            builder: (context, state) => const DevicesScreen(),
          ),
        ],
      ),
    ],
  );
});
