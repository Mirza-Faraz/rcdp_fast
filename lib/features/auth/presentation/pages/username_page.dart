import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'login_page.dart';

class UsernamePage extends StatelessWidget {
  const UsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const UsernameView(),
    );
  }
}

class UsernameView extends StatefulWidget {
  const UsernameView({super.key});

  @override
  State<UsernameView> createState() => _UsernameViewState();
}

class _UsernameViewState extends State<UsernameView> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B6FA5),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UsernameSaved) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => LoginPage(username: state.username),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome back. Log in to continue with smart financial loan application',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 80),
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Enter Username',
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Next',
                  onPressed: () {
                    final username = _usernameController.text.trim();
                    if (username.isNotEmpty) {
                      context.read<AuthBloc>().add(
                            SaveUsernameEvent(username: username),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a username'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
