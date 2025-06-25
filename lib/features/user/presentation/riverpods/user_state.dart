import '../../data/model/user_model_test.dart';

enum userState { initial, loading, success, error }

class UserRiverpodState {
  final userState state;
  final String? errorMessage;
  final String? username;
  final String? userphone;
  final String? userEmail;
  final String? userStateField;
  final List<userModelTest> users;

  UserRiverpodState({
    required this.state,
    this.errorMessage = "",
    this.username = "",
    this.userphone = "",
    this.userEmail = "",
    this.userStateField = "",
    this.users = const [],
  });

  bool isLoading() => state == userState.loading;

  bool isSuccess() => state == userState.success;

  bool isError() => state == userState.error;

  UserRiverpodState copyWith({
    userState? state,
    String? errorMessage,
    String? username,
    String? userphone,
    String? userEmail,
    String? userStateField,
    List<userModelTest>? users,
  }) {
    return UserRiverpodState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      username: username ?? this.username,
      userphone: userphone ?? this.userphone,
      userEmail: userEmail ?? this.userEmail,
      userStateField: userStateField ?? this.userStateField,
      users: users ?? this.users,
    );
  }
}
