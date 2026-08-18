import 'package:get/get.dart';
import 'package:inten/features/auth/presentation/bindings/login_binding.dart';
import 'package:inten/features/auth/presentation/pages/login_page.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}