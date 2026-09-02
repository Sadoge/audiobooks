import 'package:freezed_annotation/freezed_annotation.dart';

part 'shelf_folder.freezed.dart';

/// How a chosen shared folder can be reached.
///
/// The distinction is Android's. Every other platform hands back a directory
/// that ordinary file APIs can open; Android may instead hand back a Storage
/// Access Framework tree, which only document operations can read. Naming the
/// difference here keeps it out of everything downstream, and lets a folder
/// that cannot be opened say so plainly instead of failing later on.
enum ShelfFolderAccess {
  /// A real directory. Read and written with ordinary file APIs.
  directory,

  /// An Android document tree, identified by a `content://` URI.
  documentTree,
}

/// The folder a listener has nominated to hold the shared library.
@freezed
abstract class ShelfFolder with _$ShelfFolder {
  const factory ShelfFolder({
    /// The directory path, or the document tree URI, depending on [access].
    required String location,
    required ShelfFolderAccess access,
  }) = _ShelfFolder;

  const ShelfFolder._();

  /// Whether this folder can be read and written by this build.
  ///
  /// A document tree is remembered so that the choice is not lost, but nothing
  /// can be listed out of it until the app grows the document operations to
  /// walk one.
  bool get isReadable => access == ShelfFolderAccess.directory;

  /// What to show for the folder, which for a document tree is all that can
  /// be shown: the URI is not a path anybody would recognise.
  String get displayName {
    if (access == ShelfFolderAccess.documentTree) return location;
    final parts = location.split(RegExp(r'[/\\]'))
      ..removeWhere((part) => part.isEmpty);
    return parts.isEmpty ? location : parts.last;
  }
}
