import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_summary_state.freezed.dart';

enum StorageSummaryStatus { loading, ready, failure }

/// What the library costs this device: how many books it holds, and how much
/// of the disk the audio copied for them takes.
@freezed
abstract class StorageSummaryState with _$StorageSummaryState {
  const factory StorageSummaryState({
    @Default(StorageSummaryStatus.loading) StorageSummaryStatus status,
    @Default(0) int bookCount,
    @Default(0) int usedBytes,
  }) = _StorageSummaryState;
}
