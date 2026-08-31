import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/features/settings/domain/entities/app_theme_preference.dart';
import 'package:audiobooks/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChromeAppBar(title: Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: [
          const _SectionHeading('Appearance'),
          const SizedBox(height: AppSpacing.md),
          BlocBuilder<ThemeCubit, AppThemePreference>(
            builder: (context, preference) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final textScale = MediaQuery.textScalerOf(context).scale(1);
                  if (constraints.maxWidth < 360 || textScale > 1.3) {
                    return _ExpandedThemeChoices(preference: preference);
                  }
                  return SegmentedButton<AppThemePreference>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: AppThemePreference.system,
                        icon: Icon(Icons.brightness_auto_outlined),
                        label: Text('System'),
                      ),
                      ButtonSegment(
                        value: AppThemePreference.light,
                        icon: Icon(Icons.light_mode_outlined),
                        label: Text('Light'),
                      ),
                      ButtonSegment(
                        value: AppThemePreference.dark,
                        icon: Icon(Icons.dark_mode_outlined),
                        label: Text('Dark'),
                      ),
                    ],
                    selected: {preference},
                    onSelectionChanged: (selection) => context
                        .read<ThemeCubit>()
                        .setPreference(selection.single),
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionHeading('Playback'),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Playback defaults'),
            subtitle: Text('Speed and seek intervals arrive with the player.'),
          ),
        ],
      ),
    );
  }
}

/// A settings group is titled the way a device panel was: a small heading
/// with a rule ruled straight underneath it.
class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        const Divider(),
      ],
    );
  }
}

class _ExpandedThemeChoices extends StatelessWidget {
  const _ExpandedThemeChoices({required this.preference});

  final AppThemePreference preference;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: AppThemePreference.values.map((value) {
        final selected = preference == value;
        return Semantics(
          selected: selected,
          button: true,
          child: ListTile(
            minTileHeight: 56,
            contentPadding: EdgeInsets.zero,
            leading: Icon(_iconFor(value)),
            title: Text(_labelFor(value)),
            trailing: selected ? const Icon(Icons.check_rounded) : null,
            onTap: () => context.read<ThemeCubit>().setPreference(value),
          ),
        );
      }).toList(),
    );
  }

  IconData _iconFor(AppThemePreference value) => switch (value) {
    AppThemePreference.system => Icons.brightness_auto_outlined,
    AppThemePreference.light => Icons.light_mode_outlined,
    AppThemePreference.dark => Icons.dark_mode_outlined,
  };

  String _labelFor(AppThemePreference value) => switch (value) {
    AppThemePreference.system => 'System',
    AppThemePreference.light => 'Light',
    AppThemePreference.dark => 'Dark',
  };
}
