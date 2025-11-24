part of 'example_bloc.dart';

abstract class ExampleState extends Equatable {
  const ExampleState();
  
  @override
  List<Object> get props => [];
}

class ExampleInitial extends ExampleState {}

class ExampleLoading extends ExampleState {}

class ExampleLoaded extends ExampleState {
  final List<ExampleEntity> examples;

  const ExampleLoaded({required this.examples});

  @override
  List<Object> get props => [examples];
}

class ExampleError extends ExampleState {
  final String message;

  const ExampleError({required this.message});

  @override
  List<Object> get props => [message];
}
