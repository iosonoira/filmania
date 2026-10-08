import 'package:flutter/foundation.dart';
import 'package:filmania/core/domain/enums/media_type.dart';

/// Identifies a movie or TV series inside a multi-select selection [Set].
///
/// Equality is scoped to [mediaId] + [mediaType] only, so the same title
/// deduplicates correctly across sections/providers without requiring an
/// exact match on [title]/[posterPath] — while still carrying enough data
/// for bulk actions (add to watchlist, mark watched) to run without doing
/// an extra provider look-up per selected item.
@immutable
class MediaSelectionItem {
  const MediaSelectionItem({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
  });

  final int mediaId;
  final MediaType mediaType;
  final String title;
  final String? posterPath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaSelectionItem &&
          other.mediaId == mediaId &&
          other.mediaType == mediaType);

  @override
  int get hashCode => Object.hash(mediaId, mediaType);
}
