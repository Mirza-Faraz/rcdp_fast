import 'package:equatable/equatable.dart';

class ExampleEntity extends Equatable {
  final int id;
  final String title;

  const ExampleEntity({
    required this.id,
    required this.title,
  });

  @override
  List<Object> get props => [id, title];
}
