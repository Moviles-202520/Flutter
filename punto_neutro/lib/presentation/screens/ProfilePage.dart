import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFAFAFA),
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cs.primary.withOpacity(.2)),
              ),
              child: Icon(Icons.shield_outlined, size: 18, color: cs.primary),
            ),
            const SizedBox(width: 8),
            const Text('Punto Neutro', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('3', style: TextStyle(color: cs.onError, fontSize: 11)),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // ===== Cabecera perfil =====
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.person_rounded, size: 30),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Anonymous User',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          SizedBox(height: 2),
                          Text('Active session', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Add',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _badge(text: 'Trusted Verifier', icon: Icons.verified_user_rounded),
                    const SizedBox(width: 8),
                    _badge(text: 'Level 3', icon: Icons.star_rate_rounded, tone: _BadgeTone.info),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit profile'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ===== Métricas =====
          Row(
            children: const [
              Expanded(child: _StatTile(icon: Icons.visibility_outlined, value: '342', label: 'Articles read')),
              SizedBox(width: 12),
              Expanded(child: _StatTile(icon: Icons.flag_outlined, value: '12', label: 'Reports submitted')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _StatTile(icon: Icons.verified_outlined, value: '95%', label: 'Report accuracy')),
              SizedBox(width: 12),
              Expanded(child: _StatTile(icon: Icons.show_chart_rounded, value: '28', label: 'Day streak')),
            ],
          ),
          const SizedBox(height: 12),

          // ===== Tabs (simuladas) =====
          _card(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TabChip(text: 'Activity', selected: true),
                  _TabChip(text: 'Achievements'),
                  _TabChip(text: 'Settings'),
                  _TabChip(text: 'Bookmarks'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ===== Recent Activity =====
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 12),
                _ActivityItem(
                  icon: Icons.verified_outlined,
                  title: 'Advances in automatic verification technology',
                  subtitle: '2 hours ago',
                  pillText: 'Tech',
                ),
                SizedBox(height: 8),
                _ActivityItem(
                  icon: Icons.flag_outlined,
                  title: 'Reported fake news about vaccines',
                  subtitle: '5 hours ago',
                  pillText: 'Report',
                  pillColor: Color(0xFFFFF1F1),
                  pillTextColor: Colors.red,
                ),
                SizedBox(height: 8),
                _ActivityItem(
                  icon: Icons.bookmark_outline,
                  title: 'Saved article about digital security',
                  subtitle: 'Yesterday',
                  pillText: 'Saved',
                  pillColor: Color(0xFFFFF9E6),
                  pillTextColor: Color(0xFF8A6D00),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom bar solo de muestra (opcional)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Guide'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  // ==== helpers =====
  static Widget _card({required Widget child, EdgeInsets? padding}) => Container(
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black12),
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );

  static Widget _badge({
    required String text,
    required IconData icon,
    _BadgeTone tone = _BadgeTone.success,
  }) {
    final Color bg, fg;
    switch (tone) {
      case _BadgeTone.info:
        bg = const Color(0xFFE8F0FF);
        fg = const Color(0xFF2456E0);
        break;
      default:
        bg = const Color(0xFFE6F5EB);
        fg = const Color(0xFF1E7A3D);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: fg),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

enum _BadgeTone { success, info }

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatTile({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 72), // da margen vertical
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20),
            ),
            const SizedBox(width: 10),

            // <- importante: Flexible para que el texto pueda partir en 2 líneas
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // el valor puede escalar un poco sin romper
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: textScale > 1.1 ? 16 : 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- fuera de _StatTile (¡ojo a las llaves!) -----------------

class _TabChip extends StatelessWidget {
  final String text;
  final bool selected;
  const _TabChip({required this.text, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String pillText;
  final Color pillColor;
  final Color pillTextColor;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.pillText,
    this.pillColor = const Color(0xFFEFF4FF),
    this.pillTextColor = const Color(0xFF274BDB),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, size: 18, color: Colors.black87),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: pillColor, borderRadius: BorderRadius.circular(999)),
            child: Text(
              pillText,
              style: TextStyle(
                color: pillTextColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
