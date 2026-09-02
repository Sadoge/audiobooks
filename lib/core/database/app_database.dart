import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';

part 'app_database.g.dart';

@DataClassName('AudiobookRow')
class AudiobookRows extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text()();
  TextColumn get narrator => text().nullable()();
  TextColumn get coverPath => text().nullable()();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  IntColumn get currentPositionMs => integer().withDefault(const Constant(0))();
  DateTimeColumn get dateAdded => dateTime()();
  DateTimeColumn get lastPlayedAt => dateTime().nullable()();
  BoolColumn get isFinished => boolean().withDefault(const Constant(false))();
  TextColumn get fileType => text()();
  TextColumn get sourcePath => text().nullable()();

  /// The book's key in the shared library folder, when it came from there or
  /// was published to it. Null for a book that only ever lived on this device.
  TextColumn get shelfKey => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AudiobookChapterRow')
class AudiobookChapterRows extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(AudiobookRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  IntColumn get chapterIndex => integer()();
  TextColumn get filePath => text()();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  IntColumn get startPositionMs => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PlaybackProgressRow')
class PlaybackProgressRows extends Table {
  TextColumn get bookId =>
      text().references(AudiobookRows, #id, onDelete: KeyAction.cascade)();

  /// Null for books with no chapters. Deliberately not a foreign key: chapters
  /// are rewritten wholesale whenever a book is re-saved, and losing a
  /// listener's place to that is worse than holding an orphaned id.
  TextColumn get chapterId => text().nullable()();

  /// Offset inside the chapter, or inside the book when there is no chapter.
  IntColumn get positionMs => integer()();

  /// Offset on the whole book timeline.
  IntColumn get bookPositionMs => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {bookId};
}

@DataClassName('BookmarkRow')
class BookmarkRows extends Table {
  TextColumn get id => text()();
  TextColumn get bookId =>
      text().references(AudiobookRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get chapterId => text().references(
    AudiobookChapterRows,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get positionMs => integer()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@lazySingleton
@DriftDatabase(
  tables: [
    AudiobookRows,
    AudiobookChapterRows,
    PlaybackProgressRows,
    BookmarkRows,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'audiobooks'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        // Progress used to require a chapter, so chapterless books were never
        // resumable. Rebuild the table without that requirement and seed the
        // new book offset from the position already stored.
        await migrator.alterTable(
          TableMigration(
            playbackProgressRows,
            newColumns: [playbackProgressRows.bookPositionMs],
            columnTransformer: {
              playbackProgressRows.bookPositionMs:
                  playbackProgressRows.positionMs,
            },
          ),
        );
      }
      if (from < 3) {
        // Books already in the library predate the shared folder, so they
        // carry no key until one is published or downloaded.
        await migrator.addColumn(audiobookRows, audiobookRows.shelfKey);
      }
    },
  );
}
