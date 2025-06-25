import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/try_and_catch.dart';

final supabaseClientProvider = Provider.autoDispose<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final itemDataSourceProvider = Provider.autoDispose<ItemDataSource>(
  (ref) => ItemDataSourceImpl(ref.watch(supabaseClientProvider)),
);

abstract interface class ItemDataSource {
  Future<List<Map<String, dynamic>>> getAllItems();
  Future<Map<String, dynamic>> getItemById(String id);
  Future<void> createItem(Map<String, dynamic> item);
  Future<void> updateItem(String id, Map<String, dynamic> item);
  Future<void> deleteItem(String id);
}

class ItemDataSourceImpl implements ItemDataSource {
  final SupabaseClient supabaseClient;

  ItemDataSourceImpl(this.supabaseClient);

  @override
  Future<List<Map<String, dynamic>>> getAllItems() async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('items')
          .select('*')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Future<Map<String, dynamic>> getItemById(String id) async {
    return executeTryAndCatchForDataLayer(() async {
      final response =
          await supabaseClient.from('items').select('*').eq('id', id).single();

      return response;
    });
  }

  @override
  Future<void> createItem(Map<String, dynamic> item) async {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient.from('items').insert(item);
    });
  }

  @override
  Future<void> updateItem(String id, Map<String, dynamic> item) async {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient.from('items').update(item).eq('id', id);
    });
  }

  @override
  Future<void> deleteItem(String id) async {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient.from('items').delete().eq('id', id);
    });
  }
}
