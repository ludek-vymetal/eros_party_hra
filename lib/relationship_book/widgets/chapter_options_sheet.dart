import 'package:flutter/material.dart';

import '../models/chapter_status.dart';
import '../models/relationship_chapter.dart';
import 'chapter_motto_dialog.dart';

enum ChapterOptionResult {
  favoriteToggled,
  mottoUpdated,
  archived,
  deleted,
}

class ChapterOptionsSheet extends StatelessWidget {
  final RelationshipChapter chapter;

  const ChapterOptionsSheet({
    super.key,
    required this.chapter,
  });

  static Future<ChapterOptionResult?> show(
    BuildContext context, {
    required RelationshipChapter chapter,
  }) {
    return showModalBottomSheet<ChapterOptionResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ChapterOptionsSheet(chapter: chapter),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = chapter.favorite;
    final isArchived = chapter.status == ChapterStatus.archived;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2C2421),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 25,
            offset: Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF8D7B68).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              chapter.chapterTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFF1E4C3),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF4A3E3D), height: 1),
            const SizedBox(height: 12),
            _buildOptionTile(
              context: context,
              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
              iconColor: const Color(0xFFC84B31),
              title: isFavorite ? 'Odebrat z oblíbených' : '❤️ Oblíbená',
              onTap: () {
                Navigator.pop(context, ChapterOptionResult.favoriteToggled);
              },
            ),
            _buildOptionTile(
              context: context,
              icon: Icons.auto_awesome,
              iconColor: const Color(0xFFD4AF37),
              title: '✨ Motto',
              onTap: () async {
                final newMotto = await showDialog<String>(
                  context: context,
                  builder: (ctx) => ChapterMottoDialog(
                    initialMotto: chapter.motto,
                  ),
                );
                if (newMotto != null && context.mounted) {
                  Navigator.pop(context, ChapterOptionResult.mottoUpdated);
                }
              },
            ),
            _buildOptionTile(
              context: context,
              icon: Icons.archive_outlined,
              iconColor: const Color(0xFF8D7B68),
              title: isArchived ? 'Vrátit z archivu' : '📦 Archiv',
              onTap: () {
                Navigator.pop(context, ChapterOptionResult.archived);
              },
            ),
            _buildOptionTile(
              context: context,
              icon: Icons.delete_outline,
              iconColor: const Color(0xFFE57373),
              title: '🗑 Přesunout do koše',
              onTap: () {
                Navigator.pop(context, ChapterOptionResult.deleted);
              },
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFF4A3E3D), height: 1),
            const SizedBox(height: 8),
            _buildOptionTile(
              context: context,
              icon: Icons.close,
              iconColor: const Color(0xFFA09385),
              title: '❌ Zavřít',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(icon, color: iconColor, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFECE0D1),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}