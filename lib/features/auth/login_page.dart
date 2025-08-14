import 'package:flutter/material.dart';
import 'package:weather/features/home/widgets/background_gradient.dart';
import 'package:weather/features/home/widgets/floating_glows.dart';
import 'package:weather/features/home/widgets/glass.dart';
import 'package:weather/features/home/widgets/glass_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: _username.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundGradient(),
          const FloatingGlows(),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'WEATHER APP',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to Check the Weather?',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 244, 243, 245),
                              Color(0xFFE35D76),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Glass(
                        // ← glass card
                        radius: 22,
                        padding: const EdgeInsets.all(18),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GlassField(
                                label: 'Username',
                                controller: _username,
                                icon: Icons.person_rounded,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),
                              GlassField(
                                label: 'Password',
                                controller: _password,
                                icon: Icons.lock_rounded,
                                obscure: _obscure,
                                onToggleObscure:
                                    () => setState(() => _obscure = !_obscure),
                                onSubmitted: (_) => _onSubmit(),
                              ),
                              const SizedBox(height: 40),

                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: _submitting ? null : _onSubmit,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7859F6),
                                          Color(0xFFE35D76),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child:
                                          _submitting
                                              ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                        Colors.white,
                                                      ),
                                                ),
                                              )
                                              : const Text('Sign in'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
