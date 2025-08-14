import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather/features/home/widgets/floating_glows.dart';

import 'controller/home_controller.dart';
import 'weather_controller.dart';
import 'widgets/background_gradient.dart';
import 'widgets/weather_hero_card.dart';
import 'package:weather/utils/error.dart';
import 'package:weather/utils/time_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(homeControllerProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = ref
        .watch(timeProvider)
        .maybeWhen(data: (t) => t, orElse: () => DateTime.now());
    final formatted = DateFormat('EEEE, dd MMM yyyy – HH:mm:ss').format(now);

    final home = ref.read(homeControllerProvider.notifier);
    final homeState = ref.watch(homeControllerProvider);

    final currentState = ref.watch(weatherControllerProvider);
    final searchState = ref.watch(searchWeatherControllerProvider);

    final showCenterLoader =
        (currentState.isLoading && (currentState.value == null));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Center(
          child: const Text(
            'WEATHER APP',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundGradient()),
          const FloatingGlows(),

          SafeArea(
            child: Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
                iconTheme: const IconThemeData(color: Colors.white70),
                dividerTheme: const DividerThemeData(
                  color: Colors.white24,
                  thickness: 1,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.08),
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIconColor: Colors.white70,
                  suffixIconColor: Colors.white70,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: Colors.white70, width: 1.4),
                  ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54, width: 1.2),
                    backgroundColor: Colors.white.withOpacity(0.06),
                    shape: const StadiumBorder(),
                  ),
                ),
                progressIndicatorTheme: const ProgressIndicatorThemeData(
                  color: Colors.white,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thursday, 14 Aug 2025 – 10:54:10' ==
                                  'ignore' // keep analyzer quiet
                              ? ''
                              : formatted,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70, fontSize: 20),
                        ),
                        const SizedBox(height: 15),

                        TextField(
                          controller: home.cityController,
                          decoration: const InputDecoration(
                            labelText: 'Search city',
                            hintText: 'e.g. Jakarta',
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          onSubmitted:
                              (_) =>
                                  homeState.cityQuery.trim().isEmpty
                                      ? null
                                      : home.search(),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      children: [
                        if (showCenterLoader) const _CenterLoader(),

                        // List konten bisa di-scroll: current + hasil pencarian
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 96),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // === CURRENT LOCATION CARD ===
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  10,
                                  16,
                                  10,
                                ),
                                child: Text(
                                  'Current location',
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(color: Colors.white70),
                                ),
                              ),
                              Builder(
                                builder: (_) {
                                  return currentState.when(
                                    loading: () => const SizedBox.shrink(),
                                    error:
                                        (e, _) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Text(
                                            friendlyError(e),
                                            style: const TextStyle(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                    data:
                                        (w) =>
                                            w == null
                                                ? const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  child: Text(
                                                    'Location data unavailable.',
                                                  ),
                                                )
                                                : WeatherHeroCard(
                                                  w,
                                                  minHeight: 190,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                  flatBottom: false,
                                                ),
                                  );
                                },
                              ),

                              // === SEARCH RESULT CARD ===
                              if (homeState.cityQuery.isNotEmpty ||
                                  searchState.value != null ||
                                  searchState.isLoading) ...[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    10,
                                    16,
                                    10,
                                  ),
                                  child: Text(
                                    'Search result'
                                    '${homeState.cityQuery.isNotEmpty ? "  ${homeState.cityQuery}" : ""}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                ),
                                searchState.when(
                                  loading:
                                      () => const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: _InlineLoader(),
                                      ),
                                  error:
                                      (e, _) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          friendlyError(e),
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                  data:
                                      (w) =>
                                          w == null
                                              ? const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                ),
                                                child: Text(
                                                  'Type a city name and press Enter.',
                                                ),
                                              )
                                              : WeatherHeroCard(
                                                w,
                                                minHeight: 190,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12,
                                                    ),
                                                flatBottom: false,
                                              ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: _LogoutButton(
                onLogout: () async {
                  if (!context.mounted) return;
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterLoader extends StatelessWidget {
  const _CenterLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}

class _InlineLoader extends StatelessWidget {
  const _InlineLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onLogout});
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    const start = Color(0xFF7859F6);
    const end = Color(0xFFE35D76);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [start, end],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x807C5CFF),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () async {
            HapticFeedback.selectionClick();
            await onLogout();
          },
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .3,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
