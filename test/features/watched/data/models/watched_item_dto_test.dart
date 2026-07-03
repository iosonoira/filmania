import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/watched/data/models/watched_item_dto.dart';
import 'package:filmania/features/watched/domain/entities/watched_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WatchedItemDto.isDropped', () {
    test('fromJson defaults to false when is_dropped is missing', () {
      final dto = WatchedItemDto.fromJson({
        'id': 'abc',
        'user_id': 'u1',
        'media_id': 42,
        'media_title': 'Breaking Bad',
        'media_type': 'tv',
      });

      expect(dto.isDropped, isFalse);
    });

    test('fromJson parses is_dropped true', () {
      final dto = WatchedItemDto.fromJson({
        'id': 'abc',
        'user_id': 'u1',
        'media_id': 42,
        'media_title': 'Breaking Bad',
        'media_type': 'tv',
        'is_dropped': true,
      });

      expect(dto.isDropped, isTrue);
    });

    test('toEntity carries isDropped through', () {
      const dto = WatchedItemDto(
        id: 'abc',
        userId: 'u1',
        mediaId: 42,
        mediaTitle: 'Breaking Bad',
        mediaType: 'tv',
        isDropped: true,
      );

      expect(dto.toEntity().isDropped, isTrue);
    });

    test('fromEntity carries isDropped through', () {
      final entity = WatchedItem(
        id: 'abc',
        userId: 'u1',
        mediaId: 42,
        mediaTitle: 'Breaking Bad',
        mediaType: MediaType.tv,
        watchedAt: DateTime(2026, 1, 1),
        isDropped: true,
      );

      expect(WatchedItemDto.fromEntity(entity).isDropped, isTrue);
    });
  });
}
