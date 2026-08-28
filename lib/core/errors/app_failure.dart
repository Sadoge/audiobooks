sealed class AppFailure implements Exception {
  const AppFailure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

final class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message, {super.cause});
}

final class FileAccessFailure extends AppFailure {
  const FileAccessFailure(super.message, {super.cause});
}

final class PlaybackFailure extends AppFailure {
  const PlaybackFailure(super.message, {super.cause});
}
