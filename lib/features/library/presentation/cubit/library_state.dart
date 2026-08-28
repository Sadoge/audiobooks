import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_state.freezed.dart';

enum LibraryStatus { initial, loading, ready, failure }

@freezed
abstract class LibraryState with _$LibraryState {
  const factory LibraryState({
    @Default(LibraryStatus.initial) LibraryStatus status,
    @Default(<Audiobook>[]) List<Audiobook> books,
    String? errorMessage,

    /// The outcome of a one-off action on a book, shown once and then dropped.
    String? actionMessage,
  }) = _LibraryState;
}
