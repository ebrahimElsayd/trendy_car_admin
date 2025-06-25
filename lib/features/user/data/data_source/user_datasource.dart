import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utils/try_and_catch.dart';

final supabaseClientProvider = Provider.autoDispose<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final UserDataSourceProvider = Provider.autoDispose<UserDataSource>(
  (ref) => UserDataSourceImpl(supabaseClient: ref.read(supabaseClientProvider)),
);

abstract class UserDataSource {
  Future<void> updateUser(
    String userId,
    String newName,
    String newPhone, {
    String? newState,
  });

  Future<Map<String, dynamic>> getUserInfo(String userId);
}

class UserDataSourceImpl implements UserDataSource {
  final SupabaseClient supabaseClient;

  UserDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> updateUser(
    String userId,
    String newName,
    String newPhone, {
    String? newState,
  }) {
    return executeTryAndCatchForDataLayer(() async {
      final updateData = {'name': newName, 'phone': newPhone};

      if (newState != null) {
        updateData['state'] = newState;
      }

      await supabaseClient.from('users').update(updateData).eq('id', userId);
    });
  }

  @override
  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    return executeTryAndCatchForDataLayer(() async {
      final user =
          await supabaseClient
              .from('users')
              .select('id, name, email, phone, state')
              .eq('id', userId)
              .single();

      return user;
    });
  }
}
