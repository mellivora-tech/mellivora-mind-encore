// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AudioItemsTable extends AudioItems
    with TableInfo<$AudioItemsTable, AudioItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationMsMeta =
      const VerificationMeta('durationMs');
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
      'duration_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _transcriptionStatusMeta =
      const VerificationMeta('transcriptionStatus');
  @override
  late final GeneratedColumn<String> transcriptionStatus =
      GeneratedColumn<String>('transcription_status', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, filePath, durationMs, transcriptionStatus, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_items';
  @override
  VerificationContext validateIntegrity(Insertable<AudioItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
          _durationMsMeta,
          durationMs.isAcceptableOrUnknown(
              data['duration_ms']!, _durationMsMeta));
    }
    if (data.containsKey('transcription_status')) {
      context.handle(
          _transcriptionStatusMeta,
          transcriptionStatus.isAcceptableOrUnknown(
              data['transcription_status']!, _transcriptionStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudioItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      durationMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_ms']),
      transcriptionStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transcription_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AudioItemsTable createAlias(String alias) {
    return $AudioItemsTable(attachedDatabase, alias);
  }
}

class AudioItem extends DataClass implements Insertable<AudioItem> {
  final String id;
  final String title;
  final String filePath;
  final int? durationMs;
  final String transcriptionStatus;
  final DateTime createdAt;
  const AudioItem(
      {required this.id,
      required this.title,
      required this.filePath,
      this.durationMs,
      required this.transcriptionStatus,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['transcription_status'] = Variable<String>(transcriptionStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AudioItemsCompanion toCompanion(bool nullToAbsent) {
    return AudioItemsCompanion(
      id: Value(id),
      title: Value(title),
      filePath: Value(filePath),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      transcriptionStatus: Value(transcriptionStatus),
      createdAt: Value(createdAt),
    );
  }

  factory AudioItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioItem(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      filePath: serializer.fromJson<String>(json['filePath']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      transcriptionStatus:
          serializer.fromJson<String>(json['transcriptionStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'filePath': serializer.toJson<String>(filePath),
      'durationMs': serializer.toJson<int?>(durationMs),
      'transcriptionStatus': serializer.toJson<String>(transcriptionStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AudioItem copyWith(
          {String? id,
          String? title,
          String? filePath,
          Value<int?> durationMs = const Value.absent(),
          String? transcriptionStatus,
          DateTime? createdAt}) =>
      AudioItem(
        id: id ?? this.id,
        title: title ?? this.title,
        filePath: filePath ?? this.filePath,
        durationMs: durationMs.present ? durationMs.value : this.durationMs,
        transcriptionStatus: transcriptionStatus ?? this.transcriptionStatus,
        createdAt: createdAt ?? this.createdAt,
      );
  AudioItem copyWithCompanion(AudioItemsCompanion data) {
    return AudioItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
      transcriptionStatus: data.transcriptionStatus.present
          ? data.transcriptionStatus.value
          : this.transcriptionStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs, ')
          ..write('transcriptionStatus: $transcriptionStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, filePath, durationMs, transcriptionStatus, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.filePath == this.filePath &&
          other.durationMs == this.durationMs &&
          other.transcriptionStatus == this.transcriptionStatus &&
          other.createdAt == this.createdAt);
}

class AudioItemsCompanion extends UpdateCompanion<AudioItem> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> filePath;
  final Value<int?> durationMs;
  final Value<String> transcriptionStatus;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AudioItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.filePath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.transcriptionStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudioItemsCompanion.insert({
    required String id,
    required String title,
    required String filePath,
    this.durationMs = const Value.absent(),
    this.transcriptionStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        filePath = Value(filePath);
  static Insertable<AudioItem> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? filePath,
    Expression<int>? durationMs,
    Expression<String>? transcriptionStatus,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (filePath != null) 'file_path': filePath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (transcriptionStatus != null)
        'transcription_status': transcriptionStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudioItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? filePath,
      Value<int?>? durationMs,
      Value<String>? transcriptionStatus,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AudioItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      durationMs: durationMs ?? this.durationMs,
      transcriptionStatus: transcriptionStatus ?? this.transcriptionStatus,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (transcriptionStatus.present) {
      map['transcription_status'] = Variable<String>(transcriptionStatus.value);
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
    return (StringBuffer('AudioItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs, ')
          ..write('transcriptionStatus: $transcriptionStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioIdMeta =
      const VerificationMeta('audioId');
  @override
  late final GeneratedColumn<String> audioId = GeneratedColumn<String>(
      'audio_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES audio_items (id)'));
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
      'index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _startMsMeta =
      const VerificationMeta('startMs');
  @override
  late final GeneratedColumn<int> startMs = GeneratedColumn<int>(
      'start_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endMsMeta = const VerificationMeta('endMs');
  @override
  late final GeneratedColumn<int> endMs = GeneratedColumn<int>(
      'end_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isHeardMeta =
      const VerificationMeta('isHeard');
  @override
  late final GeneratedColumn<bool> isHeard = GeneratedColumn<bool>(
      'is_heard', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_heard" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, audioId, index, title, startMs, endMs, isHeard];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(Insertable<Chapter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('audio_id')) {
      context.handle(_audioIdMeta,
          audioId.isAcceptableOrUnknown(data['audio_id']!, _audioIdMeta));
    } else if (isInserting) {
      context.missing(_audioIdMeta);
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('start_ms')) {
      context.handle(_startMsMeta,
          startMs.isAcceptableOrUnknown(data['start_ms']!, _startMsMeta));
    } else if (isInserting) {
      context.missing(_startMsMeta);
    }
    if (data.containsKey('end_ms')) {
      context.handle(
          _endMsMeta, endMs.isAcceptableOrUnknown(data['end_ms']!, _endMsMeta));
    } else if (isInserting) {
      context.missing(_endMsMeta);
    }
    if (data.containsKey('is_heard')) {
      context.handle(_isHeardMeta,
          isHeard.isAcceptableOrUnknown(data['is_heard']!, _isHeardMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      audioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_id'])!,
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      startMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_ms'])!,
      endMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_ms'])!,
      isHeard: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_heard'])!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String id;
  final String audioId;
  final int index;
  final String title;
  final int startMs;
  final int endMs;
  final bool isHeard;
  const Chapter(
      {required this.id,
      required this.audioId,
      required this.index,
      required this.title,
      required this.startMs,
      required this.endMs,
      required this.isHeard});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['audio_id'] = Variable<String>(audioId);
    map['index'] = Variable<int>(index);
    map['title'] = Variable<String>(title);
    map['start_ms'] = Variable<int>(startMs);
    map['end_ms'] = Variable<int>(endMs);
    map['is_heard'] = Variable<bool>(isHeard);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      audioId: Value(audioId),
      index: Value(index),
      title: Value(title),
      startMs: Value(startMs),
      endMs: Value(endMs),
      isHeard: Value(isHeard),
    );
  }

  factory Chapter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<String>(json['id']),
      audioId: serializer.fromJson<String>(json['audioId']),
      index: serializer.fromJson<int>(json['index']),
      title: serializer.fromJson<String>(json['title']),
      startMs: serializer.fromJson<int>(json['startMs']),
      endMs: serializer.fromJson<int>(json['endMs']),
      isHeard: serializer.fromJson<bool>(json['isHeard']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'audioId': serializer.toJson<String>(audioId),
      'index': serializer.toJson<int>(index),
      'title': serializer.toJson<String>(title),
      'startMs': serializer.toJson<int>(startMs),
      'endMs': serializer.toJson<int>(endMs),
      'isHeard': serializer.toJson<bool>(isHeard),
    };
  }

  Chapter copyWith(
          {String? id,
          String? audioId,
          int? index,
          String? title,
          int? startMs,
          int? endMs,
          bool? isHeard}) =>
      Chapter(
        id: id ?? this.id,
        audioId: audioId ?? this.audioId,
        index: index ?? this.index,
        title: title ?? this.title,
        startMs: startMs ?? this.startMs,
        endMs: endMs ?? this.endMs,
        isHeard: isHeard ?? this.isHeard,
      );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      id: data.id.present ? data.id.value : this.id,
      audioId: data.audioId.present ? data.audioId.value : this.audioId,
      index: data.index.present ? data.index.value : this.index,
      title: data.title.present ? data.title.value : this.title,
      startMs: data.startMs.present ? data.startMs.value : this.startMs,
      endMs: data.endMs.present ? data.endMs.value : this.endMs,
      isHeard: data.isHeard.present ? data.isHeard.value : this.isHeard,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('audioId: $audioId, ')
          ..write('index: $index, ')
          ..write('title: $title, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('isHeard: $isHeard')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, audioId, index, title, startMs, endMs, isHeard);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.audioId == this.audioId &&
          other.index == this.index &&
          other.title == this.title &&
          other.startMs == this.startMs &&
          other.endMs == this.endMs &&
          other.isHeard == this.isHeard);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> id;
  final Value<String> audioId;
  final Value<int> index;
  final Value<String> title;
  final Value<int> startMs;
  final Value<int> endMs;
  final Value<bool> isHeard;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.audioId = const Value.absent(),
    this.index = const Value.absent(),
    this.title = const Value.absent(),
    this.startMs = const Value.absent(),
    this.endMs = const Value.absent(),
    this.isHeard = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String audioId,
    required int index,
    this.title = const Value.absent(),
    required int startMs,
    required int endMs,
    this.isHeard = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        audioId = Value(audioId),
        index = Value(index),
        startMs = Value(startMs),
        endMs = Value(endMs);
  static Insertable<Chapter> custom({
    Expression<String>? id,
    Expression<String>? audioId,
    Expression<int>? index,
    Expression<String>? title,
    Expression<int>? startMs,
    Expression<int>? endMs,
    Expression<bool>? isHeard,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (audioId != null) 'audio_id': audioId,
      if (index != null) 'index': index,
      if (title != null) 'title': title,
      if (startMs != null) 'start_ms': startMs,
      if (endMs != null) 'end_ms': endMs,
      if (isHeard != null) 'is_heard': isHeard,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith(
      {Value<String>? id,
      Value<String>? audioId,
      Value<int>? index,
      Value<String>? title,
      Value<int>? startMs,
      Value<int>? endMs,
      Value<bool>? isHeard,
      Value<int>? rowid}) {
    return ChaptersCompanion(
      id: id ?? this.id,
      audioId: audioId ?? this.audioId,
      index: index ?? this.index,
      title: title ?? this.title,
      startMs: startMs ?? this.startMs,
      endMs: endMs ?? this.endMs,
      isHeard: isHeard ?? this.isHeard,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (audioId.present) {
      map['audio_id'] = Variable<String>(audioId.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startMs.present) {
      map['start_ms'] = Variable<int>(startMs.value);
    }
    if (endMs.present) {
      map['end_ms'] = Variable<int>(endMs.value);
    }
    if (isHeard.present) {
      map['is_heard'] = Variable<bool>(isHeard.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('audioId: $audioId, ')
          ..write('index: $index, ')
          ..write('title: $title, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('isHeard: $isHeard, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TranscriptsTable extends Transcripts
    with TableInfo<$TranscriptsTable, Transcript> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranscriptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioIdMeta =
      const VerificationMeta('audioId');
  @override
  late final GeneratedColumn<String> audioId = GeneratedColumn<String>(
      'audio_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES audio_items (id)'));
  static const VerificationMeta _segmentIndexMeta =
      const VerificationMeta('segmentIndex');
  @override
  late final GeneratedColumn<int> segmentIndex = GeneratedColumn<int>(
      'segment_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _text_Meta = const VerificationMeta('text_');
  @override
  late final GeneratedColumn<String> text_ = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startMsMeta =
      const VerificationMeta('startMs');
  @override
  late final GeneratedColumn<int> startMs = GeneratedColumn<int>(
      'start_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endMsMeta = const VerificationMeta('endMs');
  @override
  late final GeneratedColumn<int> endMs = GeneratedColumn<int>(
      'end_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _offsetAdjustMeta =
      const VerificationMeta('offsetAdjust');
  @override
  late final GeneratedColumn<int> offsetAdjust = GeneratedColumn<int>(
      'offset_adjust', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, audioId, segmentIndex, text_, startMs, endMs, offsetAdjust];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transcripts';
  @override
  VerificationContext validateIntegrity(Insertable<Transcript> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('audio_id')) {
      context.handle(_audioIdMeta,
          audioId.isAcceptableOrUnknown(data['audio_id']!, _audioIdMeta));
    } else if (isInserting) {
      context.missing(_audioIdMeta);
    }
    if (data.containsKey('segment_index')) {
      context.handle(
          _segmentIndexMeta,
          segmentIndex.isAcceptableOrUnknown(
              data['segment_index']!, _segmentIndexMeta));
    } else if (isInserting) {
      context.missing(_segmentIndexMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
          _text_Meta, text_.isAcceptableOrUnknown(data['text']!, _text_Meta));
    } else if (isInserting) {
      context.missing(_text_Meta);
    }
    if (data.containsKey('start_ms')) {
      context.handle(_startMsMeta,
          startMs.isAcceptableOrUnknown(data['start_ms']!, _startMsMeta));
    } else if (isInserting) {
      context.missing(_startMsMeta);
    }
    if (data.containsKey('end_ms')) {
      context.handle(
          _endMsMeta, endMs.isAcceptableOrUnknown(data['end_ms']!, _endMsMeta));
    } else if (isInserting) {
      context.missing(_endMsMeta);
    }
    if (data.containsKey('offset_adjust')) {
      context.handle(
          _offsetAdjustMeta,
          offsetAdjust.isAcceptableOrUnknown(
              data['offset_adjust']!, _offsetAdjustMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transcript map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transcript(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      audioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_id'])!,
      segmentIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}segment_index'])!,
      text_: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      startMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_ms'])!,
      endMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_ms'])!,
      offsetAdjust: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}offset_adjust'])!,
    );
  }

  @override
  $TranscriptsTable createAlias(String alias) {
    return $TranscriptsTable(attachedDatabase, alias);
  }
}

class Transcript extends DataClass implements Insertable<Transcript> {
  final String id;
  final String audioId;
  final int segmentIndex;
  final String text_;
  final int startMs;
  final int endMs;
  final int offsetAdjust;
  const Transcript(
      {required this.id,
      required this.audioId,
      required this.segmentIndex,
      required this.text_,
      required this.startMs,
      required this.endMs,
      required this.offsetAdjust});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['audio_id'] = Variable<String>(audioId);
    map['segment_index'] = Variable<int>(segmentIndex);
    map['text'] = Variable<String>(text_);
    map['start_ms'] = Variable<int>(startMs);
    map['end_ms'] = Variable<int>(endMs);
    map['offset_adjust'] = Variable<int>(offsetAdjust);
    return map;
  }

  TranscriptsCompanion toCompanion(bool nullToAbsent) {
    return TranscriptsCompanion(
      id: Value(id),
      audioId: Value(audioId),
      segmentIndex: Value(segmentIndex),
      text_: Value(text_),
      startMs: Value(startMs),
      endMs: Value(endMs),
      offsetAdjust: Value(offsetAdjust),
    );
  }

  factory Transcript.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transcript(
      id: serializer.fromJson<String>(json['id']),
      audioId: serializer.fromJson<String>(json['audioId']),
      segmentIndex: serializer.fromJson<int>(json['segmentIndex']),
      text_: serializer.fromJson<String>(json['text_']),
      startMs: serializer.fromJson<int>(json['startMs']),
      endMs: serializer.fromJson<int>(json['endMs']),
      offsetAdjust: serializer.fromJson<int>(json['offsetAdjust']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'audioId': serializer.toJson<String>(audioId),
      'segmentIndex': serializer.toJson<int>(segmentIndex),
      'text_': serializer.toJson<String>(text_),
      'startMs': serializer.toJson<int>(startMs),
      'endMs': serializer.toJson<int>(endMs),
      'offsetAdjust': serializer.toJson<int>(offsetAdjust),
    };
  }

  Transcript copyWith(
          {String? id,
          String? audioId,
          int? segmentIndex,
          String? text_,
          int? startMs,
          int? endMs,
          int? offsetAdjust}) =>
      Transcript(
        id: id ?? this.id,
        audioId: audioId ?? this.audioId,
        segmentIndex: segmentIndex ?? this.segmentIndex,
        text_: text_ ?? this.text_,
        startMs: startMs ?? this.startMs,
        endMs: endMs ?? this.endMs,
        offsetAdjust: offsetAdjust ?? this.offsetAdjust,
      );
  Transcript copyWithCompanion(TranscriptsCompanion data) {
    return Transcript(
      id: data.id.present ? data.id.value : this.id,
      audioId: data.audioId.present ? data.audioId.value : this.audioId,
      segmentIndex: data.segmentIndex.present
          ? data.segmentIndex.value
          : this.segmentIndex,
      text_: data.text_.present ? data.text_.value : this.text_,
      startMs: data.startMs.present ? data.startMs.value : this.startMs,
      endMs: data.endMs.present ? data.endMs.value : this.endMs,
      offsetAdjust: data.offsetAdjust.present
          ? data.offsetAdjust.value
          : this.offsetAdjust,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transcript(')
          ..write('id: $id, ')
          ..write('audioId: $audioId, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('text_: $text_, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('offsetAdjust: $offsetAdjust')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, audioId, segmentIndex, text_, startMs, endMs, offsetAdjust);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transcript &&
          other.id == this.id &&
          other.audioId == this.audioId &&
          other.segmentIndex == this.segmentIndex &&
          other.text_ == this.text_ &&
          other.startMs == this.startMs &&
          other.endMs == this.endMs &&
          other.offsetAdjust == this.offsetAdjust);
}

class TranscriptsCompanion extends UpdateCompanion<Transcript> {
  final Value<String> id;
  final Value<String> audioId;
  final Value<int> segmentIndex;
  final Value<String> text_;
  final Value<int> startMs;
  final Value<int> endMs;
  final Value<int> offsetAdjust;
  final Value<int> rowid;
  const TranscriptsCompanion({
    this.id = const Value.absent(),
    this.audioId = const Value.absent(),
    this.segmentIndex = const Value.absent(),
    this.text_ = const Value.absent(),
    this.startMs = const Value.absent(),
    this.endMs = const Value.absent(),
    this.offsetAdjust = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TranscriptsCompanion.insert({
    required String id,
    required String audioId,
    required int segmentIndex,
    required String text_,
    required int startMs,
    required int endMs,
    this.offsetAdjust = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        audioId = Value(audioId),
        segmentIndex = Value(segmentIndex),
        text_ = Value(text_),
        startMs = Value(startMs),
        endMs = Value(endMs);
  static Insertable<Transcript> custom({
    Expression<String>? id,
    Expression<String>? audioId,
    Expression<int>? segmentIndex,
    Expression<String>? text_,
    Expression<int>? startMs,
    Expression<int>? endMs,
    Expression<int>? offsetAdjust,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (audioId != null) 'audio_id': audioId,
      if (segmentIndex != null) 'segment_index': segmentIndex,
      if (text_ != null) 'text': text_,
      if (startMs != null) 'start_ms': startMs,
      if (endMs != null) 'end_ms': endMs,
      if (offsetAdjust != null) 'offset_adjust': offsetAdjust,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TranscriptsCompanion copyWith(
      {Value<String>? id,
      Value<String>? audioId,
      Value<int>? segmentIndex,
      Value<String>? text_,
      Value<int>? startMs,
      Value<int>? endMs,
      Value<int>? offsetAdjust,
      Value<int>? rowid}) {
    return TranscriptsCompanion(
      id: id ?? this.id,
      audioId: audioId ?? this.audioId,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      text_: text_ ?? this.text_,
      startMs: startMs ?? this.startMs,
      endMs: endMs ?? this.endMs,
      offsetAdjust: offsetAdjust ?? this.offsetAdjust,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (audioId.present) {
      map['audio_id'] = Variable<String>(audioId.value);
    }
    if (segmentIndex.present) {
      map['segment_index'] = Variable<int>(segmentIndex.value);
    }
    if (text_.present) {
      map['text'] = Variable<String>(text_.value);
    }
    if (startMs.present) {
      map['start_ms'] = Variable<int>(startMs.value);
    }
    if (endMs.present) {
      map['end_ms'] = Variable<int>(endMs.value);
    }
    if (offsetAdjust.present) {
      map['offset_adjust'] = Variable<int>(offsetAdjust.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranscriptsCompanion(')
          ..write('id: $id, ')
          ..write('audioId: $audioId, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('text_: $text_, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('offsetAdjust: $offsetAdjust, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _wordTextMeta =
      const VerificationMeta('wordText');
  @override
  late final GeneratedColumn<String> wordText = GeneratedColumn<String>(
      'word_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startMsMeta =
      const VerificationMeta('startMs');
  @override
  late final GeneratedColumn<int> startMs = GeneratedColumn<int>(
      'start_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endMsMeta = const VerificationMeta('endMs');
  @override
  late final GeneratedColumn<int> endMs = GeneratedColumn<int>(
      'end_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _transcriptIdMeta =
      const VerificationMeta('transcriptId');
  @override
  late final GeneratedColumn<String> transcriptId = GeneratedColumn<String>(
      'transcript_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transcripts (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, wordText, startMs, endMs, transcriptId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(Insertable<Word> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_text')) {
      context.handle(_wordTextMeta,
          wordText.isAcceptableOrUnknown(data['word_text']!, _wordTextMeta));
    } else if (isInserting) {
      context.missing(_wordTextMeta);
    }
    if (data.containsKey('start_ms')) {
      context.handle(_startMsMeta,
          startMs.isAcceptableOrUnknown(data['start_ms']!, _startMsMeta));
    } else if (isInserting) {
      context.missing(_startMsMeta);
    }
    if (data.containsKey('end_ms')) {
      context.handle(
          _endMsMeta, endMs.isAcceptableOrUnknown(data['end_ms']!, _endMsMeta));
    } else if (isInserting) {
      context.missing(_endMsMeta);
    }
    if (data.containsKey('transcript_id')) {
      context.handle(
          _transcriptIdMeta,
          transcriptId.isAcceptableOrUnknown(
              data['transcript_id']!, _transcriptIdMeta));
    } else if (isInserting) {
      context.missing(_transcriptIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      wordText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_text'])!,
      startMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_ms'])!,
      endMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_ms'])!,
      transcriptId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transcript_id'])!,
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
  final int id;
  final String wordText;
  final int startMs;
  final int endMs;
  final String transcriptId;
  const Word(
      {required this.id,
      required this.wordText,
      required this.startMs,
      required this.endMs,
      required this.transcriptId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_text'] = Variable<String>(wordText);
    map['start_ms'] = Variable<int>(startMs);
    map['end_ms'] = Variable<int>(endMs);
    map['transcript_id'] = Variable<String>(transcriptId);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      wordText: Value(wordText),
      startMs: Value(startMs),
      endMs: Value(endMs),
      transcriptId: Value(transcriptId),
    );
  }

  factory Word.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<int>(json['id']),
      wordText: serializer.fromJson<String>(json['wordText']),
      startMs: serializer.fromJson<int>(json['startMs']),
      endMs: serializer.fromJson<int>(json['endMs']),
      transcriptId: serializer.fromJson<String>(json['transcriptId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordText': serializer.toJson<String>(wordText),
      'startMs': serializer.toJson<int>(startMs),
      'endMs': serializer.toJson<int>(endMs),
      'transcriptId': serializer.toJson<String>(transcriptId),
    };
  }

  Word copyWith(
          {int? id,
          String? wordText,
          int? startMs,
          int? endMs,
          String? transcriptId}) =>
      Word(
        id: id ?? this.id,
        wordText: wordText ?? this.wordText,
        startMs: startMs ?? this.startMs,
        endMs: endMs ?? this.endMs,
        transcriptId: transcriptId ?? this.transcriptId,
      );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      wordText: data.wordText.present ? data.wordText.value : this.wordText,
      startMs: data.startMs.present ? data.startMs.value : this.startMs,
      endMs: data.endMs.present ? data.endMs.value : this.endMs,
      transcriptId: data.transcriptId.present
          ? data.transcriptId.value
          : this.transcriptId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('wordText: $wordText, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('transcriptId: $transcriptId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordText, startMs, endMs, transcriptId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.wordText == this.wordText &&
          other.startMs == this.startMs &&
          other.endMs == this.endMs &&
          other.transcriptId == this.transcriptId);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<String> wordText;
  final Value<int> startMs;
  final Value<int> endMs;
  final Value<String> transcriptId;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.wordText = const Value.absent(),
    this.startMs = const Value.absent(),
    this.endMs = const Value.absent(),
    this.transcriptId = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    required String wordText,
    required int startMs,
    required int endMs,
    required String transcriptId,
  })  : wordText = Value(wordText),
        startMs = Value(startMs),
        endMs = Value(endMs),
        transcriptId = Value(transcriptId);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<String>? wordText,
    Expression<int>? startMs,
    Expression<int>? endMs,
    Expression<String>? transcriptId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordText != null) 'word_text': wordText,
      if (startMs != null) 'start_ms': startMs,
      if (endMs != null) 'end_ms': endMs,
      if (transcriptId != null) 'transcript_id': transcriptId,
    });
  }

  WordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? wordText,
      Value<int>? startMs,
      Value<int>? endMs,
      Value<String>? transcriptId}) {
    return WordsCompanion(
      id: id ?? this.id,
      wordText: wordText ?? this.wordText,
      startMs: startMs ?? this.startMs,
      endMs: endMs ?? this.endMs,
      transcriptId: transcriptId ?? this.transcriptId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordText.present) {
      map['word_text'] = Variable<String>(wordText.value);
    }
    if (startMs.present) {
      map['start_ms'] = Variable<int>(startMs.value);
    }
    if (endMs.present) {
      map['end_ms'] = Variable<int>(endMs.value);
    }
    if (transcriptId.present) {
      map['transcript_id'] = Variable<String>(transcriptId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('wordText: $wordText, ')
          ..write('startMs: $startMs, ')
          ..write('endMs: $endMs, ')
          ..write('transcriptId: $transcriptId')
          ..write(')'))
        .toString();
  }
}

class $VocabularyTable extends Vocabulary
    with TableInfo<$VocabularyTable, VocabularyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneticMeta =
      const VerificationMeta('phonetic');
  @override
  late final GeneratedColumn<String> phonetic = GeneratedColumn<String>(
      'phonetic', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
      'pos', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _meaningMeta =
      const VerificationMeta('meaning');
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
      'meaning', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _definitionMeta =
      const VerificationMeta('definition');
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
      'definition', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _audioIdMeta =
      const VerificationMeta('audioId');
  @override
  late final GeneratedColumn<String> audioId = GeneratedColumn<String>(
      'audio_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES audio_items (id)'));
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chapters (id)'));
  static const VerificationMeta _sourceOffsetMsMeta =
      const VerificationMeta('sourceOffsetMs');
  @override
  late final GeneratedColumn<int> sourceOffsetMs = GeneratedColumn<int>(
      'source_offset_ms', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _reviewCountMeta =
      const VerificationMeta('reviewCount');
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
      'review_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        word,
        phonetic,
        pos,
        meaning,
        definition,
        audioId,
        chapterId,
        sourceOffsetMs,
        createdAt,
        reviewCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary';
  @override
  VerificationContext validateIntegrity(Insertable<VocabularyData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('phonetic')) {
      context.handle(_phoneticMeta,
          phonetic.isAcceptableOrUnknown(data['phonetic']!, _phoneticMeta));
    }
    if (data.containsKey('pos')) {
      context.handle(
          _posMeta, pos.isAcceptableOrUnknown(data['pos']!, _posMeta));
    }
    if (data.containsKey('meaning')) {
      context.handle(_meaningMeta,
          meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta));
    }
    if (data.containsKey('definition')) {
      context.handle(
          _definitionMeta,
          definition.isAcceptableOrUnknown(
              data['definition']!, _definitionMeta));
    }
    if (data.containsKey('audio_id')) {
      context.handle(_audioIdMeta,
          audioId.isAcceptableOrUnknown(data['audio_id']!, _audioIdMeta));
    } else if (isInserting) {
      context.missing(_audioIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    }
    if (data.containsKey('source_offset_ms')) {
      context.handle(
          _sourceOffsetMsMeta,
          sourceOffsetMs.isAcceptableOrUnknown(
              data['source_offset_ms']!, _sourceOffsetMsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('review_count')) {
      context.handle(
          _reviewCountMeta,
          reviewCount.isAcceptableOrUnknown(
              data['review_count']!, _reviewCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabularyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      phonetic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phonetic'])!,
      pos: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pos'])!,
      meaning: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning'])!,
      definition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition'])!,
      audioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id']),
      sourceOffsetMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_offset_ms'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      reviewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_count'])!,
    );
  }

  @override
  $VocabularyTable createAlias(String alias) {
    return $VocabularyTable(attachedDatabase, alias);
  }
}

class VocabularyData extends DataClass implements Insertable<VocabularyData> {
  final String id;
  final String word;
  final String phonetic;
  final String pos;
  final String meaning;
  final String definition;
  final String audioId;
  final String? chapterId;
  final int sourceOffsetMs;
  final DateTime createdAt;
  final int reviewCount;
  const VocabularyData(
      {required this.id,
      required this.word,
      required this.phonetic,
      required this.pos,
      required this.meaning,
      required this.definition,
      required this.audioId,
      this.chapterId,
      required this.sourceOffsetMs,
      required this.createdAt,
      required this.reviewCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word'] = Variable<String>(word);
    map['phonetic'] = Variable<String>(phonetic);
    map['pos'] = Variable<String>(pos);
    map['meaning'] = Variable<String>(meaning);
    map['definition'] = Variable<String>(definition);
    map['audio_id'] = Variable<String>(audioId);
    if (!nullToAbsent || chapterId != null) {
      map['chapter_id'] = Variable<String>(chapterId);
    }
    map['source_offset_ms'] = Variable<int>(sourceOffsetMs);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['review_count'] = Variable<int>(reviewCount);
    return map;
  }

  VocabularyCompanion toCompanion(bool nullToAbsent) {
    return VocabularyCompanion(
      id: Value(id),
      word: Value(word),
      phonetic: Value(phonetic),
      pos: Value(pos),
      meaning: Value(meaning),
      definition: Value(definition),
      audioId: Value(audioId),
      chapterId: chapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterId),
      sourceOffsetMs: Value(sourceOffsetMs),
      createdAt: Value(createdAt),
      reviewCount: Value(reviewCount),
    );
  }

  factory VocabularyData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyData(
      id: serializer.fromJson<String>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      phonetic: serializer.fromJson<String>(json['phonetic']),
      pos: serializer.fromJson<String>(json['pos']),
      meaning: serializer.fromJson<String>(json['meaning']),
      definition: serializer.fromJson<String>(json['definition']),
      audioId: serializer.fromJson<String>(json['audioId']),
      chapterId: serializer.fromJson<String?>(json['chapterId']),
      sourceOffsetMs: serializer.fromJson<int>(json['sourceOffsetMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'word': serializer.toJson<String>(word),
      'phonetic': serializer.toJson<String>(phonetic),
      'pos': serializer.toJson<String>(pos),
      'meaning': serializer.toJson<String>(meaning),
      'definition': serializer.toJson<String>(definition),
      'audioId': serializer.toJson<String>(audioId),
      'chapterId': serializer.toJson<String?>(chapterId),
      'sourceOffsetMs': serializer.toJson<int>(sourceOffsetMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'reviewCount': serializer.toJson<int>(reviewCount),
    };
  }

  VocabularyData copyWith(
          {String? id,
          String? word,
          String? phonetic,
          String? pos,
          String? meaning,
          String? definition,
          String? audioId,
          Value<String?> chapterId = const Value.absent(),
          int? sourceOffsetMs,
          DateTime? createdAt,
          int? reviewCount}) =>
      VocabularyData(
        id: id ?? this.id,
        word: word ?? this.word,
        phonetic: phonetic ?? this.phonetic,
        pos: pos ?? this.pos,
        meaning: meaning ?? this.meaning,
        definition: definition ?? this.definition,
        audioId: audioId ?? this.audioId,
        chapterId: chapterId.present ? chapterId.value : this.chapterId,
        sourceOffsetMs: sourceOffsetMs ?? this.sourceOffsetMs,
        createdAt: createdAt ?? this.createdAt,
        reviewCount: reviewCount ?? this.reviewCount,
      );
  VocabularyData copyWithCompanion(VocabularyCompanion data) {
    return VocabularyData(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      phonetic: data.phonetic.present ? data.phonetic.value : this.phonetic,
      pos: data.pos.present ? data.pos.value : this.pos,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      definition:
          data.definition.present ? data.definition.value : this.definition,
      audioId: data.audioId.present ? data.audioId.value : this.audioId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      sourceOffsetMs: data.sourceOffsetMs.present
          ? data.sourceOffsetMs.value
          : this.sourceOffsetMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      reviewCount:
          data.reviewCount.present ? data.reviewCount.value : this.reviewCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyData(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('phonetic: $phonetic, ')
          ..write('pos: $pos, ')
          ..write('meaning: $meaning, ')
          ..write('definition: $definition, ')
          ..write('audioId: $audioId, ')
          ..write('chapterId: $chapterId, ')
          ..write('sourceOffsetMs: $sourceOffsetMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('reviewCount: $reviewCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, word, phonetic, pos, meaning, definition,
      audioId, chapterId, sourceOffsetMs, createdAt, reviewCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyData &&
          other.id == this.id &&
          other.word == this.word &&
          other.phonetic == this.phonetic &&
          other.pos == this.pos &&
          other.meaning == this.meaning &&
          other.definition == this.definition &&
          other.audioId == this.audioId &&
          other.chapterId == this.chapterId &&
          other.sourceOffsetMs == this.sourceOffsetMs &&
          other.createdAt == this.createdAt &&
          other.reviewCount == this.reviewCount);
}

class VocabularyCompanion extends UpdateCompanion<VocabularyData> {
  final Value<String> id;
  final Value<String> word;
  final Value<String> phonetic;
  final Value<String> pos;
  final Value<String> meaning;
  final Value<String> definition;
  final Value<String> audioId;
  final Value<String?> chapterId;
  final Value<int> sourceOffsetMs;
  final Value<DateTime> createdAt;
  final Value<int> reviewCount;
  final Value<int> rowid;
  const VocabularyCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.phonetic = const Value.absent(),
    this.pos = const Value.absent(),
    this.meaning = const Value.absent(),
    this.definition = const Value.absent(),
    this.audioId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.sourceOffsetMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularyCompanion.insert({
    required String id,
    required String word,
    this.phonetic = const Value.absent(),
    this.pos = const Value.absent(),
    this.meaning = const Value.absent(),
    this.definition = const Value.absent(),
    required String audioId,
    this.chapterId = const Value.absent(),
    this.sourceOffsetMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        word = Value(word),
        audioId = Value(audioId);
  static Insertable<VocabularyData> custom({
    Expression<String>? id,
    Expression<String>? word,
    Expression<String>? phonetic,
    Expression<String>? pos,
    Expression<String>? meaning,
    Expression<String>? definition,
    Expression<String>? audioId,
    Expression<String>? chapterId,
    Expression<int>? sourceOffsetMs,
    Expression<DateTime>? createdAt,
    Expression<int>? reviewCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (phonetic != null) 'phonetic': phonetic,
      if (pos != null) 'pos': pos,
      if (meaning != null) 'meaning': meaning,
      if (definition != null) 'definition': definition,
      if (audioId != null) 'audio_id': audioId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (sourceOffsetMs != null) 'source_offset_ms': sourceOffsetMs,
      if (createdAt != null) 'created_at': createdAt,
      if (reviewCount != null) 'review_count': reviewCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularyCompanion copyWith(
      {Value<String>? id,
      Value<String>? word,
      Value<String>? phonetic,
      Value<String>? pos,
      Value<String>? meaning,
      Value<String>? definition,
      Value<String>? audioId,
      Value<String?>? chapterId,
      Value<int>? sourceOffsetMs,
      Value<DateTime>? createdAt,
      Value<int>? reviewCount,
      Value<int>? rowid}) {
    return VocabularyCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      phonetic: phonetic ?? this.phonetic,
      pos: pos ?? this.pos,
      meaning: meaning ?? this.meaning,
      definition: definition ?? this.definition,
      audioId: audioId ?? this.audioId,
      chapterId: chapterId ?? this.chapterId,
      sourceOffsetMs: sourceOffsetMs ?? this.sourceOffsetMs,
      createdAt: createdAt ?? this.createdAt,
      reviewCount: reviewCount ?? this.reviewCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (phonetic.present) {
      map['phonetic'] = Variable<String>(phonetic.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    if (audioId.present) {
      map['audio_id'] = Variable<String>(audioId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (sourceOffsetMs.present) {
      map['source_offset_ms'] = Variable<int>(sourceOffsetMs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('phonetic: $phonetic, ')
          ..write('pos: $pos, ')
          ..write('meaning: $meaning, ')
          ..write('definition: $definition, ')
          ..write('audioId: $audioId, ')
          ..write('chapterId: $chapterId, ')
          ..write('sourceOffsetMs: $sourceOffsetMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaybackStateTable extends PlaybackState
    with TableInfo<$PlaybackStateTable, PlaybackStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaybackStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _audioIdMeta =
      const VerificationMeta('audioId');
  @override
  late final GeneratedColumn<String> audioId = GeneratedColumn<String>(
      'audio_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES audio_items (id)'));
  static const VerificationMeta _lastChapterIdMeta =
      const VerificationMeta('lastChapterId');
  @override
  late final GeneratedColumn<String> lastChapterId = GeneratedColumn<String>(
      'last_chapter_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastPositionMsMeta =
      const VerificationMeta('lastPositionMs');
  @override
  late final GeneratedColumn<int> lastPositionMs = GeneratedColumn<int>(
      'last_position_ms', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [audioId, lastChapterId, lastPositionMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playback_state';
  @override
  VerificationContext validateIntegrity(Insertable<PlaybackStateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('audio_id')) {
      context.handle(_audioIdMeta,
          audioId.isAcceptableOrUnknown(data['audio_id']!, _audioIdMeta));
    } else if (isInserting) {
      context.missing(_audioIdMeta);
    }
    if (data.containsKey('last_chapter_id')) {
      context.handle(
          _lastChapterIdMeta,
          lastChapterId.isAcceptableOrUnknown(
              data['last_chapter_id']!, _lastChapterIdMeta));
    }
    if (data.containsKey('last_position_ms')) {
      context.handle(
          _lastPositionMsMeta,
          lastPositionMs.isAcceptableOrUnknown(
              data['last_position_ms']!, _lastPositionMsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {audioId};
  @override
  PlaybackStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaybackStateData(
      audioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_id'])!,
      lastChapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_chapter_id']),
      lastPositionMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_position_ms'])!,
    );
  }

  @override
  $PlaybackStateTable createAlias(String alias) {
    return $PlaybackStateTable(attachedDatabase, alias);
  }
}

class PlaybackStateData extends DataClass
    implements Insertable<PlaybackStateData> {
  final String audioId;
  final String? lastChapterId;
  final int lastPositionMs;
  const PlaybackStateData(
      {required this.audioId,
      this.lastChapterId,
      required this.lastPositionMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['audio_id'] = Variable<String>(audioId);
    if (!nullToAbsent || lastChapterId != null) {
      map['last_chapter_id'] = Variable<String>(lastChapterId);
    }
    map['last_position_ms'] = Variable<int>(lastPositionMs);
    return map;
  }

  PlaybackStateCompanion toCompanion(bool nullToAbsent) {
    return PlaybackStateCompanion(
      audioId: Value(audioId),
      lastChapterId: lastChapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastChapterId),
      lastPositionMs: Value(lastPositionMs),
    );
  }

  factory PlaybackStateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaybackStateData(
      audioId: serializer.fromJson<String>(json['audioId']),
      lastChapterId: serializer.fromJson<String?>(json['lastChapterId']),
      lastPositionMs: serializer.fromJson<int>(json['lastPositionMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'audioId': serializer.toJson<String>(audioId),
      'lastChapterId': serializer.toJson<String?>(lastChapterId),
      'lastPositionMs': serializer.toJson<int>(lastPositionMs),
    };
  }

  PlaybackStateData copyWith(
          {String? audioId,
          Value<String?> lastChapterId = const Value.absent(),
          int? lastPositionMs}) =>
      PlaybackStateData(
        audioId: audioId ?? this.audioId,
        lastChapterId:
            lastChapterId.present ? lastChapterId.value : this.lastChapterId,
        lastPositionMs: lastPositionMs ?? this.lastPositionMs,
      );
  PlaybackStateData copyWithCompanion(PlaybackStateCompanion data) {
    return PlaybackStateData(
      audioId: data.audioId.present ? data.audioId.value : this.audioId,
      lastChapterId: data.lastChapterId.present
          ? data.lastChapterId.value
          : this.lastChapterId,
      lastPositionMs: data.lastPositionMs.present
          ? data.lastPositionMs.value
          : this.lastPositionMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackStateData(')
          ..write('audioId: $audioId, ')
          ..write('lastChapterId: $lastChapterId, ')
          ..write('lastPositionMs: $lastPositionMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(audioId, lastChapterId, lastPositionMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaybackStateData &&
          other.audioId == this.audioId &&
          other.lastChapterId == this.lastChapterId &&
          other.lastPositionMs == this.lastPositionMs);
}

class PlaybackStateCompanion extends UpdateCompanion<PlaybackStateData> {
  final Value<String> audioId;
  final Value<String?> lastChapterId;
  final Value<int> lastPositionMs;
  final Value<int> rowid;
  const PlaybackStateCompanion({
    this.audioId = const Value.absent(),
    this.lastChapterId = const Value.absent(),
    this.lastPositionMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaybackStateCompanion.insert({
    required String audioId,
    this.lastChapterId = const Value.absent(),
    this.lastPositionMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : audioId = Value(audioId);
  static Insertable<PlaybackStateData> custom({
    Expression<String>? audioId,
    Expression<String>? lastChapterId,
    Expression<int>? lastPositionMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (audioId != null) 'audio_id': audioId,
      if (lastChapterId != null) 'last_chapter_id': lastChapterId,
      if (lastPositionMs != null) 'last_position_ms': lastPositionMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaybackStateCompanion copyWith(
      {Value<String>? audioId,
      Value<String?>? lastChapterId,
      Value<int>? lastPositionMs,
      Value<int>? rowid}) {
    return PlaybackStateCompanion(
      audioId: audioId ?? this.audioId,
      lastChapterId: lastChapterId ?? this.lastChapterId,
      lastPositionMs: lastPositionMs ?? this.lastPositionMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (audioId.present) {
      map['audio_id'] = Variable<String>(audioId.value);
    }
    if (lastChapterId.present) {
      map['last_chapter_id'] = Variable<String>(lastChapterId.value);
    }
    if (lastPositionMs.present) {
      map['last_position_ms'] = Variable<int>(lastPositionMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackStateCompanion(')
          ..write('audioId: $audioId, ')
          ..write('lastChapterId: $lastChapterId, ')
          ..write('lastPositionMs: $lastPositionMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WordMemoryTable extends WordMemory
    with TableInfo<$WordMemoryTable, WordMemoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordMemoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
      'word_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES vocabulary (id)'));
  static const VerificationMeta _queryCountMeta =
      const VerificationMeta('queryCount');
  @override
  late final GeneratedColumn<int> queryCount = GeneratedColumn<int>(
      'query_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _quizAttemptsMeta =
      const VerificationMeta('quizAttempts');
  @override
  late final GeneratedColumn<int> quizAttempts = GeneratedColumn<int>(
      'quiz_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _quizCorrectMeta =
      const VerificationMeta('quizCorrect');
  @override
  late final GeneratedColumn<int> quizCorrect = GeneratedColumn<int>(
      'quiz_correct', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _masteryLevelMeta =
      const VerificationMeta('masteryLevel');
  @override
  late final GeneratedColumn<double> masteryLevel = GeneratedColumn<double>(
      'mastery_level', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _weakFlagMeta =
      const VerificationMeta('weakFlag');
  @override
  late final GeneratedColumn<bool> weakFlag = GeneratedColumn<bool>(
      'weak_flag', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("weak_flag" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastQueriedAtMeta =
      const VerificationMeta('lastQueriedAt');
  @override
  late final GeneratedColumn<DateTime> lastQueriedAt =
      GeneratedColumn<DateTime>('last_queried_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastQuizzedAtMeta =
      const VerificationMeta('lastQuizzedAt');
  @override
  late final GeneratedColumn<DateTime> lastQuizzedAt =
      GeneratedColumn<DateTime>('last_quizzed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        wordId,
        queryCount,
        quizAttempts,
        quizCorrect,
        masteryLevel,
        weakFlag,
        lastQueriedAt,
        lastQuizzedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_memory';
  @override
  VerificationContext validateIntegrity(Insertable<WordMemoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('query_count')) {
      context.handle(
          _queryCountMeta,
          queryCount.isAcceptableOrUnknown(
              data['query_count']!, _queryCountMeta));
    }
    if (data.containsKey('quiz_attempts')) {
      context.handle(
          _quizAttemptsMeta,
          quizAttempts.isAcceptableOrUnknown(
              data['quiz_attempts']!, _quizAttemptsMeta));
    }
    if (data.containsKey('quiz_correct')) {
      context.handle(
          _quizCorrectMeta,
          quizCorrect.isAcceptableOrUnknown(
              data['quiz_correct']!, _quizCorrectMeta));
    }
    if (data.containsKey('mastery_level')) {
      context.handle(
          _masteryLevelMeta,
          masteryLevel.isAcceptableOrUnknown(
              data['mastery_level']!, _masteryLevelMeta));
    }
    if (data.containsKey('weak_flag')) {
      context.handle(_weakFlagMeta,
          weakFlag.isAcceptableOrUnknown(data['weak_flag']!, _weakFlagMeta));
    }
    if (data.containsKey('last_queried_at')) {
      context.handle(
          _lastQueriedAtMeta,
          lastQueriedAt.isAcceptableOrUnknown(
              data['last_queried_at']!, _lastQueriedAtMeta));
    }
    if (data.containsKey('last_quizzed_at')) {
      context.handle(
          _lastQuizzedAtMeta,
          lastQuizzedAt.isAcceptableOrUnknown(
              data['last_quizzed_at']!, _lastQuizzedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  WordMemoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordMemoryData(
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_id'])!,
      queryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}query_count'])!,
      quizAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quiz_attempts'])!,
      quizCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quiz_correct'])!,
      masteryLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mastery_level'])!,
      weakFlag: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}weak_flag'])!,
      lastQueriedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_queried_at']),
      lastQuizzedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_quizzed_at']),
    );
  }

  @override
  $WordMemoryTable createAlias(String alias) {
    return $WordMemoryTable(attachedDatabase, alias);
  }
}

class WordMemoryData extends DataClass implements Insertable<WordMemoryData> {
  final String wordId;
  final int queryCount;
  final int quizAttempts;
  final int quizCorrect;
  final double masteryLevel;
  final bool weakFlag;
  final DateTime? lastQueriedAt;
  final DateTime? lastQuizzedAt;
  const WordMemoryData(
      {required this.wordId,
      required this.queryCount,
      required this.quizAttempts,
      required this.quizCorrect,
      required this.masteryLevel,
      required this.weakFlag,
      this.lastQueriedAt,
      this.lastQuizzedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['query_count'] = Variable<int>(queryCount);
    map['quiz_attempts'] = Variable<int>(quizAttempts);
    map['quiz_correct'] = Variable<int>(quizCorrect);
    map['mastery_level'] = Variable<double>(masteryLevel);
    map['weak_flag'] = Variable<bool>(weakFlag);
    if (!nullToAbsent || lastQueriedAt != null) {
      map['last_queried_at'] = Variable<DateTime>(lastQueriedAt);
    }
    if (!nullToAbsent || lastQuizzedAt != null) {
      map['last_quizzed_at'] = Variable<DateTime>(lastQuizzedAt);
    }
    return map;
  }

  WordMemoryCompanion toCompanion(bool nullToAbsent) {
    return WordMemoryCompanion(
      wordId: Value(wordId),
      queryCount: Value(queryCount),
      quizAttempts: Value(quizAttempts),
      quizCorrect: Value(quizCorrect),
      masteryLevel: Value(masteryLevel),
      weakFlag: Value(weakFlag),
      lastQueriedAt: lastQueriedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastQueriedAt),
      lastQuizzedAt: lastQuizzedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastQuizzedAt),
    );
  }

  factory WordMemoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordMemoryData(
      wordId: serializer.fromJson<String>(json['wordId']),
      queryCount: serializer.fromJson<int>(json['queryCount']),
      quizAttempts: serializer.fromJson<int>(json['quizAttempts']),
      quizCorrect: serializer.fromJson<int>(json['quizCorrect']),
      masteryLevel: serializer.fromJson<double>(json['masteryLevel']),
      weakFlag: serializer.fromJson<bool>(json['weakFlag']),
      lastQueriedAt: serializer.fromJson<DateTime?>(json['lastQueriedAt']),
      lastQuizzedAt: serializer.fromJson<DateTime?>(json['lastQuizzedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'queryCount': serializer.toJson<int>(queryCount),
      'quizAttempts': serializer.toJson<int>(quizAttempts),
      'quizCorrect': serializer.toJson<int>(quizCorrect),
      'masteryLevel': serializer.toJson<double>(masteryLevel),
      'weakFlag': serializer.toJson<bool>(weakFlag),
      'lastQueriedAt': serializer.toJson<DateTime?>(lastQueriedAt),
      'lastQuizzedAt': serializer.toJson<DateTime?>(lastQuizzedAt),
    };
  }

  WordMemoryData copyWith(
          {String? wordId,
          int? queryCount,
          int? quizAttempts,
          int? quizCorrect,
          double? masteryLevel,
          bool? weakFlag,
          Value<DateTime?> lastQueriedAt = const Value.absent(),
          Value<DateTime?> lastQuizzedAt = const Value.absent()}) =>
      WordMemoryData(
        wordId: wordId ?? this.wordId,
        queryCount: queryCount ?? this.queryCount,
        quizAttempts: quizAttempts ?? this.quizAttempts,
        quizCorrect: quizCorrect ?? this.quizCorrect,
        masteryLevel: masteryLevel ?? this.masteryLevel,
        weakFlag: weakFlag ?? this.weakFlag,
        lastQueriedAt:
            lastQueriedAt.present ? lastQueriedAt.value : this.lastQueriedAt,
        lastQuizzedAt:
            lastQuizzedAt.present ? lastQuizzedAt.value : this.lastQuizzedAt,
      );
  WordMemoryData copyWithCompanion(WordMemoryCompanion data) {
    return WordMemoryData(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      queryCount:
          data.queryCount.present ? data.queryCount.value : this.queryCount,
      quizAttempts: data.quizAttempts.present
          ? data.quizAttempts.value
          : this.quizAttempts,
      quizCorrect:
          data.quizCorrect.present ? data.quizCorrect.value : this.quizCorrect,
      masteryLevel: data.masteryLevel.present
          ? data.masteryLevel.value
          : this.masteryLevel,
      weakFlag: data.weakFlag.present ? data.weakFlag.value : this.weakFlag,
      lastQueriedAt: data.lastQueriedAt.present
          ? data.lastQueriedAt.value
          : this.lastQueriedAt,
      lastQuizzedAt: data.lastQuizzedAt.present
          ? data.lastQuizzedAt.value
          : this.lastQuizzedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordMemoryData(')
          ..write('wordId: $wordId, ')
          ..write('queryCount: $queryCount, ')
          ..write('quizAttempts: $quizAttempts, ')
          ..write('quizCorrect: $quizCorrect, ')
          ..write('masteryLevel: $masteryLevel, ')
          ..write('weakFlag: $weakFlag, ')
          ..write('lastQueriedAt: $lastQueriedAt, ')
          ..write('lastQuizzedAt: $lastQuizzedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, queryCount, quizAttempts, quizCorrect,
      masteryLevel, weakFlag, lastQueriedAt, lastQuizzedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordMemoryData &&
          other.wordId == this.wordId &&
          other.queryCount == this.queryCount &&
          other.quizAttempts == this.quizAttempts &&
          other.quizCorrect == this.quizCorrect &&
          other.masteryLevel == this.masteryLevel &&
          other.weakFlag == this.weakFlag &&
          other.lastQueriedAt == this.lastQueriedAt &&
          other.lastQuizzedAt == this.lastQuizzedAt);
}

class WordMemoryCompanion extends UpdateCompanion<WordMemoryData> {
  final Value<String> wordId;
  final Value<int> queryCount;
  final Value<int> quizAttempts;
  final Value<int> quizCorrect;
  final Value<double> masteryLevel;
  final Value<bool> weakFlag;
  final Value<DateTime?> lastQueriedAt;
  final Value<DateTime?> lastQuizzedAt;
  final Value<int> rowid;
  const WordMemoryCompanion({
    this.wordId = const Value.absent(),
    this.queryCount = const Value.absent(),
    this.quizAttempts = const Value.absent(),
    this.quizCorrect = const Value.absent(),
    this.masteryLevel = const Value.absent(),
    this.weakFlag = const Value.absent(),
    this.lastQueriedAt = const Value.absent(),
    this.lastQuizzedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordMemoryCompanion.insert({
    required String wordId,
    this.queryCount = const Value.absent(),
    this.quizAttempts = const Value.absent(),
    this.quizCorrect = const Value.absent(),
    this.masteryLevel = const Value.absent(),
    this.weakFlag = const Value.absent(),
    this.lastQueriedAt = const Value.absent(),
    this.lastQuizzedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId);
  static Insertable<WordMemoryData> custom({
    Expression<String>? wordId,
    Expression<int>? queryCount,
    Expression<int>? quizAttempts,
    Expression<int>? quizCorrect,
    Expression<double>? masteryLevel,
    Expression<bool>? weakFlag,
    Expression<DateTime>? lastQueriedAt,
    Expression<DateTime>? lastQuizzedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (queryCount != null) 'query_count': queryCount,
      if (quizAttempts != null) 'quiz_attempts': quizAttempts,
      if (quizCorrect != null) 'quiz_correct': quizCorrect,
      if (masteryLevel != null) 'mastery_level': masteryLevel,
      if (weakFlag != null) 'weak_flag': weakFlag,
      if (lastQueriedAt != null) 'last_queried_at': lastQueriedAt,
      if (lastQuizzedAt != null) 'last_quizzed_at': lastQuizzedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordMemoryCompanion copyWith(
      {Value<String>? wordId,
      Value<int>? queryCount,
      Value<int>? quizAttempts,
      Value<int>? quizCorrect,
      Value<double>? masteryLevel,
      Value<bool>? weakFlag,
      Value<DateTime?>? lastQueriedAt,
      Value<DateTime?>? lastQuizzedAt,
      Value<int>? rowid}) {
    return WordMemoryCompanion(
      wordId: wordId ?? this.wordId,
      queryCount: queryCount ?? this.queryCount,
      quizAttempts: quizAttempts ?? this.quizAttempts,
      quizCorrect: quizCorrect ?? this.quizCorrect,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      weakFlag: weakFlag ?? this.weakFlag,
      lastQueriedAt: lastQueriedAt ?? this.lastQueriedAt,
      lastQuizzedAt: lastQuizzedAt ?? this.lastQuizzedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (queryCount.present) {
      map['query_count'] = Variable<int>(queryCount.value);
    }
    if (quizAttempts.present) {
      map['quiz_attempts'] = Variable<int>(quizAttempts.value);
    }
    if (quizCorrect.present) {
      map['quiz_correct'] = Variable<int>(quizCorrect.value);
    }
    if (masteryLevel.present) {
      map['mastery_level'] = Variable<double>(masteryLevel.value);
    }
    if (weakFlag.present) {
      map['weak_flag'] = Variable<bool>(weakFlag.value);
    }
    if (lastQueriedAt.present) {
      map['last_queried_at'] = Variable<DateTime>(lastQueriedAt.value);
    }
    if (lastQuizzedAt.present) {
      map['last_quizzed_at'] = Variable<DateTime>(lastQuizzedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordMemoryCompanion(')
          ..write('wordId: $wordId, ')
          ..write('queryCount: $queryCount, ')
          ..write('quizAttempts: $quizAttempts, ')
          ..write('quizCorrect: $quizCorrect, ')
          ..write('masteryLevel: $masteryLevel, ')
          ..write('weakFlag: $weakFlag, ')
          ..write('lastQueriedAt: $lastQueriedAt, ')
          ..write('lastQuizzedAt: $lastQuizzedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentMemoryTable extends ContentMemory
    with TableInfo<$ContentMemoryTable, ContentMemoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentMemoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _audioIdMeta =
      const VerificationMeta('audioId');
  @override
  late final GeneratedColumn<String> audioId = GeneratedColumn<String>(
      'audio_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES audio_items (id)'));
  static const VerificationMeta _chaptersHeardMeta =
      const VerificationMeta('chaptersHeard');
  @override
  late final GeneratedColumn<int> chaptersHeard = GeneratedColumn<int>(
      'chapters_heard', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wordsQueriedMeta =
      const VerificationMeta('wordsQueried');
  @override
  late final GeneratedColumn<int> wordsQueried = GeneratedColumn<int>(
      'words_queried', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastHeardAtMeta =
      const VerificationMeta('lastHeardAt');
  @override
  late final GeneratedColumn<DateTime> lastHeardAt = GeneratedColumn<DateTime>(
      'last_heard_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [audioId, chaptersHeard, wordsQueried, lastHeardAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_memory';
  @override
  VerificationContext validateIntegrity(Insertable<ContentMemoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('audio_id')) {
      context.handle(_audioIdMeta,
          audioId.isAcceptableOrUnknown(data['audio_id']!, _audioIdMeta));
    } else if (isInserting) {
      context.missing(_audioIdMeta);
    }
    if (data.containsKey('chapters_heard')) {
      context.handle(
          _chaptersHeardMeta,
          chaptersHeard.isAcceptableOrUnknown(
              data['chapters_heard']!, _chaptersHeardMeta));
    }
    if (data.containsKey('words_queried')) {
      context.handle(
          _wordsQueriedMeta,
          wordsQueried.isAcceptableOrUnknown(
              data['words_queried']!, _wordsQueriedMeta));
    }
    if (data.containsKey('last_heard_at')) {
      context.handle(
          _lastHeardAtMeta,
          lastHeardAt.isAcceptableOrUnknown(
              data['last_heard_at']!, _lastHeardAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {audioId};
  @override
  ContentMemoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentMemoryData(
      audioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_id'])!,
      chaptersHeard: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapters_heard'])!,
      wordsQueried: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}words_queried'])!,
      lastHeardAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_heard_at']),
    );
  }

  @override
  $ContentMemoryTable createAlias(String alias) {
    return $ContentMemoryTable(attachedDatabase, alias);
  }
}

class ContentMemoryData extends DataClass
    implements Insertable<ContentMemoryData> {
  final String audioId;
  final int chaptersHeard;
  final int wordsQueried;
  final DateTime? lastHeardAt;
  const ContentMemoryData(
      {required this.audioId,
      required this.chaptersHeard,
      required this.wordsQueried,
      this.lastHeardAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['audio_id'] = Variable<String>(audioId);
    map['chapters_heard'] = Variable<int>(chaptersHeard);
    map['words_queried'] = Variable<int>(wordsQueried);
    if (!nullToAbsent || lastHeardAt != null) {
      map['last_heard_at'] = Variable<DateTime>(lastHeardAt);
    }
    return map;
  }

  ContentMemoryCompanion toCompanion(bool nullToAbsent) {
    return ContentMemoryCompanion(
      audioId: Value(audioId),
      chaptersHeard: Value(chaptersHeard),
      wordsQueried: Value(wordsQueried),
      lastHeardAt: lastHeardAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastHeardAt),
    );
  }

  factory ContentMemoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentMemoryData(
      audioId: serializer.fromJson<String>(json['audioId']),
      chaptersHeard: serializer.fromJson<int>(json['chaptersHeard']),
      wordsQueried: serializer.fromJson<int>(json['wordsQueried']),
      lastHeardAt: serializer.fromJson<DateTime?>(json['lastHeardAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'audioId': serializer.toJson<String>(audioId),
      'chaptersHeard': serializer.toJson<int>(chaptersHeard),
      'wordsQueried': serializer.toJson<int>(wordsQueried),
      'lastHeardAt': serializer.toJson<DateTime?>(lastHeardAt),
    };
  }

  ContentMemoryData copyWith(
          {String? audioId,
          int? chaptersHeard,
          int? wordsQueried,
          Value<DateTime?> lastHeardAt = const Value.absent()}) =>
      ContentMemoryData(
        audioId: audioId ?? this.audioId,
        chaptersHeard: chaptersHeard ?? this.chaptersHeard,
        wordsQueried: wordsQueried ?? this.wordsQueried,
        lastHeardAt: lastHeardAt.present ? lastHeardAt.value : this.lastHeardAt,
      );
  ContentMemoryData copyWithCompanion(ContentMemoryCompanion data) {
    return ContentMemoryData(
      audioId: data.audioId.present ? data.audioId.value : this.audioId,
      chaptersHeard: data.chaptersHeard.present
          ? data.chaptersHeard.value
          : this.chaptersHeard,
      wordsQueried: data.wordsQueried.present
          ? data.wordsQueried.value
          : this.wordsQueried,
      lastHeardAt:
          data.lastHeardAt.present ? data.lastHeardAt.value : this.lastHeardAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentMemoryData(')
          ..write('audioId: $audioId, ')
          ..write('chaptersHeard: $chaptersHeard, ')
          ..write('wordsQueried: $wordsQueried, ')
          ..write('lastHeardAt: $lastHeardAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(audioId, chaptersHeard, wordsQueried, lastHeardAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentMemoryData &&
          other.audioId == this.audioId &&
          other.chaptersHeard == this.chaptersHeard &&
          other.wordsQueried == this.wordsQueried &&
          other.lastHeardAt == this.lastHeardAt);
}

class ContentMemoryCompanion extends UpdateCompanion<ContentMemoryData> {
  final Value<String> audioId;
  final Value<int> chaptersHeard;
  final Value<int> wordsQueried;
  final Value<DateTime?> lastHeardAt;
  final Value<int> rowid;
  const ContentMemoryCompanion({
    this.audioId = const Value.absent(),
    this.chaptersHeard = const Value.absent(),
    this.wordsQueried = const Value.absent(),
    this.lastHeardAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentMemoryCompanion.insert({
    required String audioId,
    this.chaptersHeard = const Value.absent(),
    this.wordsQueried = const Value.absent(),
    this.lastHeardAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : audioId = Value(audioId);
  static Insertable<ContentMemoryData> custom({
    Expression<String>? audioId,
    Expression<int>? chaptersHeard,
    Expression<int>? wordsQueried,
    Expression<DateTime>? lastHeardAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (audioId != null) 'audio_id': audioId,
      if (chaptersHeard != null) 'chapters_heard': chaptersHeard,
      if (wordsQueried != null) 'words_queried': wordsQueried,
      if (lastHeardAt != null) 'last_heard_at': lastHeardAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentMemoryCompanion copyWith(
      {Value<String>? audioId,
      Value<int>? chaptersHeard,
      Value<int>? wordsQueried,
      Value<DateTime?>? lastHeardAt,
      Value<int>? rowid}) {
    return ContentMemoryCompanion(
      audioId: audioId ?? this.audioId,
      chaptersHeard: chaptersHeard ?? this.chaptersHeard,
      wordsQueried: wordsQueried ?? this.wordsQueried,
      lastHeardAt: lastHeardAt ?? this.lastHeardAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (audioId.present) {
      map['audio_id'] = Variable<String>(audioId.value);
    }
    if (chaptersHeard.present) {
      map['chapters_heard'] = Variable<int>(chaptersHeard.value);
    }
    if (wordsQueried.present) {
      map['words_queried'] = Variable<int>(wordsQueried.value);
    }
    if (lastHeardAt.present) {
      map['last_heard_at'] = Variable<DateTime>(lastHeardAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentMemoryCompanion(')
          ..write('audioId: $audioId, ')
          ..write('chaptersHeard: $chaptersHeard, ')
          ..write('wordsQueried: $wordsQueried, ')
          ..write('lastHeardAt: $lastHeardAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AgentSessionsTable extends AgentSessions
    with TableInfo<$AgentSessionsTable, AgentSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgentSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggerMeta =
      const VerificationMeta('trigger');
  @override
  late final GeneratedColumn<String> trigger = GeneratedColumn<String>(
      'trigger', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioIdMeta =
      const VerificationMeta('audioId');
  @override
  late final GeneratedColumn<String> audioId = GeneratedColumn<String>(
      'audio_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES audio_items (id)'));
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chapters (id)'));
  static const VerificationMeta _messagesJsonMeta =
      const VerificationMeta('messagesJson');
  @override
  late final GeneratedColumn<String> messagesJson = GeneratedColumn<String>(
      'messages_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, trigger, audioId, chapterId, messagesJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agent_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<AgentSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trigger')) {
      context.handle(_triggerMeta,
          trigger.isAcceptableOrUnknown(data['trigger']!, _triggerMeta));
    } else if (isInserting) {
      context.missing(_triggerMeta);
    }
    if (data.containsKey('audio_id')) {
      context.handle(_audioIdMeta,
          audioId.isAcceptableOrUnknown(data['audio_id']!, _audioIdMeta));
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    }
    if (data.containsKey('messages_json')) {
      context.handle(
          _messagesJsonMeta,
          messagesJson.isAcceptableOrUnknown(
              data['messages_json']!, _messagesJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AgentSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AgentSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      trigger: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trigger'])!,
      audioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_id']),
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id']),
      messagesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}messages_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AgentSessionsTable createAlias(String alias) {
    return $AgentSessionsTable(attachedDatabase, alias);
  }
}

class AgentSession extends DataClass implements Insertable<AgentSession> {
  final String id;
  final String trigger;
  final String? audioId;
  final String? chapterId;
  final String messagesJson;
  final DateTime createdAt;
  const AgentSession(
      {required this.id,
      required this.trigger,
      this.audioId,
      this.chapterId,
      required this.messagesJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trigger'] = Variable<String>(trigger);
    if (!nullToAbsent || audioId != null) {
      map['audio_id'] = Variable<String>(audioId);
    }
    if (!nullToAbsent || chapterId != null) {
      map['chapter_id'] = Variable<String>(chapterId);
    }
    map['messages_json'] = Variable<String>(messagesJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AgentSessionsCompanion toCompanion(bool nullToAbsent) {
    return AgentSessionsCompanion(
      id: Value(id),
      trigger: Value(trigger),
      audioId: audioId == null && nullToAbsent
          ? const Value.absent()
          : Value(audioId),
      chapterId: chapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterId),
      messagesJson: Value(messagesJson),
      createdAt: Value(createdAt),
    );
  }

  factory AgentSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AgentSession(
      id: serializer.fromJson<String>(json['id']),
      trigger: serializer.fromJson<String>(json['trigger']),
      audioId: serializer.fromJson<String?>(json['audioId']),
      chapterId: serializer.fromJson<String?>(json['chapterId']),
      messagesJson: serializer.fromJson<String>(json['messagesJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trigger': serializer.toJson<String>(trigger),
      'audioId': serializer.toJson<String?>(audioId),
      'chapterId': serializer.toJson<String?>(chapterId),
      'messagesJson': serializer.toJson<String>(messagesJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AgentSession copyWith(
          {String? id,
          String? trigger,
          Value<String?> audioId = const Value.absent(),
          Value<String?> chapterId = const Value.absent(),
          String? messagesJson,
          DateTime? createdAt}) =>
      AgentSession(
        id: id ?? this.id,
        trigger: trigger ?? this.trigger,
        audioId: audioId.present ? audioId.value : this.audioId,
        chapterId: chapterId.present ? chapterId.value : this.chapterId,
        messagesJson: messagesJson ?? this.messagesJson,
        createdAt: createdAt ?? this.createdAt,
      );
  AgentSession copyWithCompanion(AgentSessionsCompanion data) {
    return AgentSession(
      id: data.id.present ? data.id.value : this.id,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      audioId: data.audioId.present ? data.audioId.value : this.audioId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      messagesJson: data.messagesJson.present
          ? data.messagesJson.value
          : this.messagesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AgentSession(')
          ..write('id: $id, ')
          ..write('trigger: $trigger, ')
          ..write('audioId: $audioId, ')
          ..write('chapterId: $chapterId, ')
          ..write('messagesJson: $messagesJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, trigger, audioId, chapterId, messagesJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AgentSession &&
          other.id == this.id &&
          other.trigger == this.trigger &&
          other.audioId == this.audioId &&
          other.chapterId == this.chapterId &&
          other.messagesJson == this.messagesJson &&
          other.createdAt == this.createdAt);
}

class AgentSessionsCompanion extends UpdateCompanion<AgentSession> {
  final Value<String> id;
  final Value<String> trigger;
  final Value<String?> audioId;
  final Value<String?> chapterId;
  final Value<String> messagesJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AgentSessionsCompanion({
    this.id = const Value.absent(),
    this.trigger = const Value.absent(),
    this.audioId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.messagesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AgentSessionsCompanion.insert({
    required String id,
    required String trigger,
    this.audioId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.messagesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        trigger = Value(trigger);
  static Insertable<AgentSession> custom({
    Expression<String>? id,
    Expression<String>? trigger,
    Expression<String>? audioId,
    Expression<String>? chapterId,
    Expression<String>? messagesJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trigger != null) 'trigger': trigger,
      if (audioId != null) 'audio_id': audioId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (messagesJson != null) 'messages_json': messagesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AgentSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? trigger,
      Value<String?>? audioId,
      Value<String?>? chapterId,
      Value<String>? messagesJson,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AgentSessionsCompanion(
      id: id ?? this.id,
      trigger: trigger ?? this.trigger,
      audioId: audioId ?? this.audioId,
      chapterId: chapterId ?? this.chapterId,
      messagesJson: messagesJson ?? this.messagesJson,
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
    if (trigger.present) {
      map['trigger'] = Variable<String>(trigger.value);
    }
    if (audioId.present) {
      map['audio_id'] = Variable<String>(audioId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (messagesJson.present) {
      map['messages_json'] = Variable<String>(messagesJson.value);
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
    return (StringBuffer('AgentSessionsCompanion(')
          ..write('id: $id, ')
          ..write('trigger: $trigger, ')
          ..write('audioId: $audioId, ')
          ..write('chapterId: $chapterId, ')
          ..write('messagesJson: $messagesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewScheduleTable extends ReviewSchedule
    with TableInfo<$ReviewScheduleTable, ReviewScheduleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewScheduleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
      'word_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES vocabulary (id)'));
  static const VerificationMeta _nextReviewAtMeta =
      const VerificationMeta('nextReviewAt');
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
      'next_review_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reviewCountMeta =
      const VerificationMeta('reviewCount');
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
      'review_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastResultMeta =
      const VerificationMeta('lastResult');
  @override
  late final GeneratedColumn<String> lastResult = GeneratedColumn<String>(
      'last_result', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [wordId, nextReviewAt, reviewCount, lastResult];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_schedule';
  @override
  VerificationContext validateIntegrity(Insertable<ReviewScheduleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
          _nextReviewAtMeta,
          nextReviewAt.isAcceptableOrUnknown(
              data['next_review_at']!, _nextReviewAtMeta));
    } else if (isInserting) {
      context.missing(_nextReviewAtMeta);
    }
    if (data.containsKey('review_count')) {
      context.handle(
          _reviewCountMeta,
          reviewCount.isAcceptableOrUnknown(
              data['review_count']!, _reviewCountMeta));
    }
    if (data.containsKey('last_result')) {
      context.handle(
          _lastResultMeta,
          lastResult.isAcceptableOrUnknown(
              data['last_result']!, _lastResultMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  ReviewScheduleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewScheduleData(
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_id'])!,
      nextReviewAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_review_at'])!,
      reviewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}review_count'])!,
      lastResult: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_result'])!,
    );
  }

  @override
  $ReviewScheduleTable createAlias(String alias) {
    return $ReviewScheduleTable(attachedDatabase, alias);
  }
}

class ReviewScheduleData extends DataClass
    implements Insertable<ReviewScheduleData> {
  final String wordId;
  final DateTime nextReviewAt;
  final int reviewCount;
  final String lastResult;
  const ReviewScheduleData(
      {required this.wordId,
      required this.nextReviewAt,
      required this.reviewCount,
      required this.lastResult});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    map['review_count'] = Variable<int>(reviewCount);
    map['last_result'] = Variable<String>(lastResult);
    return map;
  }

  ReviewScheduleCompanion toCompanion(bool nullToAbsent) {
    return ReviewScheduleCompanion(
      wordId: Value(wordId),
      nextReviewAt: Value(nextReviewAt),
      reviewCount: Value(reviewCount),
      lastResult: Value(lastResult),
    );
  }

  factory ReviewScheduleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewScheduleData(
      wordId: serializer.fromJson<String>(json['wordId']),
      nextReviewAt: serializer.fromJson<DateTime>(json['nextReviewAt']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      lastResult: serializer.fromJson<String>(json['lastResult']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'nextReviewAt': serializer.toJson<DateTime>(nextReviewAt),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'lastResult': serializer.toJson<String>(lastResult),
    };
  }

  ReviewScheduleData copyWith(
          {String? wordId,
          DateTime? nextReviewAt,
          int? reviewCount,
          String? lastResult}) =>
      ReviewScheduleData(
        wordId: wordId ?? this.wordId,
        nextReviewAt: nextReviewAt ?? this.nextReviewAt,
        reviewCount: reviewCount ?? this.reviewCount,
        lastResult: lastResult ?? this.lastResult,
      );
  ReviewScheduleData copyWithCompanion(ReviewScheduleCompanion data) {
    return ReviewScheduleData(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      reviewCount:
          data.reviewCount.present ? data.reviewCount.value : this.reviewCount,
      lastResult:
          data.lastResult.present ? data.lastResult.value : this.lastResult,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewScheduleData(')
          ..write('wordId: $wordId, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('lastResult: $lastResult')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(wordId, nextReviewAt, reviewCount, lastResult);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewScheduleData &&
          other.wordId == this.wordId &&
          other.nextReviewAt == this.nextReviewAt &&
          other.reviewCount == this.reviewCount &&
          other.lastResult == this.lastResult);
}

class ReviewScheduleCompanion extends UpdateCompanion<ReviewScheduleData> {
  final Value<String> wordId;
  final Value<DateTime> nextReviewAt;
  final Value<int> reviewCount;
  final Value<String> lastResult;
  final Value<int> rowid;
  const ReviewScheduleCompanion({
    this.wordId = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.lastResult = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewScheduleCompanion.insert({
    required String wordId,
    required DateTime nextReviewAt,
    this.reviewCount = const Value.absent(),
    this.lastResult = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : wordId = Value(wordId),
        nextReviewAt = Value(nextReviewAt);
  static Insertable<ReviewScheduleData> custom({
    Expression<String>? wordId,
    Expression<DateTime>? nextReviewAt,
    Expression<int>? reviewCount,
    Expression<String>? lastResult,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (reviewCount != null) 'review_count': reviewCount,
      if (lastResult != null) 'last_result': lastResult,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewScheduleCompanion copyWith(
      {Value<String>? wordId,
      Value<DateTime>? nextReviewAt,
      Value<int>? reviewCount,
      Value<String>? lastResult,
      Value<int>? rowid}) {
    return ReviewScheduleCompanion(
      wordId: wordId ?? this.wordId,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      reviewCount: reviewCount ?? this.reviewCount,
      lastResult: lastResult ?? this.lastResult,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (lastResult.present) {
      map['last_result'] = Variable<String>(lastResult.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewScheduleCompanion(')
          ..write('wordId: $wordId, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('lastResult: $lastResult, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeaknessProfileTable extends WeaknessProfile
    with TableInfo<$WeaknessProfileTable, WeaknessProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaknessProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
      'word_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES vocabulary (id)'));
  static const VerificationMeta _weakTypeMeta =
      const VerificationMeta('weakType');
  @override
  late final GeneratedColumn<String> weakType = GeneratedColumn<String>(
      'weak_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('vocabulary'));
  static const VerificationMeta _context_Meta =
      const VerificationMeta('context_');
  @override
  late final GeneratedColumn<String> context_ = GeneratedColumn<String>(
      'context', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _detectedAtMeta =
      const VerificationMeta('detectedAt');
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
      'detected_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, wordId, weakType, context_, detectedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weakness_profile';
  @override
  VerificationContext validateIntegrity(
      Insertable<WeaknessProfileData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('weak_type')) {
      context.handle(_weakTypeMeta,
          weakType.isAcceptableOrUnknown(data['weak_type']!, _weakTypeMeta));
    }
    if (data.containsKey('context')) {
      context.handle(_context_Meta,
          context_.isAcceptableOrUnknown(data['context']!, _context_Meta));
    }
    if (data.containsKey('detected_at')) {
      context.handle(
          _detectedAtMeta,
          detectedAt.isAcceptableOrUnknown(
              data['detected_at']!, _detectedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeaknessProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeaknessProfileData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_id'])!,
      weakType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weak_type'])!,
      context_: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context'])!,
      detectedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}detected_at'])!,
    );
  }

  @override
  $WeaknessProfileTable createAlias(String alias) {
    return $WeaknessProfileTable(attachedDatabase, alias);
  }
}

class WeaknessProfileData extends DataClass
    implements Insertable<WeaknessProfileData> {
  final int id;
  final String wordId;
  final String weakType;
  final String context_;
  final DateTime detectedAt;
  const WeaknessProfileData(
      {required this.id,
      required this.wordId,
      required this.weakType,
      required this.context_,
      required this.detectedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<String>(wordId);
    map['weak_type'] = Variable<String>(weakType);
    map['context'] = Variable<String>(context_);
    map['detected_at'] = Variable<DateTime>(detectedAt);
    return map;
  }

  WeaknessProfileCompanion toCompanion(bool nullToAbsent) {
    return WeaknessProfileCompanion(
      id: Value(id),
      wordId: Value(wordId),
      weakType: Value(weakType),
      context_: Value(context_),
      detectedAt: Value(detectedAt),
    );
  }

  factory WeaknessProfileData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeaknessProfileData(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<String>(json['wordId']),
      weakType: serializer.fromJson<String>(json['weakType']),
      context_: serializer.fromJson<String>(json['context_']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<String>(wordId),
      'weakType': serializer.toJson<String>(weakType),
      'context_': serializer.toJson<String>(context_),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
    };
  }

  WeaknessProfileData copyWith(
          {int? id,
          String? wordId,
          String? weakType,
          String? context_,
          DateTime? detectedAt}) =>
      WeaknessProfileData(
        id: id ?? this.id,
        wordId: wordId ?? this.wordId,
        weakType: weakType ?? this.weakType,
        context_: context_ ?? this.context_,
        detectedAt: detectedAt ?? this.detectedAt,
      );
  WeaknessProfileData copyWithCompanion(WeaknessProfileCompanion data) {
    return WeaknessProfileData(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      weakType: data.weakType.present ? data.weakType.value : this.weakType,
      context_: data.context_.present ? data.context_.value : this.context_,
      detectedAt:
          data.detectedAt.present ? data.detectedAt.value : this.detectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeaknessProfileData(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('weakType: $weakType, ')
          ..write('context_: $context_, ')
          ..write('detectedAt: $detectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, weakType, context_, detectedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeaknessProfileData &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.weakType == this.weakType &&
          other.context_ == this.context_ &&
          other.detectedAt == this.detectedAt);
}

class WeaknessProfileCompanion extends UpdateCompanion<WeaknessProfileData> {
  final Value<int> id;
  final Value<String> wordId;
  final Value<String> weakType;
  final Value<String> context_;
  final Value<DateTime> detectedAt;
  const WeaknessProfileCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.weakType = const Value.absent(),
    this.context_ = const Value.absent(),
    this.detectedAt = const Value.absent(),
  });
  WeaknessProfileCompanion.insert({
    this.id = const Value.absent(),
    required String wordId,
    this.weakType = const Value.absent(),
    this.context_ = const Value.absent(),
    this.detectedAt = const Value.absent(),
  }) : wordId = Value(wordId);
  static Insertable<WeaknessProfileData> custom({
    Expression<int>? id,
    Expression<String>? wordId,
    Expression<String>? weakType,
    Expression<String>? context_,
    Expression<DateTime>? detectedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (weakType != null) 'weak_type': weakType,
      if (context_ != null) 'context': context_,
      if (detectedAt != null) 'detected_at': detectedAt,
    });
  }

  WeaknessProfileCompanion copyWith(
      {Value<int>? id,
      Value<String>? wordId,
      Value<String>? weakType,
      Value<String>? context_,
      Value<DateTime>? detectedAt}) {
    return WeaknessProfileCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      weakType: weakType ?? this.weakType,
      context_: context_ ?? this.context_,
      detectedAt: detectedAt ?? this.detectedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (weakType.present) {
      map['weak_type'] = Variable<String>(weakType.value);
    }
    if (context_.present) {
      map['context'] = Variable<String>(context_.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaknessProfileCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('weakType: $weakType, ')
          ..write('context_: $context_, ')
          ..write('detectedAt: $detectedAt')
          ..write(')'))
        .toString();
  }
}

class $LearningPatternsTable extends LearningPatterns
    with TableInfo<$LearningPatternsTable, LearningPattern> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningPatternsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estimatedLevelMeta =
      const VerificationMeta('estimatedLevel');
  @override
  late final GeneratedColumn<String> estimatedLevel = GeneratedColumn<String>(
      'estimated_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('B1'));
  static const VerificationMeta _levelBasisMeta =
      const VerificationMeta('levelBasis');
  @override
  late final GeneratedColumn<String> levelBasis = GeneratedColumn<String>(
      'level_basis', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _activeHoursMeta =
      const VerificationMeta('activeHours');
  @override
  late final GeneratedColumn<String> activeHours = GeneratedColumn<String>(
      'active_hours', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _avgSessionMinMeta =
      const VerificationMeta('avgSessionMin');
  @override
  late final GeneratedColumn<int> avgSessionMin = GeneratedColumn<int>(
      'avg_session_min', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _preferredTopicsMeta =
      const VerificationMeta('preferredTopics');
  @override
  late final GeneratedColumn<String> preferredTopics = GeneratedColumn<String>(
      'preferred_topics', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        estimatedLevel,
        levelBasis,
        activeHours,
        avgSessionMin,
        preferredTopics,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_patterns';
  @override
  VerificationContext validateIntegrity(Insertable<LearningPattern> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('estimated_level')) {
      context.handle(
          _estimatedLevelMeta,
          estimatedLevel.isAcceptableOrUnknown(
              data['estimated_level']!, _estimatedLevelMeta));
    }
    if (data.containsKey('level_basis')) {
      context.handle(
          _levelBasisMeta,
          levelBasis.isAcceptableOrUnknown(
              data['level_basis']!, _levelBasisMeta));
    }
    if (data.containsKey('active_hours')) {
      context.handle(
          _activeHoursMeta,
          activeHours.isAcceptableOrUnknown(
              data['active_hours']!, _activeHoursMeta));
    }
    if (data.containsKey('avg_session_min')) {
      context.handle(
          _avgSessionMinMeta,
          avgSessionMin.isAcceptableOrUnknown(
              data['avg_session_min']!, _avgSessionMinMeta));
    }
    if (data.containsKey('preferred_topics')) {
      context.handle(
          _preferredTopicsMeta,
          preferredTopics.isAcceptableOrUnknown(
              data['preferred_topics']!, _preferredTopicsMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearningPattern map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningPattern(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      estimatedLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}estimated_level'])!,
      levelBasis: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level_basis'])!,
      activeHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}active_hours'])!,
      avgSessionMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avg_session_min'])!,
      preferredTopics: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}preferred_topics'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LearningPatternsTable createAlias(String alias) {
    return $LearningPatternsTable(attachedDatabase, alias);
  }
}

class LearningPattern extends DataClass implements Insertable<LearningPattern> {
  final String id;
  final String estimatedLevel;
  final String levelBasis;
  final String activeHours;
  final int avgSessionMin;
  final String preferredTopics;
  final DateTime updatedAt;
  const LearningPattern(
      {required this.id,
      required this.estimatedLevel,
      required this.levelBasis,
      required this.activeHours,
      required this.avgSessionMin,
      required this.preferredTopics,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['estimated_level'] = Variable<String>(estimatedLevel);
    map['level_basis'] = Variable<String>(levelBasis);
    map['active_hours'] = Variable<String>(activeHours);
    map['avg_session_min'] = Variable<int>(avgSessionMin);
    map['preferred_topics'] = Variable<String>(preferredTopics);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LearningPatternsCompanion toCompanion(bool nullToAbsent) {
    return LearningPatternsCompanion(
      id: Value(id),
      estimatedLevel: Value(estimatedLevel),
      levelBasis: Value(levelBasis),
      activeHours: Value(activeHours),
      avgSessionMin: Value(avgSessionMin),
      preferredTopics: Value(preferredTopics),
      updatedAt: Value(updatedAt),
    );
  }

  factory LearningPattern.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningPattern(
      id: serializer.fromJson<String>(json['id']),
      estimatedLevel: serializer.fromJson<String>(json['estimatedLevel']),
      levelBasis: serializer.fromJson<String>(json['levelBasis']),
      activeHours: serializer.fromJson<String>(json['activeHours']),
      avgSessionMin: serializer.fromJson<int>(json['avgSessionMin']),
      preferredTopics: serializer.fromJson<String>(json['preferredTopics']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'estimatedLevel': serializer.toJson<String>(estimatedLevel),
      'levelBasis': serializer.toJson<String>(levelBasis),
      'activeHours': serializer.toJson<String>(activeHours),
      'avgSessionMin': serializer.toJson<int>(avgSessionMin),
      'preferredTopics': serializer.toJson<String>(preferredTopics),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LearningPattern copyWith(
          {String? id,
          String? estimatedLevel,
          String? levelBasis,
          String? activeHours,
          int? avgSessionMin,
          String? preferredTopics,
          DateTime? updatedAt}) =>
      LearningPattern(
        id: id ?? this.id,
        estimatedLevel: estimatedLevel ?? this.estimatedLevel,
        levelBasis: levelBasis ?? this.levelBasis,
        activeHours: activeHours ?? this.activeHours,
        avgSessionMin: avgSessionMin ?? this.avgSessionMin,
        preferredTopics: preferredTopics ?? this.preferredTopics,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LearningPattern copyWithCompanion(LearningPatternsCompanion data) {
    return LearningPattern(
      id: data.id.present ? data.id.value : this.id,
      estimatedLevel: data.estimatedLevel.present
          ? data.estimatedLevel.value
          : this.estimatedLevel,
      levelBasis:
          data.levelBasis.present ? data.levelBasis.value : this.levelBasis,
      activeHours:
          data.activeHours.present ? data.activeHours.value : this.activeHours,
      avgSessionMin: data.avgSessionMin.present
          ? data.avgSessionMin.value
          : this.avgSessionMin,
      preferredTopics: data.preferredTopics.present
          ? data.preferredTopics.value
          : this.preferredTopics,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningPattern(')
          ..write('id: $id, ')
          ..write('estimatedLevel: $estimatedLevel, ')
          ..write('levelBasis: $levelBasis, ')
          ..write('activeHours: $activeHours, ')
          ..write('avgSessionMin: $avgSessionMin, ')
          ..write('preferredTopics: $preferredTopics, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, estimatedLevel, levelBasis, activeHours,
      avgSessionMin, preferredTopics, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningPattern &&
          other.id == this.id &&
          other.estimatedLevel == this.estimatedLevel &&
          other.levelBasis == this.levelBasis &&
          other.activeHours == this.activeHours &&
          other.avgSessionMin == this.avgSessionMin &&
          other.preferredTopics == this.preferredTopics &&
          other.updatedAt == this.updatedAt);
}

class LearningPatternsCompanion extends UpdateCompanion<LearningPattern> {
  final Value<String> id;
  final Value<String> estimatedLevel;
  final Value<String> levelBasis;
  final Value<String> activeHours;
  final Value<int> avgSessionMin;
  final Value<String> preferredTopics;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LearningPatternsCompanion({
    this.id = const Value.absent(),
    this.estimatedLevel = const Value.absent(),
    this.levelBasis = const Value.absent(),
    this.activeHours = const Value.absent(),
    this.avgSessionMin = const Value.absent(),
    this.preferredTopics = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningPatternsCompanion.insert({
    required String id,
    this.estimatedLevel = const Value.absent(),
    this.levelBasis = const Value.absent(),
    this.activeHours = const Value.absent(),
    this.avgSessionMin = const Value.absent(),
    this.preferredTopics = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<LearningPattern> custom({
    Expression<String>? id,
    Expression<String>? estimatedLevel,
    Expression<String>? levelBasis,
    Expression<String>? activeHours,
    Expression<int>? avgSessionMin,
    Expression<String>? preferredTopics,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (estimatedLevel != null) 'estimated_level': estimatedLevel,
      if (levelBasis != null) 'level_basis': levelBasis,
      if (activeHours != null) 'active_hours': activeHours,
      if (avgSessionMin != null) 'avg_session_min': avgSessionMin,
      if (preferredTopics != null) 'preferred_topics': preferredTopics,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningPatternsCompanion copyWith(
      {Value<String>? id,
      Value<String>? estimatedLevel,
      Value<String>? levelBasis,
      Value<String>? activeHours,
      Value<int>? avgSessionMin,
      Value<String>? preferredTopics,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LearningPatternsCompanion(
      id: id ?? this.id,
      estimatedLevel: estimatedLevel ?? this.estimatedLevel,
      levelBasis: levelBasis ?? this.levelBasis,
      activeHours: activeHours ?? this.activeHours,
      avgSessionMin: avgSessionMin ?? this.avgSessionMin,
      preferredTopics: preferredTopics ?? this.preferredTopics,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (estimatedLevel.present) {
      map['estimated_level'] = Variable<String>(estimatedLevel.value);
    }
    if (levelBasis.present) {
      map['level_basis'] = Variable<String>(levelBasis.value);
    }
    if (activeHours.present) {
      map['active_hours'] = Variable<String>(activeHours.value);
    }
    if (avgSessionMin.present) {
      map['avg_session_min'] = Variable<int>(avgSessionMin.value);
    }
    if (preferredTopics.present) {
      map['preferred_topics'] = Variable<String>(preferredTopics.value);
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
    return (StringBuffer('LearningPatternsCompanion(')
          ..write('id: $id, ')
          ..write('estimatedLevel: $estimatedLevel, ')
          ..write('levelBasis: $levelBasis, ')
          ..write('activeHours: $activeHours, ')
          ..write('avgSessionMin: $avgSessionMin, ')
          ..write('preferredTopics: $preferredTopics, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AudioItemsTable audioItems = $AudioItemsTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $TranscriptsTable transcripts = $TranscriptsTable(this);
  late final $WordsTable words = $WordsTable(this);
  late final $VocabularyTable vocabulary = $VocabularyTable(this);
  late final $PlaybackStateTable playbackState = $PlaybackStateTable(this);
  late final $WordMemoryTable wordMemory = $WordMemoryTable(this);
  late final $ContentMemoryTable contentMemory = $ContentMemoryTable(this);
  late final $AgentSessionsTable agentSessions = $AgentSessionsTable(this);
  late final $ReviewScheduleTable reviewSchedule = $ReviewScheduleTable(this);
  late final $WeaknessProfileTable weaknessProfile =
      $WeaknessProfileTable(this);
  late final $LearningPatternsTable learningPatterns =
      $LearningPatternsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        audioItems,
        chapters,
        transcripts,
        words,
        vocabulary,
        playbackState,
        wordMemory,
        contentMemory,
        agentSessions,
        reviewSchedule,
        weaknessProfile,
        learningPatterns
      ];
}

typedef $$AudioItemsTableCreateCompanionBuilder = AudioItemsCompanion Function({
  required String id,
  required String title,
  required String filePath,
  Value<int?> durationMs,
  Value<String> transcriptionStatus,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AudioItemsTableUpdateCompanionBuilder = AudioItemsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> filePath,
  Value<int?> durationMs,
  Value<String> transcriptionStatus,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AudioItemsTableReferences
    extends BaseReferences<_$AppDatabase, $AudioItemsTable, AudioItem> {
  $$AudioItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChaptersTable, List<Chapter>> _chaptersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.chapters,
          aliasName:
              $_aliasNameGenerator(db.audioItems.id, db.chapters.audioId));

  $$ChaptersTableProcessedTableManager get chaptersRefs {
    final manager = $$ChaptersTableTableManager($_db, $_db.chapters)
        .filter((f) => f.audioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TranscriptsTable, List<Transcript>>
      _transcriptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.transcripts,
          aliasName:
              $_aliasNameGenerator(db.audioItems.id, db.transcripts.audioId));

  $$TranscriptsTableProcessedTableManager get transcriptsRefs {
    final manager = $$TranscriptsTableTableManager($_db, $_db.transcripts)
        .filter((f) => f.audioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transcriptsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$VocabularyTable, List<VocabularyData>>
      _vocabularyRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.vocabulary,
          aliasName:
              $_aliasNameGenerator(db.audioItems.id, db.vocabulary.audioId));

  $$VocabularyTableProcessedTableManager get vocabularyRefs {
    final manager = $$VocabularyTableTableManager($_db, $_db.vocabulary)
        .filter((f) => f.audioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vocabularyRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlaybackStateTable, List<PlaybackStateData>>
      _playbackStateRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.playbackState,
              aliasName: $_aliasNameGenerator(
                  db.audioItems.id, db.playbackState.audioId));

  $$PlaybackStateTableProcessedTableManager get playbackStateRefs {
    final manager = $$PlaybackStateTableTableManager($_db, $_db.playbackState)
        .filter((f) => f.audioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playbackStateRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ContentMemoryTable, List<ContentMemoryData>>
      _contentMemoryRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.contentMemory,
              aliasName: $_aliasNameGenerator(
                  db.audioItems.id, db.contentMemory.audioId));

  $$ContentMemoryTableProcessedTableManager get contentMemoryRefs {
    final manager = $$ContentMemoryTableTableManager($_db, $_db.contentMemory)
        .filter((f) => f.audioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_contentMemoryRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AgentSessionsTable, List<AgentSession>>
      _agentSessionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.agentSessions,
              aliasName: $_aliasNameGenerator(
                  db.audioItems.id, db.agentSessions.audioId));

  $$AgentSessionsTableProcessedTableManager get agentSessionsRefs {
    final manager = $$AgentSessionsTableTableManager($_db, $_db.agentSessions)
        .filter((f) => f.audioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_agentSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AudioItemsTableFilterComposer
    extends Composer<_$AppDatabase, $AudioItemsTable> {
  $$AudioItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transcriptionStatus => $composableBuilder(
      column: $table.transcriptionStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> chaptersRefs(
      Expression<bool> Function($$ChaptersTableFilterComposer f) f) {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableFilterComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transcriptsRefs(
      Expression<bool> Function($$TranscriptsTableFilterComposer f) f) {
    final $$TranscriptsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transcripts,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptsTableFilterComposer(
              $db: $db,
              $table: $db.transcripts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> vocabularyRefs(
      Expression<bool> Function($$VocabularyTableFilterComposer f) f) {
    final $$VocabularyTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableFilterComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> playbackStateRefs(
      Expression<bool> Function($$PlaybackStateTableFilterComposer f) f) {
    final $$PlaybackStateTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playbackState,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaybackStateTableFilterComposer(
              $db: $db,
              $table: $db.playbackState,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> contentMemoryRefs(
      Expression<bool> Function($$ContentMemoryTableFilterComposer f) f) {
    final $$ContentMemoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.contentMemory,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContentMemoryTableFilterComposer(
              $db: $db,
              $table: $db.contentMemory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> agentSessionsRefs(
      Expression<bool> Function($$AgentSessionsTableFilterComposer f) f) {
    final $$AgentSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agentSessions,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgentSessionsTableFilterComposer(
              $db: $db,
              $table: $db.agentSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AudioItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $AudioItemsTable> {
  $$AudioItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transcriptionStatus => $composableBuilder(
      column: $table.transcriptionStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AudioItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudioItemsTable> {
  $$AudioItemsTableAnnotationComposer({
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

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => column);

  GeneratedColumn<String> get transcriptionStatus => $composableBuilder(
      column: $table.transcriptionStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> chaptersRefs<T extends Object>(
      Expression<T> Function($$ChaptersTableAnnotationComposer a) f) {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableAnnotationComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transcriptsRefs<T extends Object>(
      Expression<T> Function($$TranscriptsTableAnnotationComposer a) f) {
    final $$TranscriptsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transcripts,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptsTableAnnotationComposer(
              $db: $db,
              $table: $db.transcripts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> vocabularyRefs<T extends Object>(
      Expression<T> Function($$VocabularyTableAnnotationComposer a) f) {
    final $$VocabularyTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableAnnotationComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> playbackStateRefs<T extends Object>(
      Expression<T> Function($$PlaybackStateTableAnnotationComposer a) f) {
    final $$PlaybackStateTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playbackState,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaybackStateTableAnnotationComposer(
              $db: $db,
              $table: $db.playbackState,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> contentMemoryRefs<T extends Object>(
      Expression<T> Function($$ContentMemoryTableAnnotationComposer a) f) {
    final $$ContentMemoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.contentMemory,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContentMemoryTableAnnotationComposer(
              $db: $db,
              $table: $db.contentMemory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> agentSessionsRefs<T extends Object>(
      Expression<T> Function($$AgentSessionsTableAnnotationComposer a) f) {
    final $$AgentSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agentSessions,
        getReferencedColumn: (t) => t.audioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgentSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.agentSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AudioItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AudioItemsTable,
    AudioItem,
    $$AudioItemsTableFilterComposer,
    $$AudioItemsTableOrderingComposer,
    $$AudioItemsTableAnnotationComposer,
    $$AudioItemsTableCreateCompanionBuilder,
    $$AudioItemsTableUpdateCompanionBuilder,
    (AudioItem, $$AudioItemsTableReferences),
    AudioItem,
    PrefetchHooks Function(
        {bool chaptersRefs,
        bool transcriptsRefs,
        bool vocabularyRefs,
        bool playbackStateRefs,
        bool contentMemoryRefs,
        bool agentSessionsRefs})> {
  $$AudioItemsTableTableManager(_$AppDatabase db, $AudioItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<int?> durationMs = const Value.absent(),
            Value<String> transcriptionStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AudioItemsCompanion(
            id: id,
            title: title,
            filePath: filePath,
            durationMs: durationMs,
            transcriptionStatus: transcriptionStatus,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String filePath,
            Value<int?> durationMs = const Value.absent(),
            Value<String> transcriptionStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AudioItemsCompanion.insert(
            id: id,
            title: title,
            filePath: filePath,
            durationMs: durationMs,
            transcriptionStatus: transcriptionStatus,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AudioItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {chaptersRefs = false,
              transcriptsRefs = false,
              vocabularyRefs = false,
              playbackStateRefs = false,
              contentMemoryRefs = false,
              agentSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (chaptersRefs) db.chapters,
                if (transcriptsRefs) db.transcripts,
                if (vocabularyRefs) db.vocabulary,
                if (playbackStateRefs) db.playbackState,
                if (contentMemoryRefs) db.contentMemory,
                if (agentSessionsRefs) db.agentSessions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chaptersRefs)
                    await $_getPrefetchedData<AudioItem, $AudioItemsTable,
                            Chapter>(
                        currentTable: table,
                        referencedTable:
                            $$AudioItemsTableReferences._chaptersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AudioItemsTableReferences(db, table, p0)
                                .chaptersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.audioId == item.id),
                        typedResults: items),
                  if (transcriptsRefs)
                    await $_getPrefetchedData<AudioItem, $AudioItemsTable,
                            Transcript>(
                        currentTable: table,
                        referencedTable: $$AudioItemsTableReferences
                            ._transcriptsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AudioItemsTableReferences(db, table, p0)
                                .transcriptsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.audioId == item.id),
                        typedResults: items),
                  if (vocabularyRefs)
                    await $_getPrefetchedData<AudioItem, $AudioItemsTable,
                            VocabularyData>(
                        currentTable: table,
                        referencedTable: $$AudioItemsTableReferences
                            ._vocabularyRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AudioItemsTableReferences(db, table, p0)
                                .vocabularyRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.audioId == item.id),
                        typedResults: items),
                  if (playbackStateRefs)
                    await $_getPrefetchedData<AudioItem, $AudioItemsTable,
                            PlaybackStateData>(
                        currentTable: table,
                        referencedTable: $$AudioItemsTableReferences
                            ._playbackStateRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AudioItemsTableReferences(db, table, p0)
                                .playbackStateRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.audioId == item.id),
                        typedResults: items),
                  if (contentMemoryRefs)
                    await $_getPrefetchedData<AudioItem, $AudioItemsTable,
                            ContentMemoryData>(
                        currentTable: table,
                        referencedTable: $$AudioItemsTableReferences
                            ._contentMemoryRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AudioItemsTableReferences(db, table, p0)
                                .contentMemoryRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.audioId == item.id),
                        typedResults: items),
                  if (agentSessionsRefs)
                    await $_getPrefetchedData<AudioItem, $AudioItemsTable,
                            AgentSession>(
                        currentTable: table,
                        referencedTable: $$AudioItemsTableReferences
                            ._agentSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AudioItemsTableReferences(db, table, p0)
                                .agentSessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.audioId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AudioItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AudioItemsTable,
    AudioItem,
    $$AudioItemsTableFilterComposer,
    $$AudioItemsTableOrderingComposer,
    $$AudioItemsTableAnnotationComposer,
    $$AudioItemsTableCreateCompanionBuilder,
    $$AudioItemsTableUpdateCompanionBuilder,
    (AudioItem, $$AudioItemsTableReferences),
    AudioItem,
    PrefetchHooks Function(
        {bool chaptersRefs,
        bool transcriptsRefs,
        bool vocabularyRefs,
        bool playbackStateRefs,
        bool contentMemoryRefs,
        bool agentSessionsRefs})>;
typedef $$ChaptersTableCreateCompanionBuilder = ChaptersCompanion Function({
  required String id,
  required String audioId,
  required int index,
  Value<String> title,
  required int startMs,
  required int endMs,
  Value<bool> isHeard,
  Value<int> rowid,
});
typedef $$ChaptersTableUpdateCompanionBuilder = ChaptersCompanion Function({
  Value<String> id,
  Value<String> audioId,
  Value<int> index,
  Value<String> title,
  Value<int> startMs,
  Value<int> endMs,
  Value<bool> isHeard,
  Value<int> rowid,
});

final class $$ChaptersTableReferences
    extends BaseReferences<_$AppDatabase, $ChaptersTable, Chapter> {
  $$ChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AudioItemsTable _audioIdTable(_$AppDatabase db) => db.audioItems
      .createAlias($_aliasNameGenerator(db.chapters.audioId, db.audioItems.id));

  $$AudioItemsTableProcessedTableManager get audioId {
    final $_column = $_itemColumn<String>('audio_id')!;

    final manager = $$AudioItemsTableTableManager($_db, $_db.audioItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$VocabularyTable, List<VocabularyData>>
      _vocabularyRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.vocabulary,
          aliasName:
              $_aliasNameGenerator(db.chapters.id, db.vocabulary.chapterId));

  $$VocabularyTableProcessedTableManager get vocabularyRefs {
    final manager = $$VocabularyTableTableManager($_db, $_db.vocabulary)
        .filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vocabularyRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AgentSessionsTable, List<AgentSession>>
      _agentSessionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.agentSessions,
              aliasName: $_aliasNameGenerator(
                  db.chapters.id, db.agentSessions.chapterId));

  $$AgentSessionsTableProcessedTableManager get agentSessionsRefs {
    final manager = $$AgentSessionsTableTableManager($_db, $_db.agentSessions)
        .filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_agentSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get index => $composableBuilder(
      column: $table.index, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startMs => $composableBuilder(
      column: $table.startMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endMs => $composableBuilder(
      column: $table.endMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHeard => $composableBuilder(
      column: $table.isHeard, builder: (column) => ColumnFilters(column));

  $$AudioItemsTableFilterComposer get audioId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableFilterComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> vocabularyRefs(
      Expression<bool> Function($$VocabularyTableFilterComposer f) f) {
    final $$VocabularyTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.chapterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableFilterComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> agentSessionsRefs(
      Expression<bool> Function($$AgentSessionsTableFilterComposer f) f) {
    final $$AgentSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agentSessions,
        getReferencedColumn: (t) => t.chapterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgentSessionsTableFilterComposer(
              $db: $db,
              $table: $db.agentSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get index => $composableBuilder(
      column: $table.index, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startMs => $composableBuilder(
      column: $table.startMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endMs => $composableBuilder(
      column: $table.endMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHeard => $composableBuilder(
      column: $table.isHeard, builder: (column) => ColumnOrderings(column));

  $$AudioItemsTableOrderingComposer get audioId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableOrderingComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get index =>
      $composableBuilder(column: $table.index, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get startMs =>
      $composableBuilder(column: $table.startMs, builder: (column) => column);

  GeneratedColumn<int> get endMs =>
      $composableBuilder(column: $table.endMs, builder: (column) => column);

  GeneratedColumn<bool> get isHeard =>
      $composableBuilder(column: $table.isHeard, builder: (column) => column);

  $$AudioItemsTableAnnotationComposer get audioId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> vocabularyRefs<T extends Object>(
      Expression<T> Function($$VocabularyTableAnnotationComposer a) f) {
    final $$VocabularyTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.chapterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableAnnotationComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> agentSessionsRefs<T extends Object>(
      Expression<T> Function($$AgentSessionsTableAnnotationComposer a) f) {
    final $$AgentSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agentSessions,
        getReferencedColumn: (t) => t.chapterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgentSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.agentSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChaptersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChaptersTable,
    Chapter,
    $$ChaptersTableFilterComposer,
    $$ChaptersTableOrderingComposer,
    $$ChaptersTableAnnotationComposer,
    $$ChaptersTableCreateCompanionBuilder,
    $$ChaptersTableUpdateCompanionBuilder,
    (Chapter, $$ChaptersTableReferences),
    Chapter,
    PrefetchHooks Function(
        {bool audioId, bool vocabularyRefs, bool agentSessionsRefs})> {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> audioId = const Value.absent(),
            Value<int> index = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> startMs = const Value.absent(),
            Value<int> endMs = const Value.absent(),
            Value<bool> isHeard = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersCompanion(
            id: id,
            audioId: audioId,
            index: index,
            title: title,
            startMs: startMs,
            endMs: endMs,
            isHeard: isHeard,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String audioId,
            required int index,
            Value<String> title = const Value.absent(),
            required int startMs,
            required int endMs,
            Value<bool> isHeard = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersCompanion.insert(
            id: id,
            audioId: audioId,
            index: index,
            title: title,
            startMs: startMs,
            endMs: endMs,
            isHeard: isHeard,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ChaptersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {audioId = false,
              vocabularyRefs = false,
              agentSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (vocabularyRefs) db.vocabulary,
                if (agentSessionsRefs) db.agentSessions
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (audioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.audioId,
                    referencedTable:
                        $$ChaptersTableReferences._audioIdTable(db),
                    referencedColumn:
                        $$ChaptersTableReferences._audioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vocabularyRefs)
                    await $_getPrefetchedData<Chapter, $ChaptersTable,
                            VocabularyData>(
                        currentTable: table,
                        referencedTable:
                            $$ChaptersTableReferences._vocabularyRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChaptersTableReferences(db, table, p0)
                                .vocabularyRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.chapterId == item.id),
                        typedResults: items),
                  if (agentSessionsRefs)
                    await $_getPrefetchedData<Chapter, $ChaptersTable,
                            AgentSession>(
                        currentTable: table,
                        referencedTable: $$ChaptersTableReferences
                            ._agentSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChaptersTableReferences(db, table, p0)
                                .agentSessionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.chapterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChaptersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChaptersTable,
    Chapter,
    $$ChaptersTableFilterComposer,
    $$ChaptersTableOrderingComposer,
    $$ChaptersTableAnnotationComposer,
    $$ChaptersTableCreateCompanionBuilder,
    $$ChaptersTableUpdateCompanionBuilder,
    (Chapter, $$ChaptersTableReferences),
    Chapter,
    PrefetchHooks Function(
        {bool audioId, bool vocabularyRefs, bool agentSessionsRefs})>;
typedef $$TranscriptsTableCreateCompanionBuilder = TranscriptsCompanion
    Function({
  required String id,
  required String audioId,
  required int segmentIndex,
  required String text_,
  required int startMs,
  required int endMs,
  Value<int> offsetAdjust,
  Value<int> rowid,
});
typedef $$TranscriptsTableUpdateCompanionBuilder = TranscriptsCompanion
    Function({
  Value<String> id,
  Value<String> audioId,
  Value<int> segmentIndex,
  Value<String> text_,
  Value<int> startMs,
  Value<int> endMs,
  Value<int> offsetAdjust,
  Value<int> rowid,
});

final class $$TranscriptsTableReferences
    extends BaseReferences<_$AppDatabase, $TranscriptsTable, Transcript> {
  $$TranscriptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AudioItemsTable _audioIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
          $_aliasNameGenerator(db.transcripts.audioId, db.audioItems.id));

  $$AudioItemsTableProcessedTableManager get audioId {
    final $_column = $_itemColumn<String>('audio_id')!;

    final manager = $$AudioItemsTableTableManager($_db, $_db.audioItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$WordsTable, List<Word>> _wordsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.words,
          aliasName:
              $_aliasNameGenerator(db.transcripts.id, db.words.transcriptId));

  $$WordsTableProcessedTableManager get wordsRefs {
    final manager = $$WordsTableTableManager($_db, $_db.words).filter(
        (f) => f.transcriptId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TranscriptsTableFilterComposer
    extends Composer<_$AppDatabase, $TranscriptsTable> {
  $$TranscriptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get segmentIndex => $composableBuilder(
      column: $table.segmentIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get text_ => $composableBuilder(
      column: $table.text_, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startMs => $composableBuilder(
      column: $table.startMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endMs => $composableBuilder(
      column: $table.endMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get offsetAdjust => $composableBuilder(
      column: $table.offsetAdjust, builder: (column) => ColumnFilters(column));

  $$AudioItemsTableFilterComposer get audioId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableFilterComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> wordsRefs(
      Expression<bool> Function($$WordsTableFilterComposer f) f) {
    final $$WordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.transcriptId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableFilterComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TranscriptsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranscriptsTable> {
  $$TranscriptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get segmentIndex => $composableBuilder(
      column: $table.segmentIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get text_ => $composableBuilder(
      column: $table.text_, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startMs => $composableBuilder(
      column: $table.startMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endMs => $composableBuilder(
      column: $table.endMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get offsetAdjust => $composableBuilder(
      column: $table.offsetAdjust,
      builder: (column) => ColumnOrderings(column));

  $$AudioItemsTableOrderingComposer get audioId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableOrderingComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TranscriptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranscriptsTable> {
  $$TranscriptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get segmentIndex => $composableBuilder(
      column: $table.segmentIndex, builder: (column) => column);

  GeneratedColumn<String> get text_ =>
      $composableBuilder(column: $table.text_, builder: (column) => column);

  GeneratedColumn<int> get startMs =>
      $composableBuilder(column: $table.startMs, builder: (column) => column);

  GeneratedColumn<int> get endMs =>
      $composableBuilder(column: $table.endMs, builder: (column) => column);

  GeneratedColumn<int> get offsetAdjust => $composableBuilder(
      column: $table.offsetAdjust, builder: (column) => column);

  $$AudioItemsTableAnnotationComposer get audioId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> wordsRefs<T extends Object>(
      Expression<T> Function($$WordsTableAnnotationComposer a) f) {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.words,
        getReferencedColumn: (t) => t.transcriptId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordsTableAnnotationComposer(
              $db: $db,
              $table: $db.words,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TranscriptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranscriptsTable,
    Transcript,
    $$TranscriptsTableFilterComposer,
    $$TranscriptsTableOrderingComposer,
    $$TranscriptsTableAnnotationComposer,
    $$TranscriptsTableCreateCompanionBuilder,
    $$TranscriptsTableUpdateCompanionBuilder,
    (Transcript, $$TranscriptsTableReferences),
    Transcript,
    PrefetchHooks Function({bool audioId, bool wordsRefs})> {
  $$TranscriptsTableTableManager(_$AppDatabase db, $TranscriptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranscriptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranscriptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranscriptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> audioId = const Value.absent(),
            Value<int> segmentIndex = const Value.absent(),
            Value<String> text_ = const Value.absent(),
            Value<int> startMs = const Value.absent(),
            Value<int> endMs = const Value.absent(),
            Value<int> offsetAdjust = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TranscriptsCompanion(
            id: id,
            audioId: audioId,
            segmentIndex: segmentIndex,
            text_: text_,
            startMs: startMs,
            endMs: endMs,
            offsetAdjust: offsetAdjust,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String audioId,
            required int segmentIndex,
            required String text_,
            required int startMs,
            required int endMs,
            Value<int> offsetAdjust = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TranscriptsCompanion.insert(
            id: id,
            audioId: audioId,
            segmentIndex: segmentIndex,
            text_: text_,
            startMs: startMs,
            endMs: endMs,
            offsetAdjust: offsetAdjust,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TranscriptsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({audioId = false, wordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (wordsRefs) db.words],
              addJoins: <
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
                      dynamic>>(state) {
                if (audioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.audioId,
                    referencedTable:
                        $$TranscriptsTableReferences._audioIdTable(db),
                    referencedColumn:
                        $$TranscriptsTableReferences._audioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (wordsRefs)
                    await $_getPrefetchedData<Transcript, $TranscriptsTable,
                            Word>(
                        currentTable: table,
                        referencedTable:
                            $$TranscriptsTableReferences._wordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TranscriptsTableReferences(db, table, p0)
                                .wordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transcriptId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TranscriptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranscriptsTable,
    Transcript,
    $$TranscriptsTableFilterComposer,
    $$TranscriptsTableOrderingComposer,
    $$TranscriptsTableAnnotationComposer,
    $$TranscriptsTableCreateCompanionBuilder,
    $$TranscriptsTableUpdateCompanionBuilder,
    (Transcript, $$TranscriptsTableReferences),
    Transcript,
    PrefetchHooks Function({bool audioId, bool wordsRefs})>;
typedef $$WordsTableCreateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  required String wordText,
  required int startMs,
  required int endMs,
  required String transcriptId,
});
typedef $$WordsTableUpdateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  Value<String> wordText,
  Value<int> startMs,
  Value<int> endMs,
  Value<String> transcriptId,
});

final class $$WordsTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTable, Word> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TranscriptsTable _transcriptIdTable(_$AppDatabase db) =>
      db.transcripts.createAlias(
          $_aliasNameGenerator(db.words.transcriptId, db.transcripts.id));

  $$TranscriptsTableProcessedTableManager get transcriptId {
    final $_column = $_itemColumn<String>('transcript_id')!;

    final manager = $$TranscriptsTableTableManager($_db, $_db.transcripts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transcriptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wordText => $composableBuilder(
      column: $table.wordText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startMs => $composableBuilder(
      column: $table.startMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endMs => $composableBuilder(
      column: $table.endMs, builder: (column) => ColumnFilters(column));

  $$TranscriptsTableFilterComposer get transcriptId {
    final $$TranscriptsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transcriptId,
        referencedTable: $db.transcripts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptsTableFilterComposer(
              $db: $db,
              $table: $db.transcripts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wordText => $composableBuilder(
      column: $table.wordText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startMs => $composableBuilder(
      column: $table.startMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endMs => $composableBuilder(
      column: $table.endMs, builder: (column) => ColumnOrderings(column));

  $$TranscriptsTableOrderingComposer get transcriptId {
    final $$TranscriptsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transcriptId,
        referencedTable: $db.transcripts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptsTableOrderingComposer(
              $db: $db,
              $table: $db.transcripts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wordText =>
      $composableBuilder(column: $table.wordText, builder: (column) => column);

  GeneratedColumn<int> get startMs =>
      $composableBuilder(column: $table.startMs, builder: (column) => column);

  GeneratedColumn<int> get endMs =>
      $composableBuilder(column: $table.endMs, builder: (column) => column);

  $$TranscriptsTableAnnotationComposer get transcriptId {
    final $$TranscriptsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transcriptId,
        referencedTable: $db.transcripts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptsTableAnnotationComposer(
              $db: $db,
              $table: $db.transcripts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WordsTable,
    Word,
    $$WordsTableFilterComposer,
    $$WordsTableOrderingComposer,
    $$WordsTableAnnotationComposer,
    $$WordsTableCreateCompanionBuilder,
    $$WordsTableUpdateCompanionBuilder,
    (Word, $$WordsTableReferences),
    Word,
    PrefetchHooks Function({bool transcriptId})> {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> wordText = const Value.absent(),
            Value<int> startMs = const Value.absent(),
            Value<int> endMs = const Value.absent(),
            Value<String> transcriptId = const Value.absent(),
          }) =>
              WordsCompanion(
            id: id,
            wordText: wordText,
            startMs: startMs,
            endMs: endMs,
            transcriptId: transcriptId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String wordText,
            required int startMs,
            required int endMs,
            required String transcriptId,
          }) =>
              WordsCompanion.insert(
            id: id,
            wordText: wordText,
            startMs: startMs,
            endMs: endMs,
            transcriptId: transcriptId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$WordsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({transcriptId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (transcriptId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transcriptId,
                    referencedTable:
                        $$WordsTableReferences._transcriptIdTable(db),
                    referencedColumn:
                        $$WordsTableReferences._transcriptIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WordsTable,
    Word,
    $$WordsTableFilterComposer,
    $$WordsTableOrderingComposer,
    $$WordsTableAnnotationComposer,
    $$WordsTableCreateCompanionBuilder,
    $$WordsTableUpdateCompanionBuilder,
    (Word, $$WordsTableReferences),
    Word,
    PrefetchHooks Function({bool transcriptId})>;
typedef $$VocabularyTableCreateCompanionBuilder = VocabularyCompanion Function({
  required String id,
  required String word,
  Value<String> phonetic,
  Value<String> pos,
  Value<String> meaning,
  Value<String> definition,
  required String audioId,
  Value<String?> chapterId,
  Value<int> sourceOffsetMs,
  Value<DateTime> createdAt,
  Value<int> reviewCount,
  Value<int> rowid,
});
typedef $$VocabularyTableUpdateCompanionBuilder = VocabularyCompanion Function({
  Value<String> id,
  Value<String> word,
  Value<String> phonetic,
  Value<String> pos,
  Value<String> meaning,
  Value<String> definition,
  Value<String> audioId,
  Value<String?> chapterId,
  Value<int> sourceOffsetMs,
  Value<DateTime> createdAt,
  Value<int> reviewCount,
  Value<int> rowid,
});

final class $$VocabularyTableReferences
    extends BaseReferences<_$AppDatabase, $VocabularyTable, VocabularyData> {
  $$VocabularyTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AudioItemsTable _audioIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
          $_aliasNameGenerator(db.vocabulary.audioId, db.audioItems.id));

  $$AudioItemsTableProcessedTableManager get audioId {
    final $_column = $_itemColumn<String>('audio_id')!;

    final manager = $$AudioItemsTableTableManager($_db, $_db.audioItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias(
          $_aliasNameGenerator(db.vocabulary.chapterId, db.chapters.id));

  $$ChaptersTableProcessedTableManager? get chapterId {
    final $_column = $_itemColumn<String>('chapter_id');
    if ($_column == null) return null;
    final manager = $$ChaptersTableTableManager($_db, $_db.chapters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$WordMemoryTable, List<WordMemoryData>>
      _wordMemoryRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.wordMemory,
              aliasName:
                  $_aliasNameGenerator(db.vocabulary.id, db.wordMemory.wordId));

  $$WordMemoryTableProcessedTableManager get wordMemoryRefs {
    final manager = $$WordMemoryTableTableManager($_db, $_db.wordMemory)
        .filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordMemoryRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReviewScheduleTable, List<ReviewScheduleData>>
      _reviewScheduleRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reviewSchedule,
              aliasName: $_aliasNameGenerator(
                  db.vocabulary.id, db.reviewSchedule.wordId));

  $$ReviewScheduleTableProcessedTableManager get reviewScheduleRefs {
    final manager = $$ReviewScheduleTableTableManager($_db, $_db.reviewSchedule)
        .filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewScheduleRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WeaknessProfileTable, List<WeaknessProfileData>>
      _weaknessProfileRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.weaknessProfile,
              aliasName: $_aliasNameGenerator(
                  db.vocabulary.id, db.weaknessProfile.wordId));

  $$WeaknessProfileTableProcessedTableManager get weaknessProfileRefs {
    final manager =
        $$WeaknessProfileTableTableManager($_db, $_db.weaknessProfile)
            .filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_weaknessProfileRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$VocabularyTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularyTable> {
  $$VocabularyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phonetic => $composableBuilder(
      column: $table.phonetic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pos => $composableBuilder(
      column: $table.pos, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaning => $composableBuilder(
      column: $table.meaning, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definition => $composableBuilder(
      column: $table.definition, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceOffsetMs => $composableBuilder(
      column: $table.sourceOffsetMs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnFilters(column));

  $$AudioItemsTableFilterComposer get audioId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableFilterComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableFilterComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> wordMemoryRefs(
      Expression<bool> Function($$WordMemoryTableFilterComposer f) f) {
    final $$WordMemoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.wordMemory,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordMemoryTableFilterComposer(
              $db: $db,
              $table: $db.wordMemory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> reviewScheduleRefs(
      Expression<bool> Function($$ReviewScheduleTableFilterComposer f) f) {
    final $$ReviewScheduleTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reviewSchedule,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReviewScheduleTableFilterComposer(
              $db: $db,
              $table: $db.reviewSchedule,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> weaknessProfileRefs(
      Expression<bool> Function($$WeaknessProfileTableFilterComposer f) f) {
    final $$WeaknessProfileTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.weaknessProfile,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeaknessProfileTableFilterComposer(
              $db: $db,
              $table: $db.weaknessProfile,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VocabularyTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularyTable> {
  $$VocabularyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phonetic => $composableBuilder(
      column: $table.phonetic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pos => $composableBuilder(
      column: $table.pos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaning => $composableBuilder(
      column: $table.meaning, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definition => $composableBuilder(
      column: $table.definition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceOffsetMs => $composableBuilder(
      column: $table.sourceOffsetMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnOrderings(column));

  $$AudioItemsTableOrderingComposer get audioId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableOrderingComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableOrderingComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VocabularyTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularyTable> {
  $$VocabularyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get phonetic =>
      $composableBuilder(column: $table.phonetic, builder: (column) => column);

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  GeneratedColumn<String> get definition => $composableBuilder(
      column: $table.definition, builder: (column) => column);

  GeneratedColumn<int> get sourceOffsetMs => $composableBuilder(
      column: $table.sourceOffsetMs, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => column);

  $$AudioItemsTableAnnotationComposer get audioId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableAnnotationComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> wordMemoryRefs<T extends Object>(
      Expression<T> Function($$WordMemoryTableAnnotationComposer a) f) {
    final $$WordMemoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.wordMemory,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WordMemoryTableAnnotationComposer(
              $db: $db,
              $table: $db.wordMemory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> reviewScheduleRefs<T extends Object>(
      Expression<T> Function($$ReviewScheduleTableAnnotationComposer a) f) {
    final $$ReviewScheduleTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reviewSchedule,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReviewScheduleTableAnnotationComposer(
              $db: $db,
              $table: $db.reviewSchedule,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> weaknessProfileRefs<T extends Object>(
      Expression<T> Function($$WeaknessProfileTableAnnotationComposer a) f) {
    final $$WeaknessProfileTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.weaknessProfile,
        getReferencedColumn: (t) => t.wordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeaknessProfileTableAnnotationComposer(
              $db: $db,
              $table: $db.weaknessProfile,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VocabularyTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VocabularyTable,
    VocabularyData,
    $$VocabularyTableFilterComposer,
    $$VocabularyTableOrderingComposer,
    $$VocabularyTableAnnotationComposer,
    $$VocabularyTableCreateCompanionBuilder,
    $$VocabularyTableUpdateCompanionBuilder,
    (VocabularyData, $$VocabularyTableReferences),
    VocabularyData,
    PrefetchHooks Function(
        {bool audioId,
        bool chapterId,
        bool wordMemoryRefs,
        bool reviewScheduleRefs,
        bool weaknessProfileRefs})> {
  $$VocabularyTableTableManager(_$AppDatabase db, $VocabularyTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> word = const Value.absent(),
            Value<String> phonetic = const Value.absent(),
            Value<String> pos = const Value.absent(),
            Value<String> meaning = const Value.absent(),
            Value<String> definition = const Value.absent(),
            Value<String> audioId = const Value.absent(),
            Value<String?> chapterId = const Value.absent(),
            Value<int> sourceOffsetMs = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabularyCompanion(
            id: id,
            word: word,
            phonetic: phonetic,
            pos: pos,
            meaning: meaning,
            definition: definition,
            audioId: audioId,
            chapterId: chapterId,
            sourceOffsetMs: sourceOffsetMs,
            createdAt: createdAt,
            reviewCount: reviewCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String word,
            Value<String> phonetic = const Value.absent(),
            Value<String> pos = const Value.absent(),
            Value<String> meaning = const Value.absent(),
            Value<String> definition = const Value.absent(),
            required String audioId,
            Value<String?> chapterId = const Value.absent(),
            Value<int> sourceOffsetMs = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VocabularyCompanion.insert(
            id: id,
            word: word,
            phonetic: phonetic,
            pos: pos,
            meaning: meaning,
            definition: definition,
            audioId: audioId,
            chapterId: chapterId,
            sourceOffsetMs: sourceOffsetMs,
            createdAt: createdAt,
            reviewCount: reviewCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$VocabularyTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {audioId = false,
              chapterId = false,
              wordMemoryRefs = false,
              reviewScheduleRefs = false,
              weaknessProfileRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (wordMemoryRefs) db.wordMemory,
                if (reviewScheduleRefs) db.reviewSchedule,
                if (weaknessProfileRefs) db.weaknessProfile
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (audioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.audioId,
                    referencedTable:
                        $$VocabularyTableReferences._audioIdTable(db),
                    referencedColumn:
                        $$VocabularyTableReferences._audioIdTable(db).id,
                  ) as T;
                }
                if (chapterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.chapterId,
                    referencedTable:
                        $$VocabularyTableReferences._chapterIdTable(db),
                    referencedColumn:
                        $$VocabularyTableReferences._chapterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (wordMemoryRefs)
                    await $_getPrefetchedData<VocabularyData, $VocabularyTable,
                            WordMemoryData>(
                        currentTable: table,
                        referencedTable: $$VocabularyTableReferences
                            ._wordMemoryRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VocabularyTableReferences(db, table, p0)
                                .wordMemoryRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.wordId == item.id),
                        typedResults: items),
                  if (reviewScheduleRefs)
                    await $_getPrefetchedData<VocabularyData, $VocabularyTable,
                            ReviewScheduleData>(
                        currentTable: table,
                        referencedTable: $$VocabularyTableReferences
                            ._reviewScheduleRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VocabularyTableReferences(db, table, p0)
                                .reviewScheduleRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.wordId == item.id),
                        typedResults: items),
                  if (weaknessProfileRefs)
                    await $_getPrefetchedData<VocabularyData, $VocabularyTable,
                            WeaknessProfileData>(
                        currentTable: table,
                        referencedTable: $$VocabularyTableReferences
                            ._weaknessProfileRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VocabularyTableReferences(db, table, p0)
                                .weaknessProfileRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.wordId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$VocabularyTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VocabularyTable,
    VocabularyData,
    $$VocabularyTableFilterComposer,
    $$VocabularyTableOrderingComposer,
    $$VocabularyTableAnnotationComposer,
    $$VocabularyTableCreateCompanionBuilder,
    $$VocabularyTableUpdateCompanionBuilder,
    (VocabularyData, $$VocabularyTableReferences),
    VocabularyData,
    PrefetchHooks Function(
        {bool audioId,
        bool chapterId,
        bool wordMemoryRefs,
        bool reviewScheduleRefs,
        bool weaknessProfileRefs})>;
typedef $$PlaybackStateTableCreateCompanionBuilder = PlaybackStateCompanion
    Function({
  required String audioId,
  Value<String?> lastChapterId,
  Value<int> lastPositionMs,
  Value<int> rowid,
});
typedef $$PlaybackStateTableUpdateCompanionBuilder = PlaybackStateCompanion
    Function({
  Value<String> audioId,
  Value<String?> lastChapterId,
  Value<int> lastPositionMs,
  Value<int> rowid,
});

final class $$PlaybackStateTableReferences extends BaseReferences<_$AppDatabase,
    $PlaybackStateTable, PlaybackStateData> {
  $$PlaybackStateTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AudioItemsTable _audioIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
          $_aliasNameGenerator(db.playbackState.audioId, db.audioItems.id));

  $$AudioItemsTableProcessedTableManager get audioId {
    final $_column = $_itemColumn<String>('audio_id')!;

    final manager = $$AudioItemsTableTableManager($_db, $_db.audioItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlaybackStateTableFilterComposer
    extends Composer<_$AppDatabase, $PlaybackStateTable> {
  $$PlaybackStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lastChapterId => $composableBuilder(
      column: $table.lastChapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastPositionMs => $composableBuilder(
      column: $table.lastPositionMs,
      builder: (column) => ColumnFilters(column));

  $$AudioItemsTableFilterComposer get audioId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableFilterComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaybackStateTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaybackStateTable> {
  $$PlaybackStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lastChapterId => $composableBuilder(
      column: $table.lastChapterId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastPositionMs => $composableBuilder(
      column: $table.lastPositionMs,
      builder: (column) => ColumnOrderings(column));

  $$AudioItemsTableOrderingComposer get audioId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableOrderingComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaybackStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaybackStateTable> {
  $$PlaybackStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lastChapterId => $composableBuilder(
      column: $table.lastChapterId, builder: (column) => column);

  GeneratedColumn<int> get lastPositionMs => $composableBuilder(
      column: $table.lastPositionMs, builder: (column) => column);

  $$AudioItemsTableAnnotationComposer get audioId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaybackStateTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaybackStateTable,
    PlaybackStateData,
    $$PlaybackStateTableFilterComposer,
    $$PlaybackStateTableOrderingComposer,
    $$PlaybackStateTableAnnotationComposer,
    $$PlaybackStateTableCreateCompanionBuilder,
    $$PlaybackStateTableUpdateCompanionBuilder,
    (PlaybackStateData, $$PlaybackStateTableReferences),
    PlaybackStateData,
    PrefetchHooks Function({bool audioId})> {
  $$PlaybackStateTableTableManager(_$AppDatabase db, $PlaybackStateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaybackStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaybackStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaybackStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> audioId = const Value.absent(),
            Value<String?> lastChapterId = const Value.absent(),
            Value<int> lastPositionMs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaybackStateCompanion(
            audioId: audioId,
            lastChapterId: lastChapterId,
            lastPositionMs: lastPositionMs,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String audioId,
            Value<String?> lastChapterId = const Value.absent(),
            Value<int> lastPositionMs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaybackStateCompanion.insert(
            audioId: audioId,
            lastChapterId: lastChapterId,
            lastPositionMs: lastPositionMs,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlaybackStateTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({audioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (audioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.audioId,
                    referencedTable:
                        $$PlaybackStateTableReferences._audioIdTable(db),
                    referencedColumn:
                        $$PlaybackStateTableReferences._audioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlaybackStateTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaybackStateTable,
    PlaybackStateData,
    $$PlaybackStateTableFilterComposer,
    $$PlaybackStateTableOrderingComposer,
    $$PlaybackStateTableAnnotationComposer,
    $$PlaybackStateTableCreateCompanionBuilder,
    $$PlaybackStateTableUpdateCompanionBuilder,
    (PlaybackStateData, $$PlaybackStateTableReferences),
    PlaybackStateData,
    PrefetchHooks Function({bool audioId})>;
typedef $$WordMemoryTableCreateCompanionBuilder = WordMemoryCompanion Function({
  required String wordId,
  Value<int> queryCount,
  Value<int> quizAttempts,
  Value<int> quizCorrect,
  Value<double> masteryLevel,
  Value<bool> weakFlag,
  Value<DateTime?> lastQueriedAt,
  Value<DateTime?> lastQuizzedAt,
  Value<int> rowid,
});
typedef $$WordMemoryTableUpdateCompanionBuilder = WordMemoryCompanion Function({
  Value<String> wordId,
  Value<int> queryCount,
  Value<int> quizAttempts,
  Value<int> quizCorrect,
  Value<double> masteryLevel,
  Value<bool> weakFlag,
  Value<DateTime?> lastQueriedAt,
  Value<DateTime?> lastQuizzedAt,
  Value<int> rowid,
});

final class $$WordMemoryTableReferences
    extends BaseReferences<_$AppDatabase, $WordMemoryTable, WordMemoryData> {
  $$WordMemoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VocabularyTable _wordIdTable(_$AppDatabase db) =>
      db.vocabulary.createAlias(
          $_aliasNameGenerator(db.wordMemory.wordId, db.vocabulary.id));

  $$VocabularyTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$VocabularyTableTableManager($_db, $_db.vocabulary)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WordMemoryTableFilterComposer
    extends Composer<_$AppDatabase, $WordMemoryTable> {
  $$WordMemoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get queryCount => $composableBuilder(
      column: $table.queryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quizAttempts => $composableBuilder(
      column: $table.quizAttempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quizCorrect => $composableBuilder(
      column: $table.quizCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get masteryLevel => $composableBuilder(
      column: $table.masteryLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get weakFlag => $composableBuilder(
      column: $table.weakFlag, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastQueriedAt => $composableBuilder(
      column: $table.lastQueriedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastQuizzedAt => $composableBuilder(
      column: $table.lastQuizzedAt, builder: (column) => ColumnFilters(column));

  $$VocabularyTableFilterComposer get wordId {
    final $$VocabularyTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableFilterComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WordMemoryTableOrderingComposer
    extends Composer<_$AppDatabase, $WordMemoryTable> {
  $$WordMemoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get queryCount => $composableBuilder(
      column: $table.queryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quizAttempts => $composableBuilder(
      column: $table.quizAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quizCorrect => $composableBuilder(
      column: $table.quizCorrect, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get masteryLevel => $composableBuilder(
      column: $table.masteryLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get weakFlag => $composableBuilder(
      column: $table.weakFlag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastQueriedAt => $composableBuilder(
      column: $table.lastQueriedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastQuizzedAt => $composableBuilder(
      column: $table.lastQuizzedAt,
      builder: (column) => ColumnOrderings(column));

  $$VocabularyTableOrderingComposer get wordId {
    final $$VocabularyTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableOrderingComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WordMemoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordMemoryTable> {
  $$WordMemoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get queryCount => $composableBuilder(
      column: $table.queryCount, builder: (column) => column);

  GeneratedColumn<int> get quizAttempts => $composableBuilder(
      column: $table.quizAttempts, builder: (column) => column);

  GeneratedColumn<int> get quizCorrect => $composableBuilder(
      column: $table.quizCorrect, builder: (column) => column);

  GeneratedColumn<double> get masteryLevel => $composableBuilder(
      column: $table.masteryLevel, builder: (column) => column);

  GeneratedColumn<bool> get weakFlag =>
      $composableBuilder(column: $table.weakFlag, builder: (column) => column);

  GeneratedColumn<DateTime> get lastQueriedAt => $composableBuilder(
      column: $table.lastQueriedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastQuizzedAt => $composableBuilder(
      column: $table.lastQuizzedAt, builder: (column) => column);

  $$VocabularyTableAnnotationComposer get wordId {
    final $$VocabularyTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableAnnotationComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WordMemoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WordMemoryTable,
    WordMemoryData,
    $$WordMemoryTableFilterComposer,
    $$WordMemoryTableOrderingComposer,
    $$WordMemoryTableAnnotationComposer,
    $$WordMemoryTableCreateCompanionBuilder,
    $$WordMemoryTableUpdateCompanionBuilder,
    (WordMemoryData, $$WordMemoryTableReferences),
    WordMemoryData,
    PrefetchHooks Function({bool wordId})> {
  $$WordMemoryTableTableManager(_$AppDatabase db, $WordMemoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordMemoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordMemoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordMemoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> wordId = const Value.absent(),
            Value<int> queryCount = const Value.absent(),
            Value<int> quizAttempts = const Value.absent(),
            Value<int> quizCorrect = const Value.absent(),
            Value<double> masteryLevel = const Value.absent(),
            Value<bool> weakFlag = const Value.absent(),
            Value<DateTime?> lastQueriedAt = const Value.absent(),
            Value<DateTime?> lastQuizzedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WordMemoryCompanion(
            wordId: wordId,
            queryCount: queryCount,
            quizAttempts: quizAttempts,
            quizCorrect: quizCorrect,
            masteryLevel: masteryLevel,
            weakFlag: weakFlag,
            lastQueriedAt: lastQueriedAt,
            lastQuizzedAt: lastQuizzedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String wordId,
            Value<int> queryCount = const Value.absent(),
            Value<int> quizAttempts = const Value.absent(),
            Value<int> quizCorrect = const Value.absent(),
            Value<double> masteryLevel = const Value.absent(),
            Value<bool> weakFlag = const Value.absent(),
            Value<DateTime?> lastQueriedAt = const Value.absent(),
            Value<DateTime?> lastQuizzedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WordMemoryCompanion.insert(
            wordId: wordId,
            queryCount: queryCount,
            quizAttempts: quizAttempts,
            quizCorrect: quizCorrect,
            masteryLevel: masteryLevel,
            weakFlag: weakFlag,
            lastQueriedAt: lastQueriedAt,
            lastQuizzedAt: lastQuizzedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WordMemoryTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (wordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.wordId,
                    referencedTable:
                        $$WordMemoryTableReferences._wordIdTable(db),
                    referencedColumn:
                        $$WordMemoryTableReferences._wordIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WordMemoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WordMemoryTable,
    WordMemoryData,
    $$WordMemoryTableFilterComposer,
    $$WordMemoryTableOrderingComposer,
    $$WordMemoryTableAnnotationComposer,
    $$WordMemoryTableCreateCompanionBuilder,
    $$WordMemoryTableUpdateCompanionBuilder,
    (WordMemoryData, $$WordMemoryTableReferences),
    WordMemoryData,
    PrefetchHooks Function({bool wordId})>;
typedef $$ContentMemoryTableCreateCompanionBuilder = ContentMemoryCompanion
    Function({
  required String audioId,
  Value<int> chaptersHeard,
  Value<int> wordsQueried,
  Value<DateTime?> lastHeardAt,
  Value<int> rowid,
});
typedef $$ContentMemoryTableUpdateCompanionBuilder = ContentMemoryCompanion
    Function({
  Value<String> audioId,
  Value<int> chaptersHeard,
  Value<int> wordsQueried,
  Value<DateTime?> lastHeardAt,
  Value<int> rowid,
});

final class $$ContentMemoryTableReferences extends BaseReferences<_$AppDatabase,
    $ContentMemoryTable, ContentMemoryData> {
  $$ContentMemoryTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AudioItemsTable _audioIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
          $_aliasNameGenerator(db.contentMemory.audioId, db.audioItems.id));

  $$AudioItemsTableProcessedTableManager get audioId {
    final $_column = $_itemColumn<String>('audio_id')!;

    final manager = $$AudioItemsTableTableManager($_db, $_db.audioItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ContentMemoryTableFilterComposer
    extends Composer<_$AppDatabase, $ContentMemoryTable> {
  $$ContentMemoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get chaptersHeard => $composableBuilder(
      column: $table.chaptersHeard, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordsQueried => $composableBuilder(
      column: $table.wordsQueried, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastHeardAt => $composableBuilder(
      column: $table.lastHeardAt, builder: (column) => ColumnFilters(column));

  $$AudioItemsTableFilterComposer get audioId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableFilterComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ContentMemoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentMemoryTable> {
  $$ContentMemoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get chaptersHeard => $composableBuilder(
      column: $table.chaptersHeard,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordsQueried => $composableBuilder(
      column: $table.wordsQueried,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastHeardAt => $composableBuilder(
      column: $table.lastHeardAt, builder: (column) => ColumnOrderings(column));

  $$AudioItemsTableOrderingComposer get audioId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableOrderingComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ContentMemoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentMemoryTable> {
  $$ContentMemoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get chaptersHeard => $composableBuilder(
      column: $table.chaptersHeard, builder: (column) => column);

  GeneratedColumn<int> get wordsQueried => $composableBuilder(
      column: $table.wordsQueried, builder: (column) => column);

  GeneratedColumn<DateTime> get lastHeardAt => $composableBuilder(
      column: $table.lastHeardAt, builder: (column) => column);

  $$AudioItemsTableAnnotationComposer get audioId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ContentMemoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContentMemoryTable,
    ContentMemoryData,
    $$ContentMemoryTableFilterComposer,
    $$ContentMemoryTableOrderingComposer,
    $$ContentMemoryTableAnnotationComposer,
    $$ContentMemoryTableCreateCompanionBuilder,
    $$ContentMemoryTableUpdateCompanionBuilder,
    (ContentMemoryData, $$ContentMemoryTableReferences),
    ContentMemoryData,
    PrefetchHooks Function({bool audioId})> {
  $$ContentMemoryTableTableManager(_$AppDatabase db, $ContentMemoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentMemoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentMemoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentMemoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> audioId = const Value.absent(),
            Value<int> chaptersHeard = const Value.absent(),
            Value<int> wordsQueried = const Value.absent(),
            Value<DateTime?> lastHeardAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentMemoryCompanion(
            audioId: audioId,
            chaptersHeard: chaptersHeard,
            wordsQueried: wordsQueried,
            lastHeardAt: lastHeardAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String audioId,
            Value<int> chaptersHeard = const Value.absent(),
            Value<int> wordsQueried = const Value.absent(),
            Value<DateTime?> lastHeardAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentMemoryCompanion.insert(
            audioId: audioId,
            chaptersHeard: chaptersHeard,
            wordsQueried: wordsQueried,
            lastHeardAt: lastHeardAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ContentMemoryTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({audioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (audioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.audioId,
                    referencedTable:
                        $$ContentMemoryTableReferences._audioIdTable(db),
                    referencedColumn:
                        $$ContentMemoryTableReferences._audioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ContentMemoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContentMemoryTable,
    ContentMemoryData,
    $$ContentMemoryTableFilterComposer,
    $$ContentMemoryTableOrderingComposer,
    $$ContentMemoryTableAnnotationComposer,
    $$ContentMemoryTableCreateCompanionBuilder,
    $$ContentMemoryTableUpdateCompanionBuilder,
    (ContentMemoryData, $$ContentMemoryTableReferences),
    ContentMemoryData,
    PrefetchHooks Function({bool audioId})>;
typedef $$AgentSessionsTableCreateCompanionBuilder = AgentSessionsCompanion
    Function({
  required String id,
  required String trigger,
  Value<String?> audioId,
  Value<String?> chapterId,
  Value<String> messagesJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AgentSessionsTableUpdateCompanionBuilder = AgentSessionsCompanion
    Function({
  Value<String> id,
  Value<String> trigger,
  Value<String?> audioId,
  Value<String?> chapterId,
  Value<String> messagesJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AgentSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $AgentSessionsTable, AgentSession> {
  $$AgentSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AudioItemsTable _audioIdTable(_$AppDatabase db) =>
      db.audioItems.createAlias(
          $_aliasNameGenerator(db.agentSessions.audioId, db.audioItems.id));

  $$AudioItemsTableProcessedTableManager? get audioId {
    final $_column = $_itemColumn<String>('audio_id');
    if ($_column == null) return null;
    final manager = $$AudioItemsTableTableManager($_db, $_db.audioItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.chapters.createAlias(
          $_aliasNameGenerator(db.agentSessions.chapterId, db.chapters.id));

  $$ChaptersTableProcessedTableManager? get chapterId {
    final $_column = $_itemColumn<String>('chapter_id');
    if ($_column == null) return null;
    final manager = $$ChaptersTableTableManager($_db, $_db.chapters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AgentSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $AgentSessionsTable> {
  $$AgentSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trigger => $composableBuilder(
      column: $table.trigger, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messagesJson => $composableBuilder(
      column: $table.messagesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AudioItemsTableFilterComposer get audioId {
    final $$AudioItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableFilterComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableFilterComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AgentSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $AgentSessionsTable> {
  $$AgentSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trigger => $composableBuilder(
      column: $table.trigger, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messagesJson => $composableBuilder(
      column: $table.messagesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AudioItemsTableOrderingComposer get audioId {
    final $$AudioItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableOrderingComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableOrderingComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AgentSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AgentSessionsTable> {
  $$AgentSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<String> get messagesJson => $composableBuilder(
      column: $table.messagesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AudioItemsTableAnnotationComposer get audioId {
    final $$AudioItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.audioId,
        referencedTable: $db.audioItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AudioItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.audioItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.chapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChaptersTableAnnotationComposer(
              $db: $db,
              $table: $db.chapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AgentSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AgentSessionsTable,
    AgentSession,
    $$AgentSessionsTableFilterComposer,
    $$AgentSessionsTableOrderingComposer,
    $$AgentSessionsTableAnnotationComposer,
    $$AgentSessionsTableCreateCompanionBuilder,
    $$AgentSessionsTableUpdateCompanionBuilder,
    (AgentSession, $$AgentSessionsTableReferences),
    AgentSession,
    PrefetchHooks Function({bool audioId, bool chapterId})> {
  $$AgentSessionsTableTableManager(_$AppDatabase db, $AgentSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgentSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgentSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgentSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> trigger = const Value.absent(),
            Value<String?> audioId = const Value.absent(),
            Value<String?> chapterId = const Value.absent(),
            Value<String> messagesJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgentSessionsCompanion(
            id: id,
            trigger: trigger,
            audioId: audioId,
            chapterId: chapterId,
            messagesJson: messagesJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String trigger,
            Value<String?> audioId = const Value.absent(),
            Value<String?> chapterId = const Value.absent(),
            Value<String> messagesJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AgentSessionsCompanion.insert(
            id: id,
            trigger: trigger,
            audioId: audioId,
            chapterId: chapterId,
            messagesJson: messagesJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AgentSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({audioId = false, chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (audioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.audioId,
                    referencedTable:
                        $$AgentSessionsTableReferences._audioIdTable(db),
                    referencedColumn:
                        $$AgentSessionsTableReferences._audioIdTable(db).id,
                  ) as T;
                }
                if (chapterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.chapterId,
                    referencedTable:
                        $$AgentSessionsTableReferences._chapterIdTable(db),
                    referencedColumn:
                        $$AgentSessionsTableReferences._chapterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AgentSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AgentSessionsTable,
    AgentSession,
    $$AgentSessionsTableFilterComposer,
    $$AgentSessionsTableOrderingComposer,
    $$AgentSessionsTableAnnotationComposer,
    $$AgentSessionsTableCreateCompanionBuilder,
    $$AgentSessionsTableUpdateCompanionBuilder,
    (AgentSession, $$AgentSessionsTableReferences),
    AgentSession,
    PrefetchHooks Function({bool audioId, bool chapterId})>;
typedef $$ReviewScheduleTableCreateCompanionBuilder = ReviewScheduleCompanion
    Function({
  required String wordId,
  required DateTime nextReviewAt,
  Value<int> reviewCount,
  Value<String> lastResult,
  Value<int> rowid,
});
typedef $$ReviewScheduleTableUpdateCompanionBuilder = ReviewScheduleCompanion
    Function({
  Value<String> wordId,
  Value<DateTime> nextReviewAt,
  Value<int> reviewCount,
  Value<String> lastResult,
  Value<int> rowid,
});

final class $$ReviewScheduleTableReferences extends BaseReferences<
    _$AppDatabase, $ReviewScheduleTable, ReviewScheduleData> {
  $$ReviewScheduleTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $VocabularyTable _wordIdTable(_$AppDatabase db) =>
      db.vocabulary.createAlias(
          $_aliasNameGenerator(db.reviewSchedule.wordId, db.vocabulary.id));

  $$VocabularyTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$VocabularyTableTableManager($_db, $_db.vocabulary)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReviewScheduleTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewScheduleTable> {
  $$ReviewScheduleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastResult => $composableBuilder(
      column: $table.lastResult, builder: (column) => ColumnFilters(column));

  $$VocabularyTableFilterComposer get wordId {
    final $$VocabularyTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableFilterComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReviewScheduleTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewScheduleTable> {
  $$ReviewScheduleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastResult => $composableBuilder(
      column: $table.lastResult, builder: (column) => ColumnOrderings(column));

  $$VocabularyTableOrderingComposer get wordId {
    final $$VocabularyTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableOrderingComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReviewScheduleTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewScheduleTable> {
  $$ReviewScheduleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
      column: $table.reviewCount, builder: (column) => column);

  GeneratedColumn<String> get lastResult => $composableBuilder(
      column: $table.lastResult, builder: (column) => column);

  $$VocabularyTableAnnotationComposer get wordId {
    final $$VocabularyTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableAnnotationComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReviewScheduleTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReviewScheduleTable,
    ReviewScheduleData,
    $$ReviewScheduleTableFilterComposer,
    $$ReviewScheduleTableOrderingComposer,
    $$ReviewScheduleTableAnnotationComposer,
    $$ReviewScheduleTableCreateCompanionBuilder,
    $$ReviewScheduleTableUpdateCompanionBuilder,
    (ReviewScheduleData, $$ReviewScheduleTableReferences),
    ReviewScheduleData,
    PrefetchHooks Function({bool wordId})> {
  $$ReviewScheduleTableTableManager(
      _$AppDatabase db, $ReviewScheduleTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewScheduleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewScheduleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewScheduleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> wordId = const Value.absent(),
            Value<DateTime> nextReviewAt = const Value.absent(),
            Value<int> reviewCount = const Value.absent(),
            Value<String> lastResult = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReviewScheduleCompanion(
            wordId: wordId,
            nextReviewAt: nextReviewAt,
            reviewCount: reviewCount,
            lastResult: lastResult,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String wordId,
            required DateTime nextReviewAt,
            Value<int> reviewCount = const Value.absent(),
            Value<String> lastResult = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReviewScheduleCompanion.insert(
            wordId: wordId,
            nextReviewAt: nextReviewAt,
            reviewCount: reviewCount,
            lastResult: lastResult,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReviewScheduleTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (wordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.wordId,
                    referencedTable:
                        $$ReviewScheduleTableReferences._wordIdTable(db),
                    referencedColumn:
                        $$ReviewScheduleTableReferences._wordIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReviewScheduleTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReviewScheduleTable,
    ReviewScheduleData,
    $$ReviewScheduleTableFilterComposer,
    $$ReviewScheduleTableOrderingComposer,
    $$ReviewScheduleTableAnnotationComposer,
    $$ReviewScheduleTableCreateCompanionBuilder,
    $$ReviewScheduleTableUpdateCompanionBuilder,
    (ReviewScheduleData, $$ReviewScheduleTableReferences),
    ReviewScheduleData,
    PrefetchHooks Function({bool wordId})>;
typedef $$WeaknessProfileTableCreateCompanionBuilder = WeaknessProfileCompanion
    Function({
  Value<int> id,
  required String wordId,
  Value<String> weakType,
  Value<String> context_,
  Value<DateTime> detectedAt,
});
typedef $$WeaknessProfileTableUpdateCompanionBuilder = WeaknessProfileCompanion
    Function({
  Value<int> id,
  Value<String> wordId,
  Value<String> weakType,
  Value<String> context_,
  Value<DateTime> detectedAt,
});

final class $$WeaknessProfileTableReferences extends BaseReferences<
    _$AppDatabase, $WeaknessProfileTable, WeaknessProfileData> {
  $$WeaknessProfileTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $VocabularyTable _wordIdTable(_$AppDatabase db) =>
      db.vocabulary.createAlias(
          $_aliasNameGenerator(db.weaknessProfile.wordId, db.vocabulary.id));

  $$VocabularyTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$VocabularyTableTableManager($_db, $_db.vocabulary)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WeaknessProfileTableFilterComposer
    extends Composer<_$AppDatabase, $WeaknessProfileTable> {
  $$WeaknessProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weakType => $composableBuilder(
      column: $table.weakType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get context_ => $composableBuilder(
      column: $table.context_, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnFilters(column));

  $$VocabularyTableFilterComposer get wordId {
    final $$VocabularyTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableFilterComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WeaknessProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $WeaknessProfileTable> {
  $$WeaknessProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weakType => $composableBuilder(
      column: $table.weakType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get context_ => $composableBuilder(
      column: $table.context_, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnOrderings(column));

  $$VocabularyTableOrderingComposer get wordId {
    final $$VocabularyTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableOrderingComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WeaknessProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeaknessProfileTable> {
  $$WeaknessProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get weakType =>
      $composableBuilder(column: $table.weakType, builder: (column) => column);

  GeneratedColumn<String> get context_ =>
      $composableBuilder(column: $table.context_, builder: (column) => column);

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => column);

  $$VocabularyTableAnnotationComposer get wordId {
    final $$VocabularyTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.wordId,
        referencedTable: $db.vocabulary,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabularyTableAnnotationComposer(
              $db: $db,
              $table: $db.vocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WeaknessProfileTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeaknessProfileTable,
    WeaknessProfileData,
    $$WeaknessProfileTableFilterComposer,
    $$WeaknessProfileTableOrderingComposer,
    $$WeaknessProfileTableAnnotationComposer,
    $$WeaknessProfileTableCreateCompanionBuilder,
    $$WeaknessProfileTableUpdateCompanionBuilder,
    (WeaknessProfileData, $$WeaknessProfileTableReferences),
    WeaknessProfileData,
    PrefetchHooks Function({bool wordId})> {
  $$WeaknessProfileTableTableManager(
      _$AppDatabase db, $WeaknessProfileTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaknessProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeaknessProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeaknessProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> wordId = const Value.absent(),
            Value<String> weakType = const Value.absent(),
            Value<String> context_ = const Value.absent(),
            Value<DateTime> detectedAt = const Value.absent(),
          }) =>
              WeaknessProfileCompanion(
            id: id,
            wordId: wordId,
            weakType: weakType,
            context_: context_,
            detectedAt: detectedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String wordId,
            Value<String> weakType = const Value.absent(),
            Value<String> context_ = const Value.absent(),
            Value<DateTime> detectedAt = const Value.absent(),
          }) =>
              WeaknessProfileCompanion.insert(
            id: id,
            wordId: wordId,
            weakType: weakType,
            context_: context_,
            detectedAt: detectedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WeaknessProfileTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (wordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.wordId,
                    referencedTable:
                        $$WeaknessProfileTableReferences._wordIdTable(db),
                    referencedColumn:
                        $$WeaknessProfileTableReferences._wordIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WeaknessProfileTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeaknessProfileTable,
    WeaknessProfileData,
    $$WeaknessProfileTableFilterComposer,
    $$WeaknessProfileTableOrderingComposer,
    $$WeaknessProfileTableAnnotationComposer,
    $$WeaknessProfileTableCreateCompanionBuilder,
    $$WeaknessProfileTableUpdateCompanionBuilder,
    (WeaknessProfileData, $$WeaknessProfileTableReferences),
    WeaknessProfileData,
    PrefetchHooks Function({bool wordId})>;
typedef $$LearningPatternsTableCreateCompanionBuilder
    = LearningPatternsCompanion Function({
  required String id,
  Value<String> estimatedLevel,
  Value<String> levelBasis,
  Value<String> activeHours,
  Value<int> avgSessionMin,
  Value<String> preferredTopics,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LearningPatternsTableUpdateCompanionBuilder
    = LearningPatternsCompanion Function({
  Value<String> id,
  Value<String> estimatedLevel,
  Value<String> levelBasis,
  Value<String> activeHours,
  Value<int> avgSessionMin,
  Value<String> preferredTopics,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LearningPatternsTableFilterComposer
    extends Composer<_$AppDatabase, $LearningPatternsTable> {
  $$LearningPatternsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estimatedLevel => $composableBuilder(
      column: $table.estimatedLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get levelBasis => $composableBuilder(
      column: $table.levelBasis, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activeHours => $composableBuilder(
      column: $table.activeHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get avgSessionMin => $composableBuilder(
      column: $table.avgSessionMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredTopics => $composableBuilder(
      column: $table.preferredTopics,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LearningPatternsTableOrderingComposer
    extends Composer<_$AppDatabase, $LearningPatternsTable> {
  $$LearningPatternsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estimatedLevel => $composableBuilder(
      column: $table.estimatedLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get levelBasis => $composableBuilder(
      column: $table.levelBasis, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activeHours => $composableBuilder(
      column: $table.activeHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get avgSessionMin => $composableBuilder(
      column: $table.avgSessionMin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredTopics => $composableBuilder(
      column: $table.preferredTopics,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LearningPatternsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearningPatternsTable> {
  $$LearningPatternsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get estimatedLevel => $composableBuilder(
      column: $table.estimatedLevel, builder: (column) => column);

  GeneratedColumn<String> get levelBasis => $composableBuilder(
      column: $table.levelBasis, builder: (column) => column);

  GeneratedColumn<String> get activeHours => $composableBuilder(
      column: $table.activeHours, builder: (column) => column);

  GeneratedColumn<int> get avgSessionMin => $composableBuilder(
      column: $table.avgSessionMin, builder: (column) => column);

  GeneratedColumn<String> get preferredTopics => $composableBuilder(
      column: $table.preferredTopics, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LearningPatternsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LearningPatternsTable,
    LearningPattern,
    $$LearningPatternsTableFilterComposer,
    $$LearningPatternsTableOrderingComposer,
    $$LearningPatternsTableAnnotationComposer,
    $$LearningPatternsTableCreateCompanionBuilder,
    $$LearningPatternsTableUpdateCompanionBuilder,
    (
      LearningPattern,
      BaseReferences<_$AppDatabase, $LearningPatternsTable, LearningPattern>
    ),
    LearningPattern,
    PrefetchHooks Function()> {
  $$LearningPatternsTableTableManager(
      _$AppDatabase db, $LearningPatternsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningPatternsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningPatternsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningPatternsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> estimatedLevel = const Value.absent(),
            Value<String> levelBasis = const Value.absent(),
            Value<String> activeHours = const Value.absent(),
            Value<int> avgSessionMin = const Value.absent(),
            Value<String> preferredTopics = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LearningPatternsCompanion(
            id: id,
            estimatedLevel: estimatedLevel,
            levelBasis: levelBasis,
            activeHours: activeHours,
            avgSessionMin: avgSessionMin,
            preferredTopics: preferredTopics,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> estimatedLevel = const Value.absent(),
            Value<String> levelBasis = const Value.absent(),
            Value<String> activeHours = const Value.absent(),
            Value<int> avgSessionMin = const Value.absent(),
            Value<String> preferredTopics = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LearningPatternsCompanion.insert(
            id: id,
            estimatedLevel: estimatedLevel,
            levelBasis: levelBasis,
            activeHours: activeHours,
            avgSessionMin: avgSessionMin,
            preferredTopics: preferredTopics,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LearningPatternsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LearningPatternsTable,
    LearningPattern,
    $$LearningPatternsTableFilterComposer,
    $$LearningPatternsTableOrderingComposer,
    $$LearningPatternsTableAnnotationComposer,
    $$LearningPatternsTableCreateCompanionBuilder,
    $$LearningPatternsTableUpdateCompanionBuilder,
    (
      LearningPattern,
      BaseReferences<_$AppDatabase, $LearningPatternsTable, LearningPattern>
    ),
    LearningPattern,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AudioItemsTableTableManager get audioItems =>
      $$AudioItemsTableTableManager(_db, _db.audioItems);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$TranscriptsTableTableManager get transcripts =>
      $$TranscriptsTableTableManager(_db, _db.transcripts);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$VocabularyTableTableManager get vocabulary =>
      $$VocabularyTableTableManager(_db, _db.vocabulary);
  $$PlaybackStateTableTableManager get playbackState =>
      $$PlaybackStateTableTableManager(_db, _db.playbackState);
  $$WordMemoryTableTableManager get wordMemory =>
      $$WordMemoryTableTableManager(_db, _db.wordMemory);
  $$ContentMemoryTableTableManager get contentMemory =>
      $$ContentMemoryTableTableManager(_db, _db.contentMemory);
  $$AgentSessionsTableTableManager get agentSessions =>
      $$AgentSessionsTableTableManager(_db, _db.agentSessions);
  $$ReviewScheduleTableTableManager get reviewSchedule =>
      $$ReviewScheduleTableTableManager(_db, _db.reviewSchedule);
  $$WeaknessProfileTableTableManager get weaknessProfile =>
      $$WeaknessProfileTableTableManager(_db, _db.weaknessProfile);
  $$LearningPatternsTableTableManager get learningPatterns =>
      $$LearningPatternsTableTableManager(_db, _db.learningPatterns);
}
