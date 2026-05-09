import 'package:flutter/material.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.15,
            colors: [Color(0xFF171326), Color(0xFF07080D)],
            stops: [0, 0.58],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: _AuthCard(
                  title: title,
                  subtitle: subtitle,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xEA11131B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2D3B)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8B6FF).withValues(alpha: 0.22),
            blurRadius: 54,
            spreadRadius: 1,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.38),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0x1FC8B6FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0x33C8B6FF)),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFFC8B6FF),
            ),
          ),
          const SizedBox(height: 22),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 28),
          child,
        ],
      ),
    );
  }
}
