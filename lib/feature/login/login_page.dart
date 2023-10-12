import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_live_searcher/utils/locator.dart';

import 'cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({Key? key}) : super(key: key);

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              state.maybeWhen(
                failure: (type) {
                  final String msg;
                  switch (type) {
                    case FailureType.noInternet:
                      msg = 'No internet';
                      break;
                    case FailureType.wrongToken:
                      msg = 'Wrong API token';
                      break;
                  }
                  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(msg),
                  ));
                },
                orElse: () => null,
              );
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Text('Giphy API token'),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: controller,
                    enabled: state.maybeMap(loading: (_) => false, orElse: () => true),
                  ),
                  const Spacer(),
                  Center(
                    child: OutlinedButton(
                      // TODO: style on disabled
                      onPressed: () => context.read<LoginCubit>().onContinue(controller.value.text),
                      child: const SizedBox(height: 50, width: 150, child: Center(child: Text('Proceed'))),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
