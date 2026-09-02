import 'package:audiobooks/core/shelf/local_shelf_folder_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('a document tree that names a folder on the device', () {
    test('reads the primary volume as the path it stands for', () {
      expect(
        LocalShelfFolderGateway.resolveDocumentTreePath(
          'content://com.android.externalstorage.documents/tree/primary%3ABooks%2FAudio',
        ),
        '/storage/emulated/0/Books/Audio',
      );
    });

    test('reads a memory card as its own volume', () {
      expect(
        LocalShelfFolderGateway.resolveDocumentTreePath(
          'content://com.android.externalstorage.documents/tree/1A2B-3C4D%3ABooks',
        ),
        '/storage/1A2B-3C4D/Books',
      );
    });

    test('reads the root of a volume', () {
      expect(
        LocalShelfFolderGateway.resolveDocumentTreePath(
          'content://com.android.externalstorage.documents/tree/primary%3A',
        ),
        '/storage/emulated/0',
      );
    });
  });

  group("a document tree that names nothing on disk", () {
    test("gives back nothing for a cloud provider's own store", () {
      expect(
        LocalShelfFolderGateway.resolveDocumentTreePath(
          'content://com.google.android.apps.docs.storage/tree/acc%3D1%3Bdoc%3Dencoded',
        ),
        isNull,
      );
    });

    test('gives back nothing for a tree with no document id', () {
      expect(
        LocalShelfFolderGateway.resolveDocumentTreePath(
          'content://com.android.externalstorage.documents/tree',
        ),
        isNull,
      );
    });

    test('gives back nothing for something that is not a uri', () {
      expect(LocalShelfFolderGateway.resolveDocumentTreePath('  :'), isNull);
    });
  });
}
