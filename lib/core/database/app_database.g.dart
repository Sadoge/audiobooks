// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AudiobookRowsTable extends AudiobookRows
    with TableInfo<$AudiobookRowsTable, AudiobookRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudiobookRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _narratorMeta = const VerificationMeta(
    'narrator',
  );
  @override
  late final GeneratedColumn<String> narrator = GeneratedColumn<String>(
    'narrator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentPositionMsMeta = const VerificationMeta(
    'currentPositionMs',
  );
  @override
  late final GeneratedColumn<int> currentPositionMs = GeneratedColumn<int>(
    'current_position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFinishedMeta = const VerificationMeta(
    'isFinished',
  );
  @override
  late final GeneratedColumn<bool> isFinished = GeneratedColumn<bool>(
    'is_finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_finished" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourcePathMeta = const VerificationMeta(
    'sourcePath',
  );
  @override
  late final GeneratedColumn<String> sourcePath = GeneratedColumn<String>(
    'source_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    narrator,
    coverPath,
    durationMs,
    currentPositionMs,
    dateAdded,
    lastPlayedAt,
    isFinished,
    fileType,
    sourcePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audiobook_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudiobookRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('narrator')) {
      context.handle(
        _narratorMeta,
        narrator.isAcceptableOrUnknown(data['narrator']!, _narratorMeta),
      );
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('current_position_ms')) {
      context.handle(
        _currentPositionMsMeta,
        currentPositionMs.isAcceptableOrUnknown(
          data['current_position_ms']!,
          _currentPositionMsMeta,
        ),
      );
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_finished')) {
      context.handle(
        _isFinishedMeta,
        isFinished.isAcceptableOrUnknown(data['is_finished']!, _isFinishedMeta),
      );
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('source_path')) {
      context.handle(
        _sourcePathMeta,
        sourcePath.isAcceptableOrUnknown(data['source_path']!, _sourcePathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudiobookRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudiobookRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      narrator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}narrator'],
      ),
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      currentPositionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_position_ms'],
      )!,
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      )!,
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_at'],
      ),
      isFinished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_finished'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      )!,
      sourcePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_path'],
      ),
    );
  }

  @override
  $AudiobookRowsTable createAlias(String alias) {
    return $AudiobookRowsTable(attachedDatabase, alias);
  }
}

class AudiobookRow extends DataClass implements Insertable<AudiobookRow> {
  final String id;
  final String title;
  final String author;
  final String? narrator;
  final String? coverPath;
  final int durationMs;
  final int currentPositionMs;
  final DateTime dateAdded;
  final DateTime? lastPlayedAt;
  final bool isFinished;
  final String fileType;
  final String? sourcePath;
  const AudiobookRow({
    required this.id,
    required this.title,
    required this.author,
    this.narrator,
    this.coverPath,
    required this.durationMs,
    required this.currentPositionMs,
    required this.dateAdded,
    this.lastPlayedAt,
    required this.isFinished,
    required this.fileType,
    this.sourcePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    if (!nullToAbsent || narrator != null) {
      map['narrator'] = Variable<String>(narrator);
    }
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    map['duration_ms'] = Variable<int>(durationMs);
    map['current_position_ms'] = Variable<int>(currentPositionMs);
    map['date_added'] = Variable<DateTime>(dateAdded);
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    }
    map['is_finished'] = Variable<bool>(isFinished);
    map['file_type'] = Variable<String>(fileType);
    if (!nullToAbsent || sourcePath != null) {
      map['source_path'] = Variable<String>(sourcePath);
    }
    return map;
  }

  AudiobookRowsCompanion toCompanion(bool nullToAbsent) {
    return AudiobookRowsCompanion(
      id: Value(id),
      title: Value(title),
      author: Value(author),
      narrator: narrator == null && nullToAbsent
          ? const Value.absent()
          : Value(narrator),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      durationMs: Value(durationMs),
      currentPositionMs: Value(currentPositionMs),
      dateAdded: Value(dateAdded),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedAt),
      isFinished: Value(isFinished),
      fileType: Value(fileType),
      sourcePath: sourcePath == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcePath),
    );
  }

  factory AudiobookRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudiobookRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      narrator: serializer.fromJson<String?>(json['narrator']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      currentPositionMs: serializer.fromJson<int>(json['currentPositionMs']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      lastPlayedAt: serializer.fromJson<DateTime?>(json['lastPlayedAt']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
      fileType: serializer.fromJson<String>(json['fileType']),
      sourcePath: serializer.fromJson<String?>(json['sourcePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'narrator': serializer.toJson<String?>(narrator),
      'coverPath': serializer.toJson<String?>(coverPath),
      'durationMs': serializer.toJson<int>(durationMs),
      'currentPositionMs': serializer.toJson<int>(currentPositionMs),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'lastPlayedAt': serializer.toJson<DateTime?>(lastPlayedAt),
      'isFinished': serializer.toJson<bool>(isFinished),
      'fileType': serializer.toJson<String>(fileType),
      'sourcePath': serializer.toJson<String?>(sourcePath),
    };
  }

  AudiobookRow copyWith({
    String? id,
    String? title,
    String? author,
    Value<String?> narrator = const Value.absent(),
    Value<String?> coverPath = const Value.absent(),
    int? durationMs,
    int? currentPositionMs,
    DateTime? dateAdded,
    Value<DateTime?> lastPlayedAt = const Value.absent(),
    bool? isFinished,
    String? fileType,
    Value<String?> sourcePath = const Value.absent(),
  }) => AudiobookRow(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author ?? this.author,
    narrator: narrator.present ? narrator.value : this.narrator,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    durationMs: durationMs ?? this.durationMs,
    currentPositionMs: currentPositionMs ?? this.currentPositionMs,
    dateAdded: dateAdded ?? this.dateAdded,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
    isFinished: isFinished ?? this.isFinished,
    fileType: fileType ?? this.fileType,
    sourcePath: sourcePath.present ? sourcePath.value : this.sourcePath,
  );
  AudiobookRow copyWithCompanion(AudiobookRowsCompanion data) {
    return AudiobookRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      narrator: data.narrator.present ? data.narrator.value : this.narrator,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      currentPositionMs: data.currentPositionMs.present
          ? data.currentPositionMs.value
          : this.currentPositionMs,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
      isFinished: data.isFinished.present
          ? data.isFinished.value
          : this.isFinished,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      sourcePath: data.sourcePath.present
          ? data.sourcePath.value
          : this.sourcePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudiobookRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('narrator: $narrator, ')
          ..write('coverPath: $coverPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('currentPositionMs: $currentPositionMs, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('isFinished: $isFinished, ')
          ..write('fileType: $fileType, ')
          ..write('sourcePath: $sourcePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    author,
    narrator,
    coverPath,
    durationMs,
    currentPositionMs,
    dateAdded,
    lastPlayedAt,
    isFinished,
    fileType,
    sourcePath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudiobookRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.narrator == this.narrator &&
          other.coverPath == this.coverPath &&
          other.durationMs == this.durationMs &&
          other.currentPositionMs == this.currentPositionMs &&
          other.dateAdded == this.dateAdded &&
          other.lastPlayedAt == this.lastPlayedAt &&
          other.isFinished == this.isFinished &&
          other.fileType == this.fileType &&
          other.sourcePath == this.sourcePath);
}

class AudiobookRowsCompanion extends UpdateCompanion<AudiobookRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> author;
  final Value<String?> narrator;
  final Value<String?> coverPath;
  final Value<int> durationMs;
  final Value<int> currentPositionMs;
  final Value<DateTime> dateAdded;
  final Value<DateTime?> lastPlayedAt;
  final Value<bool> isFinished;
  final Value<String> fileType;
  final Value<String?> sourcePath;
  final Value<int> rowid;
  const AudiobookRowsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.narrator = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.currentPositionMs = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.fileType = const Value.absent(),
    this.sourcePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudiobookRowsCompanion.insert({
    required String id,
    required String title,
    required String author,
    this.narrator = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.currentPositionMs = const Value.absent(),
    required DateTime dateAdded,
    this.lastPlayedAt = const Value.absent(),
    this.isFinished = const Value.absent(),
    required String fileType,
    this.sourcePath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       author = Value(author),
       dateAdded = Value(dateAdded),
       fileType = Value(fileType);
  static Insertable<AudiobookRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? narrator,
    Expression<String>? coverPath,
    Expression<int>? durationMs,
    Expression<int>? currentPositionMs,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? lastPlayedAt,
    Expression<bool>? isFinished,
    Expression<String>? fileType,
    Expression<String>? sourcePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (narrator != null) 'narrator': narrator,
      if (coverPath != null) 'cover_path': coverPath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (currentPositionMs != null) 'current_position_ms': currentPositionMs,
      if (dateAdded != null) 'date_added': dateAdded,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (isFinished != null) 'is_finished': isFinished,
      if (fileType != null) 'file_type': fileType,
      if (sourcePath != null) 'source_path': sourcePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudiobookRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? author,
    Value<String?>? narrator,
    Value<String?>? coverPath,
    Value<int>? durationMs,
    Value<int>? currentPositionMs,
    Value<DateTime>? dateAdded,
    Value<DateTime?>? lastPlayedAt,
    Value<bool>? isFinished,
    Value<String>? fileType,
    Value<String?>? sourcePath,
    Value<int>? rowid,
  }) {
    return AudiobookRowsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      narrator: narrator ?? this.narrator,
      coverPath: coverPath ?? this.coverPath,
      durationMs: durationMs ?? this.durationMs,
      currentPositionMs: currentPositionMs ?? this.currentPositionMs,
      dateAdded: dateAdded ?? this.dateAdded,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      isFinished: isFinished ?? this.isFinished,
      fileType: fileType ?? this.fileType,
      sourcePath: sourcePath ?? this.sourcePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (narrator.present) {
      map['narrator'] = Variable<String>(narrator.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (currentPositionMs.present) {
      map['current_position_ms'] = Variable<int>(currentPositionMs.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (sourcePath.present) {
      map['source_path'] = Variable<String>(sourcePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudiobookRowsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('narrator: $narrator, ')
          ..write('coverPath: $coverPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('currentPositionMs: $currentPositionMs, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('isFinished: $isFinished, ')
          ..write('fileType: $fileType, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AudiobookChapterRowsTable extends AudiobookChapterRows
    with TableInfo<$AudiobookChapterRowsTable, AudiobookChapterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudiobookChapterRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audiobook_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIndexMeta = const VerificationMeta(
    'chapterIndex',
  );
  @override
  late final GeneratedColumn<int> chapterIndex = GeneratedColumn<int>(
    'chapter_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startPositionMsMeta = const VerificationMeta(
    'startPositionMs',
  );
  @override
  late final GeneratedColumn<int> startPositionMs = GeneratedColumn<int>(
    'start_position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    title,
    chapterIndex,
    filePath,
    durationMs,
    startPositionMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audiobook_chapter_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudiobookChapterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('chapter_index')) {
      context.handle(
        _chapterIndexMeta,
        chapterIndex.isAcceptableOrUnknown(
          data['chapter_index']!,
          _chapterIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chapterIndexMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('start_position_ms')) {
      context.handle(
        _startPositionMsMeta,
        startPositionMs.isAcceptableOrUnknown(
          data['start_position_ms']!,
          _startPositionMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudiobookChapterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudiobookChapterRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      chapterIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_index'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      startPositionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_position_ms'],
      )!,
    );
  }

  @override
  $AudiobookChapterRowsTable createAlias(String alias) {
    return $AudiobookChapterRowsTable(attachedDatabase, alias);
  }
}

class AudiobookChapterRow extends DataClass
    implements Insertable<AudiobookChapterRow> {
  final String id;
  final String bookId;
  final String title;
  final int chapterIndex;
  final String filePath;
  final int durationMs;
  final int startPositionMs;
  const AudiobookChapterRow({
    required this.id,
    required this.bookId,
    required this.title,
    required this.chapterIndex,
    required this.filePath,
    required this.durationMs,
    required this.startPositionMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['title'] = Variable<String>(title);
    map['chapter_index'] = Variable<int>(chapterIndex);
    map['file_path'] = Variable<String>(filePath);
    map['duration_ms'] = Variable<int>(durationMs);
    map['start_position_ms'] = Variable<int>(startPositionMs);
    return map;
  }

  AudiobookChapterRowsCompanion toCompanion(bool nullToAbsent) {
    return AudiobookChapterRowsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      title: Value(title),
      chapterIndex: Value(chapterIndex),
      filePath: Value(filePath),
      durationMs: Value(durationMs),
      startPositionMs: Value(startPositionMs),
    );
  }

  factory AudiobookChapterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudiobookChapterRow(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      title: serializer.fromJson<String>(json['title']),
      chapterIndex: serializer.fromJson<int>(json['chapterIndex']),
      filePath: serializer.fromJson<String>(json['filePath']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      startPositionMs: serializer.fromJson<int>(json['startPositionMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'title': serializer.toJson<String>(title),
      'chapterIndex': serializer.toJson<int>(chapterIndex),
      'filePath': serializer.toJson<String>(filePath),
      'durationMs': serializer.toJson<int>(durationMs),
      'startPositionMs': serializer.toJson<int>(startPositionMs),
    };
  }

  AudiobookChapterRow copyWith({
    String? id,
    String? bookId,
    String? title,
    int? chapterIndex,
    String? filePath,
    int? durationMs,
    int? startPositionMs,
  }) => AudiobookChapterRow(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    title: title ?? this.title,
    chapterIndex: chapterIndex ?? this.chapterIndex,
    filePath: filePath ?? this.filePath,
    durationMs: durationMs ?? this.durationMs,
    startPositionMs: startPositionMs ?? this.startPositionMs,
  );
  AudiobookChapterRow copyWithCompanion(AudiobookChapterRowsCompanion data) {
    return AudiobookChapterRow(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      title: data.title.present ? data.title.value : this.title,
      chapterIndex: data.chapterIndex.present
          ? data.chapterIndex.value
          : this.chapterIndex,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      startPositionMs: data.startPositionMs.present
          ? data.startPositionMs.value
          : this.startPositionMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudiobookChapterRow(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('title: $title, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs, ')
          ..write('startPositionMs: $startPositionMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    title,
    chapterIndex,
    filePath,
    durationMs,
    startPositionMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudiobookChapterRow &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.title == this.title &&
          other.chapterIndex == this.chapterIndex &&
          other.filePath == this.filePath &&
          other.durationMs == this.durationMs &&
          other.startPositionMs == this.startPositionMs);
}

class AudiobookChapterRowsCompanion
    extends UpdateCompanion<AudiobookChapterRow> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> title;
  final Value<int> chapterIndex;
  final Value<String> filePath;
  final Value<int> durationMs;
  final Value<int> startPositionMs;
  final Value<int> rowid;
  const AudiobookChapterRowsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.title = const Value.absent(),
    this.chapterIndex = const Value.absent(),
    this.filePath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.startPositionMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudiobookChapterRowsCompanion.insert({
    required String id,
    required String bookId,
    required String title,
    required int chapterIndex,
    required String filePath,
    this.durationMs = const Value.absent(),
    this.startPositionMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       title = Value(title),
       chapterIndex = Value(chapterIndex),
       filePath = Value(filePath);
  static Insertable<AudiobookChapterRow> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? title,
    Expression<int>? chapterIndex,
    Expression<String>? filePath,
    Expression<int>? durationMs,
    Expression<int>? startPositionMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (title != null) 'title': title,
      if (chapterIndex != null) 'chapter_index': chapterIndex,
      if (filePath != null) 'file_path': filePath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (startPositionMs != null) 'start_position_ms': startPositionMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudiobookChapterRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? title,
    Value<int>? chapterIndex,
    Value<String>? filePath,
    Value<int>? durationMs,
    Value<int>? startPositionMs,
    Value<int>? rowid,
  }) {
    return AudiobookChapterRowsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      filePath: filePath ?? this.filePath,
      durationMs: durationMs ?? this.durationMs,
      startPositionMs: startPositionMs ?? this.startPositionMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (chapterIndex.present) {
      map['chapter_index'] = Variable<int>(chapterIndex.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (startPositionMs.present) {
      map['start_position_ms'] = Variable<int>(startPositionMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudiobookChapterRowsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('title: $title, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs, ')
          ..write('startPositionMs: $startPositionMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaybackProgressRowsTable extends PlaybackProgressRows
    with TableInfo<$PlaybackProgressRowsTable, PlaybackProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaybackProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audiobook_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audiobook_chapter_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMsMeta = const VerificationMeta(
    'positionMs',
  );
  @override
  late final GeneratedColumn<int> positionMs = GeneratedColumn<int>(
    'position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bookId,
    chapterId,
    positionMs,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playback_progress_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaybackProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('position_ms')) {
      context.handle(
        _positionMsMeta,
        positionMs.isAcceptableOrUnknown(data['position_ms']!, _positionMsMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bookId};
  @override
  PlaybackProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaybackProgressRow(
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      positionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_ms'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlaybackProgressRowsTable createAlias(String alias) {
    return $PlaybackProgressRowsTable(attachedDatabase, alias);
  }
}

class PlaybackProgressRow extends DataClass
    implements Insertable<PlaybackProgressRow> {
  final String bookId;
  final String chapterId;
  final int positionMs;
  final DateTime updatedAt;
  const PlaybackProgressRow({
    required this.bookId,
    required this.chapterId,
    required this.positionMs,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book_id'] = Variable<String>(bookId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['position_ms'] = Variable<int>(positionMs);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlaybackProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return PlaybackProgressRowsCompanion(
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      positionMs: Value(positionMs),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlaybackProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaybackProgressRow(
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      positionMs: serializer.fromJson<int>(json['positionMs']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bookId': serializer.toJson<String>(bookId),
      'chapterId': serializer.toJson<String>(chapterId),
      'positionMs': serializer.toJson<int>(positionMs),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlaybackProgressRow copyWith({
    String? bookId,
    String? chapterId,
    int? positionMs,
    DateTime? updatedAt,
  }) => PlaybackProgressRow(
    bookId: bookId ?? this.bookId,
    chapterId: chapterId ?? this.chapterId,
    positionMs: positionMs ?? this.positionMs,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlaybackProgressRow copyWithCompanion(PlaybackProgressRowsCompanion data) {
    return PlaybackProgressRow(
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      positionMs: data.positionMs.present
          ? data.positionMs.value
          : this.positionMs,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackProgressRow(')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('positionMs: $positionMs, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(bookId, chapterId, positionMs, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaybackProgressRow &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.positionMs == this.positionMs &&
          other.updatedAt == this.updatedAt);
}

class PlaybackProgressRowsCompanion
    extends UpdateCompanion<PlaybackProgressRow> {
  final Value<String> bookId;
  final Value<String> chapterId;
  final Value<int> positionMs;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlaybackProgressRowsCompanion({
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.positionMs = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaybackProgressRowsCompanion.insert({
    required String bookId,
    required String chapterId,
    required int positionMs,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : bookId = Value(bookId),
       chapterId = Value(chapterId),
       positionMs = Value(positionMs),
       updatedAt = Value(updatedAt);
  static Insertable<PlaybackProgressRow> custom({
    Expression<String>? bookId,
    Expression<String>? chapterId,
    Expression<int>? positionMs,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (positionMs != null) 'position_ms': positionMs,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaybackProgressRowsCompanion copyWith({
    Value<String>? bookId,
    Value<String>? chapterId,
    Value<int>? positionMs,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlaybackProgressRowsCompanion(
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      positionMs: positionMs ?? this.positionMs,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (positionMs.present) {
      map['position_ms'] = Variable<int>(positionMs.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackProgressRowsCompanion(')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('positionMs: $positionMs, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarkRowsTable extends BookmarkRows
    with TableInfo<$BookmarkRowsTable, BookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarkRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audiobook_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES audiobook_chapter_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMsMeta = const VerificationMeta(
    'positionMs',
  );
  @override
  late final GeneratedColumn<int> positionMs = GeneratedColumn<int>(
    'position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    chapterId,
    positionMs,
    title,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmark_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('position_ms')) {
      context.handle(
        _positionMsMeta,
        positionMs.isAcceptableOrUnknown(data['position_ms']!, _positionMsMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMsMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      positionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_ms'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookmarkRowsTable createAlias(String alias) {
    return $BookmarkRowsTable(attachedDatabase, alias);
  }
}

class BookmarkRow extends DataClass implements Insertable<BookmarkRow> {
  final String id;
  final String bookId;
  final String chapterId;
  final int positionMs;
  final String title;
  final DateTime createdAt;
  const BookmarkRow({
    required this.id,
    required this.bookId,
    required this.chapterId,
    required this.positionMs,
    required this.title,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['position_ms'] = Variable<int>(positionMs);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarkRowsCompanion toCompanion(bool nullToAbsent) {
    return BookmarkRowsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      positionMs: Value(positionMs),
      title: Value(title),
      createdAt: Value(createdAt),
    );
  }

  factory BookmarkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkRow(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      positionMs: serializer.fromJson<int>(json['positionMs']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'chapterId': serializer.toJson<String>(chapterId),
      'positionMs': serializer.toJson<int>(positionMs),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BookmarkRow copyWith({
    String? id,
    String? bookId,
    String? chapterId,
    int? positionMs,
    String? title,
    DateTime? createdAt,
  }) => BookmarkRow(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    chapterId: chapterId ?? this.chapterId,
    positionMs: positionMs ?? this.positionMs,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
  );
  BookmarkRow copyWithCompanion(BookmarkRowsCompanion data) {
    return BookmarkRow(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      positionMs: data.positionMs.present
          ? data.positionMs.value
          : this.positionMs,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRow(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('positionMs: $positionMs, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, chapterId, positionMs, title, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkRow &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.positionMs == this.positionMs &&
          other.title == this.title &&
          other.createdAt == this.createdAt);
}

class BookmarkRowsCompanion extends UpdateCompanion<BookmarkRow> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> chapterId;
  final Value<int> positionMs;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BookmarkRowsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.positionMs = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarkRowsCompanion.insert({
    required String id,
    required String bookId,
    required String chapterId,
    required int positionMs,
    required String title,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       chapterId = Value(chapterId),
       positionMs = Value(positionMs),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<BookmarkRow> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? chapterId,
    Expression<int>? positionMs,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (positionMs != null) 'position_ms': positionMs,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarkRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? chapterId,
    Value<int>? positionMs,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BookmarkRowsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      positionMs: positionMs ?? this.positionMs,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (positionMs.present) {
      map['position_ms'] = Variable<int>(positionMs.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRowsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('positionMs: $positionMs, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AudiobookRowsTable audiobookRows = $AudiobookRowsTable(this);
  late final $AudiobookChapterRowsTable audiobookChapterRows =
      $AudiobookChapterRowsTable(this);
  late final $PlaybackProgressRowsTable playbackProgressRows =
      $PlaybackProgressRowsTable(this);
  late final $BookmarkRowsTable bookmarkRows = $BookmarkRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    audiobookRows,
    audiobookChapterRows,
    playbackProgressRows,
    bookmarkRows,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audiobook_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('audiobook_chapter_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audiobook_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('playback_progress_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audiobook_chapter_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('playback_progress_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audiobook_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmark_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'audiobook_chapter_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmark_rows', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AudiobookRowsTableCreateCompanionBuilder =
    AudiobookRowsCompanion Function({
      required String id,
      required String title,
      required String author,
      Value<String?> narrator,
      Value<String?> coverPath,
      Value<int> durationMs,
      Value<int> currentPositionMs,
      required DateTime dateAdded,
      Value<DateTime?> lastPlayedAt,
      Value<bool> isFinished,
      required String fileType,
      Value<String?> sourcePath,
      Value<int> rowid,
    });
typedef $$AudiobookRowsTableUpdateCompanionBuilder =
    AudiobookRowsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> author,
      Value<String?> narrator,
      Value<String?> coverPath,
      Value<int> durationMs,
      Value<int> currentPositionMs,
      Value<DateTime> dateAdded,
      Value<DateTime?> lastPlayedAt,
      Value<bool> isFinished,
      Value<String> fileType,
      Value<String?> sourcePath,
      Value<int> rowid,
    });

final class $$AudiobookRowsTableReferences
    extends BaseReferences<_$AppDatabase, $AudiobookRowsTable, AudiobookRow> {
  $$AudiobookRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $AudiobookChapterRowsTable,
    List<AudiobookChapterRow>
  >
  _audiobookChapterRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.audiobookChapterRows,
        aliasName: 'audiobook_rows__id__audiobook_chapter_rows__book_id',
      );

  $$AudiobookChapterRowsTableProcessedTableManager
  get audiobookChapterRowsRefs {
    final manager = $$AudiobookChapterRowsTableTableManager(
      $_db,
      $_db.audiobookChapterRows,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _audiobookChapterRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PlaybackProgressRowsTable,
    List<PlaybackProgressRow>
  >
  _playbackProgressRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.playbackProgressRows,
        aliasName: 'audiobook_rows__id__playback_progress_rows__book_id',
      );

  $$PlaybackProgressRowsTableProcessedTableManager
  get playbackProgressRowsRefs {
    final manager = $$PlaybackProgressRowsTableTableManager(
      $_db,
      $_db.playbackProgressRows,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _playbackProgressRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookmarkRowsTable, List<BookmarkRow>>
  _bookmarkRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookmarkRows,
    aliasName: 'audiobook_rows__id__bookmark_rows__book_id',
  );

  $$BookmarkRowsTableProcessedTableManager get bookmarkRowsRefs {
    final manager = $$BookmarkRowsTableTableManager(
      $_db,
      $_db.bookmarkRows,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarkRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AudiobookRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AudiobookRowsTable> {
  $$AudiobookRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get narrator => $composableBuilder(
    column: $table.narrator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPositionMs => $composableBuilder(
    column: $table.currentPositionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> audiobookChapterRowsRefs(
    Expression<bool> Function($$AudiobookChapterRowsTableFilterComposer f) f,
  ) {
    final $$AudiobookChapterRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audiobookChapterRows,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookChapterRowsTableFilterComposer(
            $db: $db,
            $table: $db.audiobookChapterRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playbackProgressRowsRefs(
    Expression<bool> Function($$PlaybackProgressRowsTableFilterComposer f) f,
  ) {
    final $$PlaybackProgressRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playbackProgressRows,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaybackProgressRowsTableFilterComposer(
            $db: $db,
            $table: $db.playbackProgressRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookmarkRowsRefs(
    Expression<bool> Function($$BookmarkRowsTableFilterComposer f) f,
  ) {
    final $$BookmarkRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarkRows,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarkRowsTableFilterComposer(
            $db: $db,
            $table: $db.bookmarkRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AudiobookRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AudiobookRowsTable> {
  $$AudiobookRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get narrator => $composableBuilder(
    column: $table.narrator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPositionMs => $composableBuilder(
    column: $table.currentPositionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AudiobookRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudiobookRowsTable> {
  $$AudiobookRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get narrator =>
      $composableBuilder(column: $table.narrator, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentPositionMs => $composableBuilder(
    column: $table.currentPositionMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => column,
  );

  Expression<T> audiobookChapterRowsRefs<T extends Object>(
    Expression<T> Function($$AudiobookChapterRowsTableAnnotationComposer a) f,
  ) {
    final $$AudiobookChapterRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.audiobookChapterRows,
          getReferencedColumn: (t) => t.bookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AudiobookChapterRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.audiobookChapterRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> playbackProgressRowsRefs<T extends Object>(
    Expression<T> Function($$PlaybackProgressRowsTableAnnotationComposer a) f,
  ) {
    final $$PlaybackProgressRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.playbackProgressRows,
          getReferencedColumn: (t) => t.bookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PlaybackProgressRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.playbackProgressRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> bookmarkRowsRefs<T extends Object>(
    Expression<T> Function($$BookmarkRowsTableAnnotationComposer a) f,
  ) {
    final $$BookmarkRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarkRows,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarkRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.bookmarkRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AudiobookRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AudiobookRowsTable,
          AudiobookRow,
          $$AudiobookRowsTableFilterComposer,
          $$AudiobookRowsTableOrderingComposer,
          $$AudiobookRowsTableAnnotationComposer,
          $$AudiobookRowsTableCreateCompanionBuilder,
          $$AudiobookRowsTableUpdateCompanionBuilder,
          (AudiobookRow, $$AudiobookRowsTableReferences),
          AudiobookRow,
          PrefetchHooks Function({
            bool audiobookChapterRowsRefs,
            bool playbackProgressRowsRefs,
            bool bookmarkRowsRefs,
          })
        > {
  $$AudiobookRowsTableTableManager(_$AppDatabase db, $AudiobookRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudiobookRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudiobookRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudiobookRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String?> narrator = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> currentPositionMs = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<String> fileType = const Value.absent(),
                Value<String?> sourcePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudiobookRowsCompanion(
                id: id,
                title: title,
                author: author,
                narrator: narrator,
                coverPath: coverPath,
                durationMs: durationMs,
                currentPositionMs: currentPositionMs,
                dateAdded: dateAdded,
                lastPlayedAt: lastPlayedAt,
                isFinished: isFinished,
                fileType: fileType,
                sourcePath: sourcePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String author,
                Value<String?> narrator = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> currentPositionMs = const Value.absent(),
                required DateTime dateAdded,
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                required String fileType,
                Value<String?> sourcePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudiobookRowsCompanion.insert(
                id: id,
                title: title,
                author: author,
                narrator: narrator,
                coverPath: coverPath,
                durationMs: durationMs,
                currentPositionMs: currentPositionMs,
                dateAdded: dateAdded,
                lastPlayedAt: lastPlayedAt,
                isFinished: isFinished,
                fileType: fileType,
                sourcePath: sourcePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AudiobookRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                audiobookChapterRowsRefs = false,
                playbackProgressRowsRefs = false,
                bookmarkRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (audiobookChapterRowsRefs) db.audiobookChapterRows,
                    if (playbackProgressRowsRefs) db.playbackProgressRows,
                    if (bookmarkRowsRefs) db.bookmarkRows,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (audiobookChapterRowsRefs)
                        await $_getPrefetchedData<
                          AudiobookRow,
                          $AudiobookRowsTable,
                          AudiobookChapterRow
                        >(
                          currentTable: table,
                          referencedTable: $$AudiobookRowsTableReferences
                              ._audiobookChapterRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AudiobookRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).audiobookChapterRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (playbackProgressRowsRefs)
                        await $_getPrefetchedData<
                          AudiobookRow,
                          $AudiobookRowsTable,
                          PlaybackProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$AudiobookRowsTableReferences
                              ._playbackProgressRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AudiobookRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).playbackProgressRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookmarkRowsRefs)
                        await $_getPrefetchedData<
                          AudiobookRow,
                          $AudiobookRowsTable,
                          BookmarkRow
                        >(
                          currentTable: table,
                          referencedTable: $$AudiobookRowsTableReferences
                              ._bookmarkRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AudiobookRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).bookmarkRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AudiobookRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AudiobookRowsTable,
      AudiobookRow,
      $$AudiobookRowsTableFilterComposer,
      $$AudiobookRowsTableOrderingComposer,
      $$AudiobookRowsTableAnnotationComposer,
      $$AudiobookRowsTableCreateCompanionBuilder,
      $$AudiobookRowsTableUpdateCompanionBuilder,
      (AudiobookRow, $$AudiobookRowsTableReferences),
      AudiobookRow,
      PrefetchHooks Function({
        bool audiobookChapterRowsRefs,
        bool playbackProgressRowsRefs,
        bool bookmarkRowsRefs,
      })
    >;
typedef $$AudiobookChapterRowsTableCreateCompanionBuilder =
    AudiobookChapterRowsCompanion Function({
      required String id,
      required String bookId,
      required String title,
      required int chapterIndex,
      required String filePath,
      Value<int> durationMs,
      Value<int> startPositionMs,
      Value<int> rowid,
    });
typedef $$AudiobookChapterRowsTableUpdateCompanionBuilder =
    AudiobookChapterRowsCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> title,
      Value<int> chapterIndex,
      Value<String> filePath,
      Value<int> durationMs,
      Value<int> startPositionMs,
      Value<int> rowid,
    });

final class $$AudiobookChapterRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AudiobookChapterRowsTable,
          AudiobookChapterRow
        > {
  $$AudiobookChapterRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AudiobookRowsTable _bookIdTable(_$AppDatabase db) => db.audiobookRows
      .createAlias('audiobook_chapter_rows__book_id__audiobook_rows__id');

  $$AudiobookRowsTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$AudiobookRowsTableTableManager(
      $_db,
      $_db.audiobookRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $PlaybackProgressRowsTable,
    List<PlaybackProgressRow>
  >
  _playbackProgressRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.playbackProgressRows,
        aliasName:
            'audiobook_chapter_rows__id__playback_progress_rows__chapter_id',
      );

  $$PlaybackProgressRowsTableProcessedTableManager
  get playbackProgressRowsRefs {
    final manager = $$PlaybackProgressRowsTableTableManager(
      $_db,
      $_db.playbackProgressRows,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _playbackProgressRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookmarkRowsTable, List<BookmarkRow>>
  _bookmarkRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookmarkRows,
    aliasName: 'audiobook_chapter_rows__id__bookmark_rows__chapter_id',
  );

  $$BookmarkRowsTableProcessedTableManager get bookmarkRowsRefs {
    final manager = $$BookmarkRowsTableTableManager(
      $_db,
      $_db.bookmarkRows,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarkRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AudiobookChapterRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AudiobookChapterRowsTable> {
  $$AudiobookChapterRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startPositionMs => $composableBuilder(
    column: $table.startPositionMs,
    builder: (column) => ColumnFilters(column),
  );

  $$AudiobookRowsTableFilterComposer get bookId {
    final $$AudiobookRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.audiobookRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookRowsTableFilterComposer(
            $db: $db,
            $table: $db.audiobookRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> playbackProgressRowsRefs(
    Expression<bool> Function($$PlaybackProgressRowsTableFilterComposer f) f,
  ) {
    final $$PlaybackProgressRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playbackProgressRows,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaybackProgressRowsTableFilterComposer(
            $db: $db,
            $table: $db.playbackProgressRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookmarkRowsRefs(
    Expression<bool> Function($$BookmarkRowsTableFilterComposer f) f,
  ) {
    final $$BookmarkRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarkRows,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarkRowsTableFilterComposer(
            $db: $db,
            $table: $db.bookmarkRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AudiobookChapterRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AudiobookChapterRowsTable> {
  $$AudiobookChapterRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startPositionMs => $composableBuilder(
    column: $table.startPositionMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$AudiobookRowsTableOrderingComposer get bookId {
    final $$AudiobookRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.audiobookRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookRowsTableOrderingComposer(
            $db: $db,
            $table: $db.audiobookRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudiobookChapterRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudiobookChapterRowsTable> {
  $$AudiobookChapterRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startPositionMs => $composableBuilder(
    column: $table.startPositionMs,
    builder: (column) => column,
  );

  $$AudiobookRowsTableAnnotationComposer get bookId {
    final $$AudiobookRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.audiobookRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.audiobookRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> playbackProgressRowsRefs<T extends Object>(
    Expression<T> Function($$PlaybackProgressRowsTableAnnotationComposer a) f,
  ) {
    final $$PlaybackProgressRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.playbackProgressRows,
          getReferencedColumn: (t) => t.chapterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PlaybackProgressRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.playbackProgressRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> bookmarkRowsRefs<T extends Object>(
    Expression<T> Function($$BookmarkRowsTableAnnotationComposer a) f,
  ) {
    final $$BookmarkRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarkRows,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarkRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.bookmarkRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AudiobookChapterRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AudiobookChapterRowsTable,
          AudiobookChapterRow,
          $$AudiobookChapterRowsTableFilterComposer,
          $$AudiobookChapterRowsTableOrderingComposer,
          $$AudiobookChapterRowsTableAnnotationComposer,
          $$AudiobookChapterRowsTableCreateCompanionBuilder,
          $$AudiobookChapterRowsTableUpdateCompanionBuilder,
          (AudiobookChapterRow, $$AudiobookChapterRowsTableReferences),
          AudiobookChapterRow,
          PrefetchHooks Function({
            bool bookId,
            bool playbackProgressRowsRefs,
            bool bookmarkRowsRefs,
          })
        > {
  $$AudiobookChapterRowsTableTableManager(
    _$AppDatabase db,
    $AudiobookChapterRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudiobookChapterRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudiobookChapterRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AudiobookChapterRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> chapterIndex = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> startPositionMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudiobookChapterRowsCompanion(
                id: id,
                bookId: bookId,
                title: title,
                chapterIndex: chapterIndex,
                filePath: filePath,
                durationMs: durationMs,
                startPositionMs: startPositionMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String title,
                required int chapterIndex,
                required String filePath,
                Value<int> durationMs = const Value.absent(),
                Value<int> startPositionMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudiobookChapterRowsCompanion.insert(
                id: id,
                bookId: bookId,
                title: title,
                chapterIndex: chapterIndex,
                filePath: filePath,
                durationMs: durationMs,
                startPositionMs: startPositionMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AudiobookChapterRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bookId = false,
                playbackProgressRowsRefs = false,
                bookmarkRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playbackProgressRowsRefs) db.playbackProgressRows,
                    if (bookmarkRowsRefs) db.bookmarkRows,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable:
                                        $$AudiobookChapterRowsTableReferences
                                            ._bookIdTable(db),
                                    referencedColumn:
                                        $$AudiobookChapterRowsTableReferences
                                            ._bookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playbackProgressRowsRefs)
                        await $_getPrefetchedData<
                          AudiobookChapterRow,
                          $AudiobookChapterRowsTable,
                          PlaybackProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$AudiobookChapterRowsTableReferences
                              ._playbackProgressRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AudiobookChapterRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).playbackProgressRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookmarkRowsRefs)
                        await $_getPrefetchedData<
                          AudiobookChapterRow,
                          $AudiobookChapterRowsTable,
                          BookmarkRow
                        >(
                          currentTable: table,
                          referencedTable: $$AudiobookChapterRowsTableReferences
                              ._bookmarkRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AudiobookChapterRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).bookmarkRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AudiobookChapterRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AudiobookChapterRowsTable,
      AudiobookChapterRow,
      $$AudiobookChapterRowsTableFilterComposer,
      $$AudiobookChapterRowsTableOrderingComposer,
      $$AudiobookChapterRowsTableAnnotationComposer,
      $$AudiobookChapterRowsTableCreateCompanionBuilder,
      $$AudiobookChapterRowsTableUpdateCompanionBuilder,
      (AudiobookChapterRow, $$AudiobookChapterRowsTableReferences),
      AudiobookChapterRow,
      PrefetchHooks Function({
        bool bookId,
        bool playbackProgressRowsRefs,
        bool bookmarkRowsRefs,
      })
    >;
typedef $$PlaybackProgressRowsTableCreateCompanionBuilder =
    PlaybackProgressRowsCompanion Function({
      required String bookId,
      required String chapterId,
      required int positionMs,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlaybackProgressRowsTableUpdateCompanionBuilder =
    PlaybackProgressRowsCompanion Function({
      Value<String> bookId,
      Value<String> chapterId,
      Value<int> positionMs,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlaybackProgressRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PlaybackProgressRowsTable,
          PlaybackProgressRow
        > {
  $$PlaybackProgressRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AudiobookRowsTable _bookIdTable(_$AppDatabase db) => db.audiobookRows
      .createAlias('playback_progress_rows__book_id__audiobook_rows__id');

  $$AudiobookRowsTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$AudiobookRowsTableTableManager(
      $_db,
      $_db.audiobookRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AudiobookChapterRowsTable _chapterIdTable(_$AppDatabase db) =>
      db.audiobookChapterRows.createAlias(
        'playback_progress_rows__chapter_id__audiobook_chapter_rows__id',
      );

  $$AudiobookChapterRowsTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager = $$AudiobookChapterRowsTableTableManager(
      $_db,
      $_db.audiobookChapterRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlaybackProgressRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaybackProgressRowsTable> {
  $$PlaybackProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AudiobookRowsTableFilterComposer get bookId {
    final $$AudiobookRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.audiobookRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookRowsTableFilterComposer(
            $db: $db,
            $table: $db.audiobookRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudiobookChapterRowsTableFilterComposer get chapterId {
    final $$AudiobookChapterRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.audiobookChapterRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookChapterRowsTableFilterComposer(
            $db: $db,
            $table: $db.audiobookChapterRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackProgressRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaybackProgressRowsTable> {
  $$PlaybackProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AudiobookRowsTableOrderingComposer get bookId {
    final $$AudiobookRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.audiobookRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookRowsTableOrderingComposer(
            $db: $db,
            $table: $db.audiobookRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudiobookChapterRowsTableOrderingComposer get chapterId {
    final $$AudiobookChapterRowsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.chapterId,
          referencedTable: $db.audiobookChapterRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AudiobookChapterRowsTableOrderingComposer(
                $db: $db,
                $table: $db.audiobookChapterRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PlaybackProgressRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaybackProgressRowsTable> {
  $$PlaybackProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AudiobookRowsTableAnnotationComposer get bookId {
    final $$AudiobookRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.audiobookRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.audiobookRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudiobookChapterRowsTableAnnotationComposer get chapterId {
    final $$AudiobookChapterRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.chapterId,
          referencedTable: $db.audiobookChapterRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AudiobookChapterRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.audiobookChapterRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PlaybackProgressRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaybackProgressRowsTable,
          PlaybackProgressRow,
          $$PlaybackProgressRowsTableFilterComposer,
          $$PlaybackProgressRowsTableOrderingComposer,
          $$PlaybackProgressRowsTableAnnotationComposer,
          $$PlaybackProgressRowsTableCreateCompanionBuilder,
          $$PlaybackProgressRowsTableUpdateCompanionBuilder,
          (PlaybackProgressRow, $$PlaybackProgressRowsTableReferences),
          PlaybackProgressRow,
          PrefetchHooks Function({bool bookId, bool chapterId})
        > {
  $$PlaybackProgressRowsTableTableManager(
    _$AppDatabase db,
    $PlaybackProgressRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaybackProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaybackProgressRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PlaybackProgressRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> bookId = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<int> positionMs = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackProgressRowsCompanion(
                bookId: bookId,
                chapterId: chapterId,
                positionMs: positionMs,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bookId,
                required String chapterId,
                required int positionMs,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlaybackProgressRowsCompanion.insert(
                bookId: bookId,
                chapterId: chapterId,
                positionMs: positionMs,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaybackProgressRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$PlaybackProgressRowsTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$PlaybackProgressRowsTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable:
                                    $$PlaybackProgressRowsTableReferences
                                        ._chapterIdTable(db),
                                referencedColumn:
                                    $$PlaybackProgressRowsTableReferences
                                        ._chapterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaybackProgressRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaybackProgressRowsTable,
      PlaybackProgressRow,
      $$PlaybackProgressRowsTableFilterComposer,
      $$PlaybackProgressRowsTableOrderingComposer,
      $$PlaybackProgressRowsTableAnnotationComposer,
      $$PlaybackProgressRowsTableCreateCompanionBuilder,
      $$PlaybackProgressRowsTableUpdateCompanionBuilder,
      (PlaybackProgressRow, $$PlaybackProgressRowsTableReferences),
      PlaybackProgressRow,
      PrefetchHooks Function({bool bookId, bool chapterId})
    >;
typedef $$BookmarkRowsTableCreateCompanionBuilder =
    BookmarkRowsCompanion Function({
      required String id,
      required String bookId,
      required String chapterId,
      required int positionMs,
      required String title,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BookmarkRowsTableUpdateCompanionBuilder =
    BookmarkRowsCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> chapterId,
      Value<int> positionMs,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BookmarkRowsTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarkRowsTable, BookmarkRow> {
  $$BookmarkRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AudiobookRowsTable _bookIdTable(_$AppDatabase db) => db.audiobookRows
      .createAlias('bookmark_rows__book_id__audiobook_rows__id');

  $$AudiobookRowsTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$AudiobookRowsTableTableManager(
      $_db,
      $_db.audiobookRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AudiobookChapterRowsTable _chapterIdTable(_$AppDatabase db) => db
      .audiobookChapterRows
      .createAlias('bookmark_rows__chapter_id__audiobook_chapter_rows__id');

  $$AudiobookChapterRowsTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager = $$AudiobookChapterRowsTableTableManager(
      $_db,
      $_db.audiobookChapterRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookmarkRowsTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarkRowsTable> {
  $$BookmarkRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AudiobookRowsTableFilterComposer get bookId {
    final $$AudiobookRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.audiobookRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookRowsTableFilterComposer(
            $db: $db,
            $table: $db.audiobookRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudiobookChapterRowsTableFilterComposer get chapterId {
    final $$AudiobookChapterRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.audiobookChapterRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookChapterRowsTableFilterComposer(
            $db: $db,
            $table: $db.audiobookChapterRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarkRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarkRowsTable> {
  $$BookmarkRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AudiobookRowsTableOrderingComposer get bookId {
    final $$AudiobookRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.audiobookRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookRowsTableOrderingComposer(
            $db: $db,
            $table: $db.audiobookRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudiobookChapterRowsTableOrderingComposer get chapterId {
    final $$AudiobookChapterRowsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.chapterId,
          referencedTable: $db.audiobookChapterRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AudiobookChapterRowsTableOrderingComposer(
                $db: $db,
                $table: $db.audiobookChapterRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BookmarkRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarkRowsTable> {
  $$BookmarkRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AudiobookRowsTableAnnotationComposer get bookId {
    final $$AudiobookRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.audiobookRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudiobookRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.audiobookRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AudiobookChapterRowsTableAnnotationComposer get chapterId {
    final $$AudiobookChapterRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.chapterId,
          referencedTable: $db.audiobookChapterRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AudiobookChapterRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.audiobookChapterRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BookmarkRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarkRowsTable,
          BookmarkRow,
          $$BookmarkRowsTableFilterComposer,
          $$BookmarkRowsTableOrderingComposer,
          $$BookmarkRowsTableAnnotationComposer,
          $$BookmarkRowsTableCreateCompanionBuilder,
          $$BookmarkRowsTableUpdateCompanionBuilder,
          (BookmarkRow, $$BookmarkRowsTableReferences),
          BookmarkRow,
          PrefetchHooks Function({bool bookId, bool chapterId})
        > {
  $$BookmarkRowsTableTableManager(_$AppDatabase db, $BookmarkRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarkRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarkRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarkRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<int> positionMs = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarkRowsCompanion(
                id: id,
                bookId: bookId,
                chapterId: chapterId,
                positionMs: positionMs,
                title: title,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String chapterId,
                required int positionMs,
                required String title,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BookmarkRowsCompanion.insert(
                id: id,
                bookId: bookId,
                chapterId: chapterId,
                positionMs: positionMs,
                title: title,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookmarkRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$BookmarkRowsTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$BookmarkRowsTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable: $$BookmarkRowsTableReferences
                                    ._chapterIdTable(db),
                                referencedColumn: $$BookmarkRowsTableReferences
                                    ._chapterIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookmarkRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarkRowsTable,
      BookmarkRow,
      $$BookmarkRowsTableFilterComposer,
      $$BookmarkRowsTableOrderingComposer,
      $$BookmarkRowsTableAnnotationComposer,
      $$BookmarkRowsTableCreateCompanionBuilder,
      $$BookmarkRowsTableUpdateCompanionBuilder,
      (BookmarkRow, $$BookmarkRowsTableReferences),
      BookmarkRow,
      PrefetchHooks Function({bool bookId, bool chapterId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AudiobookRowsTableTableManager get audiobookRows =>
      $$AudiobookRowsTableTableManager(_db, _db.audiobookRows);
  $$AudiobookChapterRowsTableTableManager get audiobookChapterRows =>
      $$AudiobookChapterRowsTableTableManager(_db, _db.audiobookChapterRows);
  $$PlaybackProgressRowsTableTableManager get playbackProgressRows =>
      $$PlaybackProgressRowsTableTableManager(_db, _db.playbackProgressRows);
  $$BookmarkRowsTableTableManager get bookmarkRows =>
      $$BookmarkRowsTableTableManager(_db, _db.bookmarkRows);
}
