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
  TextColumn get chapterId => text().references(
    AudiobookChapterRows,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get positionMs => integer()();
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
  int get schemaVersion => 1;
}
