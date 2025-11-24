import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/example_bloc.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExampleBloc>()..add(GetExamplesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Examples'),
        ),
        body: BlocBuilder<ExampleBloc, ExampleState>(
          builder: (context, state) {
            if (state is ExampleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExampleLoaded) {
              return ListView.builder(
                itemCount: state.examples.length,
                itemBuilder: (context, index) {
                  final example = state.examples[index];
                  return ListTile(
                    title: Text(example.title),
                    subtitle: Text('ID: ${example.id}'),
                  );
                },
              );
            } else if (state is ExampleError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Press button to load'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<ExampleBloc>().add(GetExamplesEvent());
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
