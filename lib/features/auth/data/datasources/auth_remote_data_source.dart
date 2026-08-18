import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> login(String email, String password);
  Future<void> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserEntity> login(String email, String password) async {
    // Simulate network API delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulated error for testing invalid credentials
    if (password == "wrongpass") {
      throw Exception("Invalid email or password.");
    }

    return UserEntity(id: "usr_101", email: email);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate server response
  }
}