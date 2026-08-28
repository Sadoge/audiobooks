import 'package:audiobooks/core/audio/metadata/cover_art.dart';
import 'package:audiobooks/core/files/picked_audio_file.dart';

/// Isolates document-provider access and future security-scoped URI handling.
abstract interface class DeviceFileGateway {
  Future<List<PickedAudioFile>> pickAudioFiles({bool allowMultiple = true});

  /// Lets the listener choose an image to stand in as a book's cover.
  /// Returns null when the picker is dismissed.
  Future<String?> pickCoverImage();

  /// Copies provider-backed temporary files into app-owned durable storage.
  /// The copy is streamed by the platform file APIs and is never loaded whole.
  Future<String> persist(PickedAudioFile file, {required String bookId});

  /// Writes artwork read out of a media file beside the book it belongs to,
  /// returning where it landed, or null when it could not be stored.
  ///
  /// A missing cover is never worth failing an import over, so this reports
  /// trouble by returning null rather than by throwing.
  Future<String?> persistCoverBytes(CoverArt cover, {required String bookId});

  /// Copies an image already on the device — one the listener chose, or one
  /// sitting beside the audio — into the book's own folder.
  Future<String?> persistCoverFile(String sourcePath, {required String bookId});

  /// An image in the folder [file] was chosen from, which is how a book split
  /// into tracks usually carries its cover. Null when the folder holds none,
  /// or cannot be listed, as on platforms that hand over a single file.
  Future<String?> findCoverBeside(PickedAudioFile file);

  /// Deletes everything copied for a book that is leaving the library.
  Future<void> deleteBookFiles(String bookId);

  Future<bool> canRead(String durablePathOrUri);
}
