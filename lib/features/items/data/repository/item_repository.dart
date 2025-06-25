import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../data_source/item_data_source.dart';
import '../models/item_model.dart';

final itemRepositoryProvider = Provider.autoDispose<ItemRepository>((ref) {
  return ItemRepository(dataSource: ref.watch(itemDataSourceProvider));
});

class ItemRepository {
  final ItemDataSource dataSource;

  ItemRepository({required this.dataSource});

  Future<Either<Failure, List<ItemModel>>> getAllItems() async {
    return executeTryAndCatchForRepository(() async {
      final itemsData = await dataSource.getAllItems();
      final items = itemsData.map((data) => ItemModel.fromMap(data)).toList();
      return items;
    });
  }

  Future<Either<Failure, ItemModel>> getItemById(String id) async {
    return executeTryAndCatchForRepository(() async {
      final itemData = await dataSource.getItemById(id);
      return ItemModel.fromMap(itemData);
    });
  }

  Future<Either<Failure, void>> createItem(ItemModel item) async {
    return executeTryAndCatchForRepository(() async {
      await dataSource.createItem(item.toMap());
    });
  }

  Future<Either<Failure, void>> updateItem(String id, ItemModel item) async {
    return executeTryAndCatchForRepository(() async {
      await dataSource.updateItem(id, item.toMap());
    });
  }

  Future<Either<Failure, void>> deleteItem(String id) async {
    return executeTryAndCatchForRepository(() async {
      await dataSource.deleteItem(id);
    });
  }
}
