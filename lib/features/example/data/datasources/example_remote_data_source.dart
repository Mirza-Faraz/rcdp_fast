import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/example_model.dart';

abstract class ExampleRemoteDataSource {
  Future<List<ExampleModel>> getExamples();
  Future<ExampleModel> getExampleById(int id);
}

class ExampleRemoteDataSourceImpl implements ExampleRemoteDataSource {
  final Dio client;

  ExampleRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ExampleModel>> getExamples() async {
    try {
      final response = await client.get('https://api.example.com/examples');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ExampleModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load examples');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ExampleModel> getExampleById(int id) async {
    try {
      final response = await client.get('https://api.example.com/examples/$id');
      
      if (response.statusCode == 200) {
        return ExampleModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to load example');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
