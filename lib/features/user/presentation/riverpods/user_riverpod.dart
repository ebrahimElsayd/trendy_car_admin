import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/user_repository.dart';
import 'user_state.dart';

final userProvider =
    StateNotifierProvider.autoDispose<UserRiverpod, UserRiverpodState>(
      (ref) => UserRiverpod(repository: ref.read(userRepositoryProvider)),
    );

class UserRiverpod extends StateNotifier<UserRiverpodState> {
  final UserRepository repository;

  UserRiverpod({required this.repository})
    : super(UserRiverpodState(state: userState.initial));

  Future<void> updateUser(
    String userId,
    String newName,
    String newPhone, {
    String? newState,
  }) async {
    state = state.copyWith(state: userState.loading);
    final result = await repository.updateUser(
      userId,
      newName,
      newPhone,
      newState: newState,
    );
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: userState.error,
            errorMessage: failure.message,
          ),
      (success) {
        state = state.copyWith(
          state: userState.success,
          username: newName,
          userphone: newPhone,
          userStateField: newState,
        );
      },
    );
  }

  Future<void> getUserInfo(String userId) async {
    state = state.copyWith(state: userState.loading);
    final result = await repository.getUserInfo(userId);
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: userState.error,
            errorMessage: failure.message,
          ),
      (success) {
        state = state.copyWith(
          state: userState.success,
          username: success.name,
          userphone: success.phone,
          userEmail: success.email,
        );
      },
    );
  }

  Future<void> getAllUsers() async {
    state = state.copyWith(state: userState.loading);
    final result = await repository.getAllUsers();
    result.fold(
      (failure) =>
          state = state.copyWith(
            state: userState.error,
            errorMessage: failure.message,
          ),
      (users) {
        state = state.copyWith(state: userState.success, users: users);
      },
    );
  }
}
