import 'package:get/get.dart';
import 'package:inten/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:inten/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:inten/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:inten/features/auth/domain/usecases/login_usecase.dart';
import 'package:inten/features/auth/presentation/controllers/login_controller.dart';


class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());

    // Repository
    Get.lazyPut<AuthRepositoryImpl>(
          () => AuthRepositoryImpl(remoteDataSource: Get.find()),
    );

    // Use Cases
    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepositoryImpl>()));
    Get.lazyPut(() => ForgotPasswordUseCase(Get.find<AuthRepositoryImpl>()));

    // Controller
    Get.lazyPut(
          () => LoginController(
        loginUseCase: Get.find(),
        forgotPasswordUseCase: Get.find(),
      ),
    );
  }
}