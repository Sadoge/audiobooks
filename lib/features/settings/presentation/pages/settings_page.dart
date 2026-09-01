import 'package:audiobooks/app/di/configure_dependencies.dart';
import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/theme/retro_chrome.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/features/settings/domain/entities/app_theme_preference.dart';
import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/presentation/cubit/playback_settings_cubit.dart';
import 'package:audiobooks/features/settings/presentation/cubit/lock_screen_cubit.dart';
import 'package:audiobooks/features/settings/presentation/cubit/lock_screen_state.dart';
import 'package:audiobooks/features/settings/presentation/cubit/storage_summary_cubit.dart';
import 'package:audiobooks/features/settings/presentation/cubit/storage_summary_state.dart';
import 'package:audiobooks/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingsPage extends StatelessWidget implements AutoRouteWrapper {
  const SettingsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<PlaybackSettingsCubit>()..load()),
      BlocProvider(create: (_) => getIt<StorageSummaryCubit>()..measure()),
      BlocProvider(create: (_) => getIt<LockScreenCubit>()..check()),
    ],
    child: this,
  );

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
          const _AppearanceChoice(),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionHeading('Playback'),
          const _PlaybackChoices(),
          const _LockScreenRow(),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionHeading('Library'),
          const _StorageRow(),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionHeading('About'),
          const _AboutRows(),
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

class _AppearanceChoice extends StatelessWidget {
  const _AppearanceChoice();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemePreference>(
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
              onSelectionChanged: (selection) =>
                  context.read<ThemeCubit>().setPreference(selection.single),
            );
          },
        );
      },
    );
  }
}

/// What every book opens on: the speed it plays at, what the wheel's skip
/// keys step by, and how far back a resumed book picks up.
class _PlaybackChoices extends StatelessWidget {
  const _PlaybackChoices();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackSettingsCubit, PlaybackSettings>(
      builder: (context, settings) {
        final cubit = context.read<PlaybackSettingsCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ChoiceRow<double>(
              title: 'Speed',
              subtitle: 'Every book opens at this speed.',
              value: settings.speed,
              options: PlaybackOptions.speeds,
              labelOf: PlaybackOptions.speedLabel,
              onSelected: cubit.setSpeed,
            ),
            const Divider(),
            _ChoiceRow<Duration>(
              title: 'Rewind key',
              subtitle: 'What the left key steps back by.',
              value: settings.rewindInterval,
              options: PlaybackOptions.rewindIntervals,
              labelOf: _secondsLabel,
              onSelected: cubit.setRewindInterval,
            ),
            const Divider(),
            _ChoiceRow<Duration>(
              title: 'Forward key',
              subtitle: 'What the right key steps on by.',
              value: settings.forwardInterval,
              options: PlaybackOptions.forwardIntervals,
              labelOf: _secondsLabel,
              onSelected: cubit.setForwardInterval,
            ),
            const Divider(),
            _ChoiceRow<Duration>(
              title: 'Rewind on resume',
              subtitle: 'Picks a book up just before you left it.',
              value: settings.resumeRewind,
              options: PlaybackOptions.resumeRewinds,
              labelOf: _secondsLabel,
              onSelected: cubit.setResumeRewind,
            ),
          ],
        );
      },
    );
  }
}

/// What the library costs this device.
///
/// Imported audio is copied into the app, and removing a book is the only
/// thing that gives that space back, so the row says so plainly.
/// Whether a book will show up outside the app, and the way to fix it when it
/// will not.
///
/// Playing a book and showing it are separate things: a book plays perfectly
/// with the notification declined, which otherwise leaves a listener unable to
/// tell a permission they said no to from something actually broken.
class _LockScreenRow extends StatelessWidget {
  const _LockScreenRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LockScreenCubit, LockScreenState>(
      builder: (context, state) {
        final row = _SettingsRow(
          title: 'Lock screen controls',
          subtitle: switch (state.status) {
            LockScreenStatus.checking => 'Checking.',
            LockScreenStatus.working =>
              'A book you are listening to appears on the lock screen and in '
                  'the notification shade, with its cover and its transport.',
            LockScreenStatus.notPermitted =>
              'Your book plays, but it cannot show itself: this app is not '
                  'allowed to post notifications, and the lock screen '
                  'controls are one.',
            LockScreenStatus.unavailable =>
              state.errorMessage ??
                  'This device offers no place to put the player outside the '
                      'app.',
          },
          value: switch (state.status) {
            LockScreenStatus.checking => '—',
            LockScreenStatus.working => 'On',
            LockScreenStatus.notPermitted => 'Blocked',
            LockScreenStatus.unavailable => 'Off',
          },
        );

        if (state.status != LockScreenStatus.notPermitted) return row;

        // The permission sheet only ever appears once, so the only way back is
        // the system's own settings.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            row,
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.xs,
                bottom: AppSpacing.xs,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: FilledButton.tonal(
                  onPressed: context.read<LockScreenCubit>().openSettings,
                  child: const Text('Allow notifications'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StorageRow extends StatelessWidget {
  const _StorageRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageSummaryCubit, StorageSummaryState>(
      builder: (context, state) {
        final value = switch (state.status) {
          StorageSummaryStatus.loading => '—',
          StorageSummaryStatus.failure => 'Unknown',
          StorageSummaryStatus.ready => _formatBytes(state.usedBytes),
        };
        final books = switch (state.bookCount) {
          0 => 'Nothing imported yet.',
          1 =>
            '1 audiobook is copied into this app. Removing it from the '
                'library gives its space back.',
          final count =>
            '$count audiobooks are copied into this app. Removing one from '
                'the library gives its space back.',
        };

        return _SettingsRow(
          title: 'Storage used',
          subtitle: state.status == StorageSummaryStatus.loading
              ? 'Measuring the audio copied into this app.'
              : books,
          value: value,
        );
      },
    );
  }
}

class _AboutRows extends StatelessWidget {
  const _AboutRows();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SettingsRow(
          title: 'Offline by design',
          subtitle:
              'Your books and where you are in them stay on this device. '
              'No account, no sync, nothing sent anywhere.',
        ),
        const Divider(),
        ListTile(
          minTileHeight: 56,
          contentPadding: EdgeInsets.zero,
          title: const Text('Licences'),
          subtitle: const Text(
            'The bundled typefaces and open-source components.',
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Theme.of(context).colorScheme.outline,
          ),
          onTap: () =>
              showLicensePage(context: context, applicationName: 'Audiobooks'),
        ),
      ],
    );
  }
}

/// One line of a settings panel: what it is, what it means, and where it
/// stands. Anything measured stands in the readout face.
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.title, required this.subtitle, this.value});

  final String title;
  final String subtitle;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: theme.textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (value case final measured?) ...[
            const SizedBox(width: AppSpacing.md),
            _ReadoutValue(measured),
          ],
        ],
      ),
    );
  }
}

/// Where a setting stands, shown the way the device showed a figure: on a
/// small pane of recessed glass, in the readout face.
class _ReadoutValue extends StatelessWidget {
  const _ReadoutValue(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return ScreenPanel(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      child: Text(
        value,
        style: AppFonts.readout(
          Theme.of(context).textTheme.bodyMedium,
        ).copyWith(color: RetroChrome.of(context).screenInk),
      ),
    );
  }
}

/// A setting whose value is one of a short list: the row states where it
/// stands, and opens the list as a native menu.
class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final T value;
  final List<T> options;
  final String Function(T value) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      value: labelOf(value),
      child: ExcludeSemantics(
        child: PopupMenuButton<T>(
          tooltip: title,
          initialValue: value,
          onSelected: onSelected,
          itemBuilder: (context) => [
            for (final option in options)
              PopupMenuItem<T>(
                value: option,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        labelOf(option),
                        style: AppFonts.readout(theme.textTheme.bodyLarge),
                      ),
                    ),
                    if (option == value)
                      const Icon(Icons.check_rounded, size: AppIconSize.small),
                  ],
                ),
              ),
          ],
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Row(
              children: [
                Expanded(
                  child: _SettingsRow(title: title, subtitle: subtitle),
                ),
                const SizedBox(width: AppSpacing.md),
                _ReadoutValue(labelOf(value)),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.expand_more_rounded,
                  size: AppIconSize.small,
                  color: theme.colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
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

/// Skip intervals are printed the way the keys are: a number of seconds, or
/// the plain word for the one that does nothing.
String _secondsLabel(Duration interval) =>
    interval <= Duration.zero ? 'Off' : '${interval.inSeconds}s';

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  const units = ['KB', 'MB', 'GB', 'TB'];
  var value = bytes / 1024;
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${value.toStringAsFixed(value >= 10 ? 0 : 1)} ${units[unit]}';
}
