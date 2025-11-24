import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/example_model.dart';

abstract class ExampleLocalDataSource {
  Future<List<ExampleModel>> getCachedExamples();
  Future<void> cacheExamples(List<ExampleModel> examples);
}

class ExampleLocalDataSourceImpl implements ExampleLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedExamplesKey = 'CACHED_EXAMPLES';

  ExampleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ExampleModel>> getCachedExamples() {
    final jsonString = sharedPreferences.getString(cachedExamplesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((json) => ExampleModel.fromJson(json)).toList(),
      );
    } else {
      throw CacheException('No cached data found');
    }
  }

  @override
  Future<void> cacheExamples(List<ExampleModel> examples) {
    final jsonString = json.encode(
      examples.map((example) => example.toJson()).toList(),
    );
    return sharedPreferences.setString(cachedExamplesKey, jsonString);
  }
}
