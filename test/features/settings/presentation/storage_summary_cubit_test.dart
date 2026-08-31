import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/settings/presentation/cubit/storage_summary_cubit.dart';
import 'package:audiobooks/features/settings/presentation/cubit/storage_summary_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAudiobookRepository extends Mock implements AudiobookRepository {}

class _MockDeviceFileGateway extends Mock implements DeviceFileGateway {}

void main() {
  late _MockAudiobookRepository audiobooks;
  late _MockDeviceFileGateway files;

  final book = Audiobook(
    id: 'book-1',
    title: 'The Quiet Listening Room',
    author: 'Local Audiobooks',
    dateAdded: DateTime(2026),
    fileType: AudioFileType.m4b,
  );

  setUp(() {
    audiobooks = _MockAudiobookRepository();
    files = _MockDeviceFileGateway();
  });

  test('measures the books and the space their audio takes', () async {
    when(() => audiobooks.watchAll()).thenAnswer((_) => Stream.value([book]));
    when(() => files.storedMediaBytes()).thenAnswer((_) async => 4194304);
    final cubit = StorageSummaryCubit(audiobooks, files);
    addTearDown(cubit.close);

    await cubit.measure();

    expect(cubit.state.status, StorageSummaryStatus.ready);
    expect(cubit.state.bookCount, 1);
    expect(cubit.state.usedBytes, 4194304);
  });

  test('reports a store that cannot be measured', () async {
    when(() => audiobooks.watchAll()).thenAnswer((_) => Stream.value([book]));
    when(() => files.storedMediaBytes()).thenAnswer((_) async => null);
    final cubit = StorageSummaryCubit(audiobooks, files);
    addTearDown(cubit.close);

    await cubit.measure();

    expect(cubit.state.status, StorageSummaryStatus.failure);
    expect(cubit.state.bookCount, 1);
  });

  test('survives a library that cannot be read', () async {
    when(
      () => audiobooks.watchAll(),
    ).thenAnswer((_) => Stream.error(StateError('unreadable')));
    final cubit = StorageSummaryCubit(audiobooks, files);
    addTearDown(cubit.close);

    await cubit.measure();

    expect(cubit.state.status, StorageSummaryStatus.failure);
  });
}
